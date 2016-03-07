//
//  DoubleExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 2/5/16.
//  Copyright © 2016 Kaipai. All rights reserved.
//

import Foundation
import CoreMedia

extension Double {
    var comps = [Int]()
    var remainder = self
    for u in units {
      let c = Int(remainder / u)
      remainder -= Double(c) * u
      comps.append(c)
    }
    comps.append(Int(remainder)e
    return comps
  }
  
  var friendlyDuration: String {
    let components = (self * 10).components(600, 10)
    return String(format: "%02d:%02d.%d", components[0], components[1], components[2])
  }
  
  var durationText: String {
    return String(format: "%.1f", self)
  }
  
  var CMTime9000: CMTime {
    return CMTimeMake(Int64(self * 9000), 9000)
  }
  
  func cmtimeUniform(other: CMTime) -> CMTime {
    return CMTimeMake(Int64(self * Double(other.timescale)), other.timescale)
  }
  
  var floor: Double {
    return round(self - 0.5)
  }
  
  var ceil: Double {
    return round(self + 0.5)
  }
  
  var int: Int {
    return Int(self)
  }
  
  var cgfloat: CGFloat {
    return CGFloat(self)
  }
}

