//
//  CMTimeExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/4/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import CoreMedia


extension CMTime: CustomStringConvertible {
  
  var seconds: Double {
    return CMTimeGetSeconds(self)
  }
  
  func setSeconds(seconds: Double) -> CMTime {
    return CMTimeMake(Int64(seconds * Double(timescale)), timescale)
  }
  
  func max(other: CMTime) -> CMTime {
    return CMTimeMaximum(self, other)
  }
  
  func min(other: CMTime) -> CMTime {
    return CMTimeMinimum(self, other)
  }
  
  func add(other: CMTime) -> CMTime {
    return CMTimeAdd(self, other)
  }
  
  func subtract(other: CMTime) -> CMTime {
    return CMTimeSubtract(self, other)
  }
  
  func uniform(other: CMTime) -> CMTime {
    return CMTimeUniform(self, uniform: other)
  }
  
  // this could lead to Int32 overflow
  func divideBy(divisor: Int32) -> CMTime {
    return CMTimeMake(value, timescale * divisor)
  }
  
  func divideByDouble(divisor: Double) -> CMTime {
    return CMTimeMake(Int64(Double(value) / divisor), timescale)
  }
  
  var double: Double {
    return Double(value) / Double(timescale)
  }
  
  func compare(other: CMTime) -> Int {
    return Int(CMTimeCompare(self, other))
  }
  
  func greaterThan(other: CMTime) -> Bool {
    return compare(other) > 0
  }
  
  func greaterThanOrEqualTo(other: CMTime) -> Bool {
    return compare(other) >= 0
  }
  
  func lessThan(other: CMTime) -> Bool {
    return compare(other) < 0
  }
  
  func lessThanOrEqualTo(other: CMTime) -> Bool {
    return compare(other) <= 0
  }
  
  public var description: String {
    return "CMTime [value: \(value) timescale: \(timescale) seconds: \(Double(value) / Double(timescale))]"
  }
  
  
  func range(start start: CMTime) -> CMTimeRange {
    return CMTimeRange(start: start, duration: self)
  }
  
  func range(duration duration: CMTime) -> CMTimeRange {
    return CMTimeRange(start: self, duration: duration)
  }
}


func CMTimeUniform(altered: CMTime, uniform: CMTime) -> CMTime {
  return CMTimeMake(Int64(Double(altered.value) / Double(altered.timescale) * Double(uniform.timescale)), uniform.timescale)
}

func CMTimeDivide(dividend: CMTime, divisor: CMTime) -> Double {
  let uniformed = CMTimeUniform(dividend, uniform: divisor)
  return Double(uniformed.value) / Double(divisor.value)
}



