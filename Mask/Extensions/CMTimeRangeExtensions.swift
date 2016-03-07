//
//  CMTimeRangeExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/4/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import CoreMedia

extension CMTimeRange {
  
  func clampIn(maxDuration: CMTime) -> CMTimeRange {
    let _start = start.uniform(maxDuration).min(maxDuration)
    let _duration = _start.add(duration.uniform(maxDuration)).min(maxDuration).subtract(_start)
    return CMTimeRange(start: _start, duration: _duration)
  }
  
  func after(time: CMTime) -> CMTimeRange {
    return CMTimeRangeMake(time, duration)
  }
  
  func expandTo(time: CMTime) -> CMTimeRange {
    return CMTimeRangeMake(start, duration.add(start).max(time).subtract(start))
  }
  
  public var description: String {
    return "CMTimeRange [start: \(start) duration: \(duration)]"
  }
  
  public func contains(time: CMTime) -> Bool {
    return CMTimeRangeContainsTime(self, time)
  }
  
  var end: CMTime {
    return start.add(duration)
  }
}


