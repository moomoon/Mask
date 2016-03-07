//
//  IntExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 2/5/16.
//  Copyright © 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore

extension Int {
  var int32: Int32 {
    return Int32(self)
  }
  var uint: UInt {
    return UInt(self)
  }
  
  var int64: Int64 {
    return Int64(self)
  }
  
  var cgfloat: CGFloat {
    return CGFloat(self)
  }
  
  var float: Float {
    return Float(self)
  }
  
  func greaterThan(other: Int) -> Bool {
    return self > other
  }
  
  func lessThan(other: Int) -> Bool {
    return self < other
  }
  
  func gcd(other: Int) -> Int{
    if self * other == 0 { return 0 }
    var x = Swift.max(self, other)
    var y = Swift.min(self, other)
    var remainder = x
    while true {
      remainder = x % y
      if remainder == 0 {
        return y
      } else {
        x = y
        y = remainder
      }
    }
    
  }
  
  var shortText: String {
    if self < 1000 {
      return "\(self)"
    } else {
      let formatter = NSNumberFormatter()
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 1
      return formatter.stringFromNumber(NSNumber(float: float / 1000))! + "k"
    }
  }
  
  func max(other: Int) -> Int {
    return Swift.max(self, other)
  }
  
  func min(other: Int) -> Int {
    return Swift.min(self, other)
  }
}

