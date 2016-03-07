//
//  CGRectExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/6/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore

extension CGRect {
  
  func intercepts(from: CGPoint, _ to: CGPoint) -> CGPoint? {
    var line = CGLine(p1: from, p2: to)
    return line.interceptionWith(topEdge)
      ?? line.interceptionWith(rightEdge)
      ?? line.interceptionWith(bottomEdge)
      ?? line.interceptionWith(leftEdge)
  }
  
  var center: CGPoint {
    get { return CGPointMake(origin.x + size.width / 2, origin.y + size.height / 2) }
    set { origin = newValue.subtract(size.center) }
  }

  
  var left: CGFloat {
    get { return origin.x }
    set { origin.x = newValue }
  }
  
  var top: CGFloat {
    get { return origin.y }
    set { origin.y = newValue }
  }
  
  var right: CGFloat {
    get { return maxX }
    set { origin.x = newValue - width }
  }
  
  var bottom: CGFloat {
    get { return maxY }
    set { origin.y = newValue - height }
  }
  
  
  func union(other: CGRect) -> CGRect {
    return CGRectUnion(self, other)
  }
  
  func rectByInsetting(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) -> CGRect {
    return CGRect(origin: origin.offset(left, top), size: size.expand(-left - right, dy: -top - bottom))
  }
  
  func minSize(size: CGSize) -> CGRect {
    return self.size.max(size).rect(origin: origin)
  }
  
  var boundingSize: CGSize {
    return CGSize(width: maxX, height: maxY)
  }
  
  var pixels: CGRect {
    return CGRect(origin: origin.pixels, size: size.pixels)
  }
  
  var points: CGRect {
    return CGRect(origin: origin.points, size: size.points)
  }
  
  var topLeft: CGPoint {
    get { return origin }
    set { origin = newValue }
  }
  
  var topCenter: CGPoint {
    get { return CGPoint(x: origin.x + width / 2, y: origin.y) }
    set { origin = CGPoint(x: newValue.x - width / 2, y: newValue.y) }
  }
  
  var topRight: CGPoint {
    get { return CGPoint(x: origin.x + width, y: origin.y) }
    set { origin = CGPoint(x: newValue.x - width, y: newValue.y) }
  }
  
  var bottomLeft: CGPoint {
    get { return CGPoint(x: origin.x, y: origin.y + height) }
    set { origin = CGPoint(x: newValue.x, y: newValue.y - height)}
  }
  
  var bottomRight: CGPoint {
    get { return origin.add(size.point) }
    set { origin = newValue.subtract(size.point) }
  }
  
  var bottomCenter: CGPoint {
    get { return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height) }
    set { origin = newValue.subtract(CGPoint(x: size.width / 2, y: size.height)) }
  }
  
  static let zeroRect: CGRect = CGRectMake(0, 0, 0, 0)
  
  private var topEdge: CGLine { return CGLine(p1: topLeft, p2: topRight) }
  private var rightEdge: CGLine { return CGLine(p1: topRight, p2: bottomRight) }
  private var bottomEdge: CGLine { return CGLine(p1: bottomRight, p2: bottomLeft) }
  private var leftEdge: CGLine { return CGLine(p1: bottomLeft, p2: topLeft) }
}

private struct CGLine {
  let p1: CGPoint
  let p2: CGPoint
  
  lazy var vertical: Bool = { return self.p1.x == self.p2.x }()
  lazy var k: CGFloat = { return self.vertical ? 0 : ((self.p2.y - self.p1.y) / (self.p2.x - self.p1.x)) }()
  lazy var c: CGFloat = { return self.vertical ? 0 : (self.p1.y - self.k * self.p1.x) }()
  init(p1: CGPoint, p2: CGPoint) {
    self.p1 = p1
    self.p2 = p2
  }
  
  mutating func interceptionWith(var other: CGLine) -> CGPoint? {
    let x = (other.c - c) / (k - other.k)
    if containsX(x) && other.containsX(x) {
      return CGPoint(x: x, y: y(atX: x))
    } else {
      return nil
    }
  }
  
  func containsX(x: CGFloat) -> Bool {
    return min(p1.x, p2.x) <= x && max(p1.x, p2.x) >= x
  }
  
  mutating func y(atX x: CGFloat) -> CGFloat {
    return x * k + c
  }
  
}

