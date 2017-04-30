//
//  UserDefaultsManager.swift
//  7Leaves Card
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    
    //MARK: - NSUserDefaults functions
    
    static let kStampsNumber = "stampsNumber"
    static let kCoffeeStamps = "coffeeStamps"
    static let kCntStamps = "cntStamps"
    
    // Save data for latteStamps and coffeeStamps
    static func saveDefaults(latteStamps: Int, coffeeStamps: Int) {
        print("saved")
        let defaults = UserDefaults.standard
        let numberOfLattes = NSNumber(value: latteStamps)
        let numberOfCoffees = NSNumber(value: coffeeStamps)
        defaults.setValue(numberOfLattes, forKey: kStampsNumber)
        defaults.setValue(numberOfCoffees, forKey: kCoffeeStamps)
        defaults.synchronize()
    }
    
    // Upon app initialization, data is loaded for latteStamps and coffeeStamps
    static func loadDefaults() -> (Int, Int) {
        let defaults = UserDefaults.standard
        var latteStamps = 0
        var coffeeStamps = 0
        
        if let value = defaults.value(forKey: kStampsNumber) as? NSNumber {
            latteStamps = value.intValue
        }
        if let coffeeValue = defaults.value(forKey: kCoffeeStamps) as? NSNumber {
            coffeeStamps = coffeeValue.intValue
        }
        
        print("loaded stamps \(latteStamps)")
        
        return (latteStamps, coffeeStamps)
    }
    
    // Clear data for coffeeStamps
    static func cleanCoffeeStamps(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: kCoffeeStamps)
        userDefault.synchronize()
    }
    
    // Clear data for StampsNumber
    static func cleanStampsNumber(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: kStampsNumber)
        userDefault.synchronize()
    }
    
    // Clear data for CntStamps
    static func cleanCntStamps(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: kCntStamps)
        userDefault.synchronize()
    }
    
    // Save data for StampsNumber
    static func saveStampsNumber(value: Int) {
        let defaults = UserDefaults.standard
        let numberValue = NSNumber(value: value)
        defaults.setValue(numberValue, forKey: kStampsNumber)
        defaults.synchronize()
    }
    
    // Save data for CntStamps
    static func saveCntStamps(value: Date) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: kCntStamps)
        defaults.synchronize()
    }
    
    // Get data for CntStamps
    static func getCntStamps() -> Date? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: kCntStamps) as! Date?
    }
}
