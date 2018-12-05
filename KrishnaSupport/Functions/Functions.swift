//
//  Functions.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/07/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
import MapKit
public protocol AlertDelegate: class {
    func alertZero ()
    func alertOne ()
}
class Functions: NSObject { }
public func getImageSizeByUIScreen (_ size: CGSize) -> CGSize {
    var width = size.width
    var height = size.height
    if size.width > UIScreen.main.bounds.width {
        width = UIScreen.main.bounds.width
        let scale = width / size.width
        height = size.height * scale
    } else if size.height > UIScreen.main.bounds.height {
        height = UIScreen.main.bounds.height
        let scale = height / size.height
        width = size.width * scale
    }
    return CGSize(width: width, height: height)
}
public func filterByPrice (_ maA: NSMutableArray, _ high: Bool) -> NSMutableArray {
    class Item: NSObject {
        var price: Double = 0.0
    }
    var swiftArray = maA as NSArray as? [Item]
    if high {
        swiftArray = swiftArray?.sorted { $0.price < $1.price }
    } else {
        swiftArray = swiftArray?.sorted { $0.price > $1.price }
    }
    return NSMutableArray(array: swiftArray!)
}
public func array (_ dict: NSDictionary, _ key: String) -> [Any]? {
    if let title = dict[key] as? [Any] {
        return title
    } else {
        return nil
    }
}
public func dictionary (_ dict: NSDictionary, _ key: String) -> [String: Any]? {
    if let title = dict[key] as? [String: Any] {
        return title
    } else {
        return nil
    }
}
public func string (_ dict: NSDictionary, _ key: String) -> String {
    if let title = dict[key] as? String {
        return "\(title)"
    } else if let title = dict[key] as? NSNumber {
        return "\(title)"
    } else {
        return ""
    }
}
public func number (_ dict: NSDictionary, _ key: String) -> NSNumber {
    if let title = dict[key] as? NSNumber {
        return title
    } else if let title = dict[key] as? String {
        if let title1 = Int(title) as Int? {
            return NSNumber(value: title1)
        } else if let title1 = Float(title) as Float? {
            return NSNumber(value: title1)
        } else if let title1 = Double(title) as Double? {
            return NSNumber(value: title1)
        } else if let title1 = Bool(title) as Bool? {
            return NSNumber(value: title1)
        }
        return 0
    } else {
        return 0
    }
}
public func bool (_ dict: NSDictionary, _ key: String) -> Bool {
    if let title = dict[key] as? Bool {
        return title
    } else {
        return false
    }
}
public func niil (_ dict: NSDictionary, _ key: String) -> String? {
    if let title = dict[key] as? String {
        return title
    } else {
        return nil
    }
}
public func nullToNil(value: AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}
public func isNull(value: AnyObject?) -> Bool {
    if value == nil {
        return true
    } else if value is NSNull {
        return true
    } else {
        return false
    }
}
public func callNumber(_ phoneNumber: String) {
    if let phoneCallURL: NSURL = NSURL(string: "tel://\(phoneNumber)") {
        let application: UIApplication = UIApplication.shared
        if application.canOpenURL(phoneCallURL as URL) {
            if #available(iOS 10.0, *) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
            } else {
                application.openURL(phoneCallURL as URL)
            }
        } else {
            Http.alert("", "Phone call not available.")
        }
    } else {
        Http.alert("", "Phone call not available.")
    }
}
public func getAddressOrLatLong (_ lat: NSNumber?, _ long: NSNumber?,
                                 _ addr: String?, _ prnt: Bool) -> AddressObject? {
        let reach = ReachabilityKrishna.init(hostname: "google.com")
        if prnt {
            print("lat-\(String(describing: lat))-")
            print("long-\(String(describing: long))-")
            print("addr-\(String(describing: addr))-")
        }
        if lat == nil && long == nil && addr == nil {
            return nil
        } else {
            if (reach?.isReachable)! {
                var api = "https://maps.google.com/maps/api/geocode/json?sensor=false&"
                if lat != nil && long != nil {
                    api += "latlng=\(lat!),\(long!)"
                } else if addr != nil {
                    api += "address=\(addr!)"
                }
                if prnt {
                    print("api-\(api)-")
                }
                return getJsonAddressOrLatLong(api, lat, long, addr, prnt)
            }
        }
        return nil
}
func getJsonAddressOrLatLong (_ api: String, _ lat: NSNumber?, _ long: NSNumber?,
                              _ addr: String?, _ prnt: Bool) -> AddressObject {
    do {
        let data = NSData(contentsOf: URL(string: api)!)
        if data != nil {
            let json: NSDictionary? = try JSONSerialization.jsonObject(with: data! as Data,
                                                                       options: .allowFragments)
                as? NSDictionary
            if prnt {
                print("json-\(String(describing: json))-")
            }
            if json != nil {
                let status = string(json!, "status")
                if status == "OK" {
                    if let results = json?["results"] as? NSArray {
                        for iii in 0..<results.count {
                            if let obb = returnAddressLatLong(lat, long, results, iii, addr) {
                                return obb
                            }
                            break
                        }
                    }
                }
            }
        }
    } catch _ as NSError {
        return AddressObject(nil)
    }
    return AddressObject(nil)
}
func returnAddressLatLong(_ lat: NSNumber?, _ long: NSNumber?,
                          _ results: NSArray, _ iii: Int, _ addr: String?) -> AddressObject? {
    let addressObject = AddressObject(nil)
    if lat != nil && long != nil {
        if let dtt = results[iii] as? NSDictionary {
            let address = string(dtt, "formatted_address")
            addressObject.address = address
            return addressObject
        }
    } else if addr != nil {
        if let dtt = results[iii] as? NSDictionary {
            if let geometry = dtt["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let lat = string(location, "lat")
                    let lng = string(location, "lng")
                    if lat.count > 0 && lng.count > 0 {
                        addressObject.lat = lat
                        addressObject.long = lng
                        return addressObject
                    }
                }
            }
        }
    }
    return nil
}
public class AddressObject {
    init(_ address: String?) {
        self.address = address
    }
    var lat: String?
    var long: String?
    var address: String?
}
func langUI (_ view: UIView?) {
    if view != nil {
        if view?.superview != nil {
            var frame1 = view!.frame
            frame1.origin.x = CGFloat((view?.superview?.frame.size.width)! - frame1.size.width - frame1.origin.x)
            view?.frame = frame1
        }
        for vvv in (view?.subviews)! {
            if vvv.tag == 100 {
                continue
            }
            if vvv is UIScrollView {
                langUI(vvv)
            } else if vvv is UILabel
                || vvv is UITextField
                || vvv is UITextView
                || vvv is UIButton
                || vvv is UITableView
                || vvv is UITableViewCell
                || vvv is UIImageView
                || vvv is UISlider
                || vvv is UISearchBar
                || vvv is UIActivityIndicatorView
                || vvv is UISwitch
                || vvv is UISegmentedControl
                || vvv is UIProgressView
                || vvv is UIPageControl
                || vvv is UIStepper
                || vvv is UICollectionView
                || vvv is UICollectionViewCell
                || vvv is UIDatePicker
                || vvv is UIPickerView
                || vvv is UIWebView
                || vvv is UINavigationBar
                || vvv is UIToolbar
                || vvv is UITabBar
                || vvv is MKMapView {
                langWork (view, vvv)
            } else {
                langUI(vvv)
            }
        }
    }
}
func langWork (_ view: UIView?, _ vvv: UIView) {
    if view is UIScrollView {
        let view = (view as? UIScrollView)!
        var frame = vvv.frame
        frame.origin.x = view.contentSize.width - frame.size.width - frame.origin.x
        vvv.frame = frame
    } else {
        var frame = vvv.frame
        frame.origin.x = (view?.frame.size.width)! - frame.size.width - frame.origin.x
        vvv.frame = frame
    }
    if vvv is UILabel {
        let vvv = (vvv as? UILabel)!
        if vvv.textAlignment == .left || vvv.textAlignment == .natural {
            vvv.textAlignment = .right
        } else if vvv.textAlignment == .right {
            vvv.textAlignment = .left
        }
    } else if vvv is UITextField {
        let vvv = (vvv as? UITextField)!
        if vvv.textAlignment == .left || vvv.textAlignment == .natural {
            vvv.textAlignment = .right
        } else if vvv.textAlignment == .right {
            vvv.textAlignment = .left
        }
    } else if vvv is UITextView {
        let vvv = (vvv as? UITextView)!
        if vvv.textAlignment == .left || vvv.textAlignment == .natural {
            vvv.textAlignment = .right
        } else if vvv.textAlignment == .right {
            vvv.textAlignment = .left
        }
    }
}
