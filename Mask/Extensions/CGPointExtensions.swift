//
//  CGPointExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/5/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore



extension CGPoint {
  
  func clampInRect(rect: CGRect) -> CGPoint {
    return min(rect.bottomRight).max(rect.topLeft)
  }
  
  func containedInRect(rect: CGRect, @autoclosure orElse other: () -> CGPoint) -> CGPoint {
    return rect.contains(self) ? self : other()
  }
  
  func containedInRect(rect: CGRect, @autoclosure orElse other: () -> CGPoint?) -> CGPoint? {
    return rect.contains(self) ? self : other()
  }
  
  func transform(trans: CGAffineTransform) -> CGPoint {
    return CGPointApplyAffineTransform(self, trans)
  }
  
  var floor: CGPoint {
    return CGPoint(x: x.floor, y: y.floor)
  }
  
  func offset(dx: CGFloat, _ dy: CGFloat) -> CGPoint {
    return CGPoint(x: x + dx, y: y + dy)
  }
  
  func scale(scaleFactor: CGFloat) -> CGPoint {
    return CGPoint(x: x * scaleFactor, y: y * scaleFactor)
  }
  
  func subtract(other: CGPoint) -> CGPoint {
    return add(other.negative)
  }
  
  func add(other: CGPoint) -> CGPoint {
    return offset(other.x, other.y)
  }
  
  var flipY: CGPoint {
    return CGPoint(x: x, y: -y)
  }
  
  var flipX: CGPoint {
    return CGPoint(x: -x, y: y)
  }
  
  var negative: CGPoint {
    return CGPoint(x: -x, y: -y)
  }
  
  func max(other: CGPoint) -> CGPoint {
    return CGPoint(x: Swift.max(x, other.x), y: Swift.max(y, other.y))
  }
  
  func min(other: CGPoint) -> CGPoint {
    return CGPoint(x: Swift.min(x, other.x), y: Swift.min(y, other.y))
  }
  
  var value: (CGFloat, CGFloat) {
    return (x, y)
  }
  
  var size: CGSize {
    return CGSize(width: x, height: y)
  }
  
  var rectOffset: (dx: CGFloat, dy: CGFloat) {
    return (x, y)
  }
  
  var pixels: CGPoint {
    return CGPoint(x: x.pixels, y: y.pixels)
  }
  
  var points: CGPoint {
    return CGPoint(x: x.points, y: y.points)
  }
  
  func relativeIn(size: CGSize) -> CGPoint {
    return CGPoint(x: x / size.width, y: y / size.height)
  }
  
  func relativeIn(rect: CGRect) -> CGPoint {
    return subtract(rect.origin).relativeIn(rect.size)
  }
  
  func absoluteIn(size: CGSize) -> CGPoint {
    return CGPoint(x: x * size.width, y: y * size.height)
  }
  
  func absoluteIn(rect: CGRect) -> CGPoint {
    return absoluteIn(rect.size).add(rect.origin)
  }
  
  static func top(y: CGFloat) -> CGPoint {
    return CGPoint(x: 0, y: y)
  }
  
  static func bottom(y: CGFloat) -> CGPoint {
    return CGPoint(x: 0, y: -y)
  }
  
  static func left(x: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: 0)
  }
  
  static let layerAnchorCenter = CGPoint(x: 0.5, y: 0.5)
}

