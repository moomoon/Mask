//
//  CGFloatExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/7/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

private struct ScreenSize
{
  static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
  static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
  static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


struct DeviceType
{
  static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
  static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
  static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
  static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}


extension CGFloat {
  static var screenScale: CGFloat {
    let scale = UIScreen.mainScreen().scale
    return DeviceType.IS_IPHONE_6P ? scale / 1.15 : scale
//    return scale
  }
  
  func safe(value: CGFloat) -> CGFloat {
    if isNaN || isInfinite || isSubnormal {
      return value
    } else {
      return self
    }
  }
  
  func equal(other: CGFloat) -> Bool {
    return fabs(other - self) / self < 0.001
  }
  
  var ceiling: CGFloat {
    return ceil(self)
  }
  
  var floor: CGFloat {
    return round(self - 0.5)
  }
  
  var int: Int {
    return Int(self)
  }
  
  var reciprocal: CGFloat {
    return 1.0 / self
  }
  
  func max(other: CGFloat) -> CGFloat {
    return Swift.max(self, other)
  }
  
  func min(other: CGFloat) -> CGFloat {
    return Swift.min(self, other)
  }
  
  func clamp(min: CGFloat = 0, _ max: CGFloat = 1) -> CGFloat {
    return Swift.min(Swift.max(self, min), max)
  }
  
  func subtract(other: CGFloat) -> CGFloat {
    return self - other
  }
  
  func plus(other: CGFloat) -> CGFloat {
    return self + other
  }
  
  var pixels: CGFloat {
    return self * CGFloat.screenScale
  }
  
  var points: CGFloat {
    return self / CGFloat.screenScale
  }
}
