//
//  Validation.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 09/02/18.
//  Copyright © 2018 Harish. All rights reserved.
//

import UIKit

public class Validation: NSObject {
    let nameAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    public class func email(_ testStr: String) -> Bool {
        let arr = testStr.components(separatedBy: "@")
        if arr.count != 2 {
            return false
        }
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                                                options: .caseInsensitive)
            return regex.firstMatch(in: testStr,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(location: 0, length: testStr.count)) != nil
        } catch {
            print("hgkjhgjkgh")
            return false
        }
    }
    public class func passwordValid(_ testStr: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]",
                                                options: .caseInsensitive)
            return regex.firstMatch(in: testStr,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(location: 0, length: testStr.count)) != nil
        } catch {
            print("hhhhhhhhh")
            return false
        }
    }
    public class func url (_ testStr: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                                                options: .caseInsensitive)
            return regex.firstMatch(in: testStr,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(location: 0, length: testStr.count)) != nil
        } catch {
            return false
        }
    }
    public class func fiscale(_ testStr: String) -> Bool {
        do {
            let lll1 = "[A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]"
            let lll2 = "{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}"
            let lll3 = "[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1}"
            let regex = try NSRegularExpression(pattern: lll1 + lll2 + lll3, options: .caseInsensitive)
            return regex.firstMatch(in: testStr,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(location: 0, length: testStr.count)) != nil
        } catch {
            return false
        }
    }
    public class func password (_ testStr: String) -> Bool {
        if testStr.count < 8 {
            return false
        }
        return true
    }
    public class func name(strTest: String) -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits
        if strTest.rangeOfCharacter(from: numberCharacters) != nil {
            return false
        } else if strTest.rangeOfCharacter(from: numberCharacters) == nil {
            return true
        }
        return true
    }
}
