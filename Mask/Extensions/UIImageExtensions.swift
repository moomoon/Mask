//
//  UIImageExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 2/5/16.
//  Copyright © 2016 Kaipai. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
  
  // http://stackoverflow.com/questions/6496441/creating-a-uiimage-from-a-uicolor-to-use-as-a-background-image-for-uibutton
  
  class func newWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
  //  // http://stackoverflow.com/questions/11221966/how-to-change-size-of-thumb-image-of-uislider-programmatically
  //
  //  static func circleWith(fillColor: UIColor, size: CGSize) -> UIImage {
  //
  //    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
  //    let path = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: size))
  //    fillColor.setFill()
  //    path.fill()
  //    let newImage = UIGraphicsGetImageFromCurrentImageContext()
  //    UIGraphicsEndImageContext()
  //    return newImage
  //  }
  //  
}