//
//  QRCodeReaderDelegate.swift
//  7Leaves Card
//
//  Created by Jason McCoy on 12/17/16.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader


class QRCodeReaderDelegate: NSObject, QRCodeReaderViewControllerDelegate {
    
    weak var controller: ViewController!
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    // MARK: - QRCodeReader Delegate Methods
    
    // Delegate of QRCode reader ViewContoller
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        self.controller.dismiss(animated: true){ [unowned self] in
            if result.value == self.controller.verificationCode[0] || result.value == self.controller.verificationCode[1] { // TO DO: Show "Success!" image or popup.
                print("Approved!")
                
                Alert.show(controller: self.controller, title: "", message: AlertMessage.StampAdded.rawValue, action: {
                    DispatchQueue.main.async {
                        //self.controller.latteStamps += 1
                        var count = 1
                        
                        if(result.value == self.controller.verificationCode[0]) {
                            self.controller.latteStamps += 1
                        } else {
                            self.controller.latteStamps += 1
                            count = 2
                        }
                        
                        self.controller.coffeeStamps = 0
                        self.controller.checkForRedeemable()
                        let _ = self.controller.updateUIOfMine()
                        UserDefaultsManager.saveDefaults(latteStamps: self.controller.latteStamps, coffeeStamps: self.controller.coffeeStamps)
                        self.controller.changeUIDoneEdit(state: false)
                        self.controller.isAuthorized = false
                        self.controller.updateUIOfMine()?.playExplicitBounceAnimation()
                        Utils.playSound()
                        
                        if (count == 2) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
                                self.controller.latteStamps += 1
                                self.controller.checkForRedeemable()
                                self.controller.updateUIOfMine()?.playExplicitBounceAnimation()
                                Utils.playSound()
                                let _ = self.controller.updateUIOfMine()
                                UserDefaultsManager.saveDefaults(latteStamps: self.controller.latteStamps, coffeeStamps: self.controller.coffeeStamps)
                            })
                        }
                        self.controller.redeemStarsLblTxt.isHidden = true
                    }
                })
            } else { // TO DO: Show "Failed!" image or popup.
                // Fails authorization
                Alert.show(controller: self.controller, title: "", message: AlertMessage.InvalidQRCode.rawValue, action: {
                    DispatchQueue.main.async {
                        //self.controller.ScanQRCode(scannedString: "", isSuccess: false)
                        self.controller.changeUI(state: false)
                        print("Authorization Failed!")
                    }
                })
            }
        }
        // dismiss(animated: true)
    }
    
    // Call when switch between front and back camera
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    // Cancel button on QRCode reader ViewContoller
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        self.controller.dismiss(animated: true, completion: nil)
        self.controller.changeUI(state: false)
    }
    
    //MARK: - Alert set up
    
    // Show alert for Authorization
    func showAlert() {
        
        Alert.showWithTextField(controller: self.controller, title: "Password Required!", message: "Please allow the store employee to type the super secret password onto your phone please!", done: {
            
            self.controller.latteStamps = 0
            self.controller.coffeeStamps = 0
            UserDefaultsManager.saveDefaults(latteStamps: self.controller.latteStamps, coffeeStamps: self.controller.coffeeStamps)
            let _ = self.controller.updateUIOfMine()
            self.controller.changeUIDoneEdit(state: true)
            self.controller.isAuthorized = true
        }, cancel: {
            self.controller.changeUI(state: false)
        })
    }
    
    // Start QRCode reader ViewContoller
    func showQRAlert() {
        let result =  QRCodeReader.supportsMetadataObjectTypes()
        if result {
            reader.modalPresentationStyle = .formSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
            self.controller.present(reader, animated: true, completion: nil)
        }
    }
}
