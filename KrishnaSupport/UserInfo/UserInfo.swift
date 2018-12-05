//
//  UserInfo.swift
//  Zooma
//
//  Created by Avinash somani on 26/12/16.
//  Copyright © 2016 Harish. All rights reserved.
//

import UIKit
open class UserInfo: NSObject, NSCoding {
    var date = ""
    var email = ""
    var firstName = ""
    var idD = ""
    var image = ""
    var lastName = ""
    var password = ""
    var status = ""
    var time = ""
    var allowedTime = ""
    var amout = ""
    var categoryId = ""
    var categoryName = ""
    var eventDate = ""
    var eventDuration = ""
    var eventStatus = ""
    var name = ""
    var startTime = ""
    var paypalId = ""
    var referralCode = ""
    override public init() {
    }
    public init(_ date: String, _ email: String, _ firstName: String, _ idD: String,
                _ image: String, _ lastName: String, _ password: String, _ status: String,
                _ time: String, _ allowedTime: String, _ amout: String, _ categoryId: String,
                _ categoryName: String, _ eventDate: String, _ eventDuration: String,
                _ eventStatus: String, _ name: String, _ startTime: String, _ paypalId: String,
                referralcode: String) {
        self.date = date
        self.email = email
        self.firstName = firstName
        self.idD = idD
        self.image = image
        self.lastName = lastName
        self.password = password
        self.status = status
        self.time = time
        self.allowedTime = allowedTime
        self.amout = amout
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.eventDate = eventDate
        self.eventDuration = eventDuration
        self.eventStatus = eventStatus
        self.name = name
        self.startTime = startTime
        self.paypalId = paypalId
        self.referralCode = referralcode
    }
    open func encode(with aCoder: NSCoder) {
    }
    public required init?(coder aDecoder: NSCoder) {
    }
    class public func archivePeople(_ people: UserInfo) -> NSData {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: people)
        return archivedObject as NSData
    }
    class public func retrievePeople(_ data: NSData) -> UserInfo {
        return (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserInfo)!
    }
    class public func save (_ obb: UserInfo) {
        let defaults = UserDefaults.standard
        defaults.set(archivePeople(obb), forKey: "LoginInfo")
        defaults.synchronize()
    }
    public func save () {
        UserInfo.save(self)
    }
    public class func logout () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "LoginInfo")
        defaults.synchronize()
    }
    open class func user1() -> Any? {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "LoginInfo") != nil {
            let data = (defaults.object(forKey: "LoginInfo") as? NSData)!
            return retrievePeople(data)
        } else {
            return nil
        }
    }
    open func user() ->  Any? {
        return UserInfo.user1()
    }
}
