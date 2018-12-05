//
//  Dictionary.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
class Dictionary1: NSDictionary {
}
public extension NSDictionary {
    public func string () -> String {
        do {
            let opt = JSONSerialization.WritingOptions.prettyPrinted
            let jsonData: NSData = try JSONSerialization.data(withJSONObject: self, options: opt) as NSData
            let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            return str.replacingOccurrences(of: "\n", with: "")
        } catch {
        }
        return "[]"
    }
    public func getMutable (_ mdd: NSMutableDictionary?) -> NSMutableDictionary? {
        let dict = self
        var mdd = mdd
        if mdd == nil {
            mdd = NSMutableDictionary ()
        }
        let arr = dict.allKeys
        for iii in 0..<arr.count {
            if let val = dict[arr[iii]] as? String {
                mdd?[arr[iii]] = val
            } else if let val = dict[arr[iii]] as? Double {
                mdd?[arr[iii]] = val
            } else if let val = dict[arr[iii]] as? Int {
                mdd?[arr[iii]] = val
            } else if let val = dict[arr[iii]] as? NSArray {
                mdd?[arr[iii]] = val.getMutable(nil)
            } else if let val = dict[arr[iii]] as? NSDictionary {
                mdd?[arr[iii]] = val.getMutable(nil)
            } else if let val = dict[arr[iii]] as? Float {
                mdd?[arr[iii]] = val
            }
        }
        return mdd
    }
    public func toString (_ caller: Bool = true) -> String {
        var str = "{"
        for (key, value) in self {
            let key = (key as? String)!
            if str.count == 1 {
                str = logicIf (key, str, value)
            } else {
                str = logicElse (key, str, value)
            }
        }
        if caller {
            return "\(str)}".colon ()
        } else {
            return "\(str)}"
        }
    }
    func logicIf (_ key: String, _ str: String, _ value: Any) -> String {
        var str = str
        if value is String {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        } else if value is Double {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        } else if value is Int {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        } else if let val = value as? NSArray {
            str = "\(str)\(key.colon ()):\(val.toString(false))"
        } else if value is NSDictionary {
            str = "\(str)\(key.colon ()):\(toString(false))"
        } else if value is Float {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        } else if value is Bool {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        } else if value is Double {
            str = "\(str)\(key.colon ()):\("\(value)".colon ())"
        }
        return str
    }
    func logicElse (_ key: String, _ str: String, _ value: Any) -> String {
        var str = str
        if value is String {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        } else if value is Double {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        } else if value is Int {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        } else if let val = value as? NSArray {
            str = "\(str),\(key.colon ()):\(val.toString(false))"
        } else if value is NSDictionary {
            str = "\(str),\(key.colon ()):\(toString(false))"
        } else if value is Float {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        } else if value is Bool {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        } else if value is Double {
            str = "\(str),\(key.colon ()):\("\(value)".colon ())"
        }
        return str
    }
}
