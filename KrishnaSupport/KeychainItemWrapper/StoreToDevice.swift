//
//  StoreToDevice.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 17/11/17.
//  Copyright © 2017 Harish. All rights reserved.
//

import UIKit
let keyChainItemWrapperIdentifier = "KeyChainItemWrapper_Identifier"
public class StoreToDevice: NSObject {
    static let obb = KeychainPasswordItem(service: "password1",
                                         account: "password2")
    public func setDeviceStoredData (_ data: String) {
        do {
            try StoreToDevice.obb.savePassword(data)
        } catch {
        }
    }
    public func getStoredData () -> String? {
        do {
            return try StoreToDevice.obb.readPassword()
        } catch { }
        return nil
    }
}
