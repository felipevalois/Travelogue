//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Felipe Costa on 7/23/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
public class Entry: NSManagedObject {
    var date: Date?{
        get{
            return rawDate as Date?
        }
        set{
            rawDate = newValue as NSDate?
        }
    }
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                rawImage = convertImage(image: image)
            }
        }
    }
    
    func convertImage(image: UIImage) -> NSData? {
        if (image.imageOrientation == .up) {
            return image.pngData() as NSData?
        }
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image.pngData() as NSData?
        }
        return unwrappedCopy.pngData() as NSData?
    }
    
    convenience init?(title :String, content: String?, date:Date, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else{
                return nil
        }
        self.init(entity:Entry.entity(), insertInto: context)
        self.name = title
        self.content = content
        self.date = date
        if let image = image {
            self.rawImage = convertImage(image: image)
        }
    }
    
    func update(title: String?, content: String?, date: Date?, image: UIImage?){
        self.name = title
        self.date = date
        self.content = content
        if let image = image {
            self.rawImage = convertImage(image: image)
        }
    }
}
