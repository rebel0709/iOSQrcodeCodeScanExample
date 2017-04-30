//
//  ViewController.swift
//  7Leaves Card
//
//  Created by Jason McCoy on 12/17/16.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import StoreKit


class ViewController: UIViewController {
    
    //MARK: - Actions
    // Start QRCode reader ViewContoller
    @IBAction func editTapped(_ sender: UIButton) {
        print("edit Tapped.")
        //showAlert()
        self.readerDelegate.showQRAlert()
        checkForRedeemable()
        editOutlet.isHidden = true
        redeemStarsLblTxt.isHidden = true
    }
    
    // Called when pressing stamps
    @IBAction func selectAction(_ sender: UIButton) {
        latteButtonTapped(sender)
    }
    
    // Might be used when Authorizing (Not using now)
    @IBAction func doneTapped(_ sender: UIButton) {
        print("done Tapped.")
        UserDefaultsManager.saveDefaults(latteStamps: self.latteStamps, coffeeStamps: self.coffeeStamps)
        changeUIDoneEdit(state: false)
        isAuthorized = false
        let _ = updateUIOfMine()
        redeemStarsLblTxt.isHidden = true
    }
    
    // Might be used when will are Authorizing (Not using now)
    @IBAction func redeemTapped(_ sender: UIButton) {
        if isAuthorized == true {
            latteStamps = 0
            redeemOutlet.isHidden = true
            let _ = updateUIOfMine()
            doneTapped(doneOutlet)
        }
    }
    
    //MARK: - Variables
    
    @IBOutlet weak var redeemStarsLblTxt: UIImageView!
    @IBOutlet weak var doneOutlet: UIButton!
    @IBOutlet weak var editOutlet: UIButton!
    @IBOutlet weak var redeemOutlet: UIButton!
    @IBOutlet var latteButtonCollection: Array<UIButton>?
    
    var verificationCode: Array = verificationCodeArray
    
    var readerDelegate: QRCodeReaderDelegate! = QRCodeReaderDelegate()
    
    var latteStamps = 0
    var coffeeStamps = 0
    var isAuthorized: Bool = false
    var isLoaded = false
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readerDelegate.controller = self
        
        let (savedLatteStamps, savedCoffeeStamps) = UserDefaultsManager.loadDefaults()
        latteStamps = savedLatteStamps
        coffeeStamps = savedCoffeeStamps
        
        checkForRedeemable()
        
        if checkAvailable() == true {
            print(" Nice ")
        } else {
            print(" Expired ")
        }
        let _ = updateUIOfMine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaultsManager.saveDefaults(latteStamps: self.latteStamps, coffeeStamps: self.coffeeStamps)
    }
    
    //MARK: - Button functions
    
    // Called when stamp card is pressed
    func latteButtonTapped(_ sender:UIButton) {
        
        if isAuthorized == true {
            if sender.isSelected == true {
                latteStamps = latteStamps - 1
                sender.isSelected = false
            } else {
                latteStamps = latteStamps + 1
                sender.isSelected = true
            }
        }
        
        checkForRedeemable()
        Utils.checkLatteStamps(latteStamps: &latteStamps)
    }
    
    //MARK: - UI interaction functions
    // Changed UI from  QRCode reader ViewContoller
    func changeUI(state: Bool) {
        //state = true  editOutlet.isHidden = true redeemStarsLblTxt.isHidden = false
        self.editOutlet.isHidden = state
        self.redeemStarsLblTxt.isHidden = !state
    }
    
    // Changed UI after QRCode reader ViewContoller
    func changeUIDoneEdit(state: Bool) {
        //state = true  editOutlet.isHidden = true editOutlet.isHidden = false
        editOutlet.isHidden = state
        doneOutlet.isHidden = !state
    }

    // Checking that not more then 10 cards are available.
    func checkForRedeemable() {
        
        if 10 < self.latteStamps {
            self.latteStamps = self.latteStamps - 10
            self.redeemOutlet.isHidden = false
            
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        } else {
            self.redeemOutlet.isHidden = true
        }
    }
    
    // Change UI when QRCode was correct and accepted
    func updateUIOfMine()->UIButton? {
        var lastButton : UIButton? = nil
        for button in latteButtonCollection! {
            button.isSelected = false
            
            if button.tag <= latteStamps {
                button.isSelected = true
                lastButton = button
            }
        }
        return lastButton
    }
    
    //MARK: - checkAvailable
    func checkAvailable() -> Bool {
        let result = Utils.checkAvailable(latteStamps: &latteStamps)
        return result
    }
}
