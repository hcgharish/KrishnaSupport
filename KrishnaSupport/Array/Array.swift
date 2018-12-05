//
//  Array.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
class Array1: NSArray {
}
public extension NSArray {
    public func string () -> String {
        do {
            let opt = JSONSerialization.WritingOptions.prettyPrinted
            let jsonData: NSData = try JSONSerialization.data(withJSONObject: self,
                                                              options: opt) as NSData
                    let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                    return str.replacingOccurrences(of: "\n", with: "")
        } catch {
                }
            return "[]"
    }
    public func getMutable (_ maA: NSMutableArray?) -> NSMutableArray? {
        let array = self
            var maA = maA
            if maA == nil {
            maA = NSMutableArray ()
        }
            for iii in 0..<array.count {
            if let val = array[iii] as? String {
                maA?.add(val)
            } else if let val = array[iii] as? Double {
                maA?.add(val)
            } else if let val = array[iii] as? Int {
                maA?.add(val)
            } else if let val = array[iii] as? NSArray {
                maA?.add(val.getMutable(nil)!)
            } else if let val = array[iii] as? NSDictionary {
                maA?.add(val.getMutable(nil)!)
            } else if let val = array[iii] as? Float {
                maA?.add(val)
            }
        }
            return maA
    }
    public func toString (_ caller: Bool = true) -> String {
        var str = "["
        for iii in 0..<self.count {
            if str.count == 1 {
                str = logincIf(str, iii)
            } else {
                str = logincElse(str, iii)
            }
        }
        if caller {
            return "\(str)]".colon ()
        } else {
            return "\(str)]"
        }
    }
    func logincElse(_ str: String, _ iii: Int) -> String {
        var str = str
        if let val = self[iii] as? String {
            str = "\(str),\(val.colon ())"
        } else if let val = self[iii] as? Double {
            str = "\(str),\("\(val)".colon ())"
        } else if let val = self[iii] as? Int {
            str = "\(str),\("\(val)".colon ())"
        } else if let val = self[iii] as? NSArray {
            str = "\(str),\(val.toString(false))"
        } else if let val = self[iii] as? NSDictionary {
            str = "\(str),\(val.toString(false))"
        } else if let val = self[iii] as? Float {
            str = "\(str),\("\(val)".colon ())"
        } else if let val = self[iii] as? Bool {
            str = "\(str),\("\(val)".colon ())"
        } else if let val = self[iii] as? Double {
            str = "\(str),\("\(val)".colon ())"
        }
        return str
    }
    func logincIf(_ str: String, _ iii: Int) -> String {
        var str = str
        if let val = self[iii] as? String {
            str = "\(str)\(val.colon ())"
        } else if let val = self[iii] as? Double {
            str = "\(str)\("\(val)".colon ())"
        } else if let val = self[iii] as? Int {
            str = "\(str)\("\(val)".colon ())"
        } else if let val = self[iii] as? NSArray {
            str = "\(str)\(val.toString(false))"
        } else if let val = self[iii] as? NSDictionary {
            str = "\(str)\(val.toString(false))"
        } else if let val = self[iii] as? Float {
            str = "\(str)\("\(val)".colon ())"
        } else if let val = self[iii] as? Bool {
            str = "\(str)\("\(val)".colon ())"
        } else if let val = self[iii] as? Double {
            str = "\(str)\("\(val)".colon ())"
        }
        return str
    }
}
