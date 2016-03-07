//
//  CGVectorExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/5/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore


extension CGVector: CustomStringConvertible {
  init(from: CGPoint, to: CGPoint) {
     self.init(dx: to.x - from.x, dy: to.y - from.y)
  }
  
  var magnitude: CGFloat {
    return sqrt(dx * dx + dy * dy)
  }
  
  func angleTo(other: CGVector) -> CGFloat {
    
      func dot(p1: CGVector, p2: CGVector) -> CGFloat {
        return p1.dx * p2.dx + p1.dy * p2.dy
      }
      
      // A . B = |A| * |B| * cos(angle)
      func angle2(a: CGVector, b: CGVector) -> CGFloat {
        if a == b {
          return 0
        }
        let cos = dot(a, p2: b) / (a.magnitude * b.magnitude)
        return acos(cos)
      }
      
      //http://math.stackexchange.com/questions/74307/two-2d-vector-angle-clockwise-predicate
      func clockwise(a: CGVector, b: CGVector) -> CGFloat {
        return (a.dy * b.dx - a.dx * b.dy) > 0 ? 1 : -1
      }
    
      return angle2(other, b: self) * clockwise(other, b: self)
  }
  
  func transformTo(other: CGVector) -> CGAffineTransform {
    return CGAffineTransform.makeScale(other.magnitude / magnitude).rotate(angleTo(other))
  }
  
  public var description: String {
    return "CGVector [dx: \(dx), dy: \(dy)]"
  }
}