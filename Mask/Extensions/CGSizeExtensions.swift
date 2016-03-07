//
//  CGSizeExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/6/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


extension CGSize {
  
  init(width: CGFloat, aspectRatio: CGFloat) {
    self.init(width: width, height: width / aspectRatio)
  }
  
  var centerSquare: CGRect {
    return maxWrappedSquare.rect(center: center)
  }
  
  func equal(other: CGSize) -> Bool {
    return width.equal(other.width) && height.equal(other.height)
  }
  
  static func height(height: CGFloat) -> CGSize {
    return CGSize(width: 0, height: height)
  }
  
  static func width(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 0)
  }
  
  static func square(size: CGFloat) -> CGSize {
    return CGSize(width: size, height: size)
  }
  
  func expand(dx: CGFloat, dy: CGFloat) -> CGSize {
    return CGSize(width: width + dx, height: height + dy)
  }
  
  func max(width: CGFloat? = nil, height: CGFloat? = nil) -> CGSize {
    let width = width.map { $0.max(self.width) } ?? self.width
    let height = height.map { $0.max(self.height) } ?? self.height
    return CGSize(width: width, height: height)
  }
  
  func min(width: CGFloat? = nil, height: CGFloat? = nil) -> CGSize {
    let width = width.map { $0.min(self.width) } ?? self.width
    let height = height.map { $0.min(self.height) } ?? self.height
    return CGSize(width: width, height: height)
  }
  
  func max(other: CGSize) -> CGSize {
    return CGSize(width: width.max(other.width), height: height.max(other.height))
  }
  
  func minScale(other: CGSize) -> CGFloat {
    return Swift.min(other.width / width, other.height / height)
  }
  
  func maxScale(other: CGSize) -> CGFloat {
    return Swift.max(other.width / width, other.height / height)
  }
  
  func wrap(other: CGSize) -> CGSize {
    let scaleFactor = maxScale(other)
    return scale(scaleFactor)
  }
  
  func fitIn(other: CGSize) -> CGSize {
    let scaleFactor = minScale(other)
    return scale(scaleFactor)
  }
  
  func scale(factor: CGFloat) -> CGSize {
    return CGSize(width: width * factor, height: height * factor)
  }
  
  func scale(sx: CGFloat, _ sy: CGFloat) -> CGSize {
    return CGSize(width: width * sx, height: height * sy)
  }
  
  
  func scaleTo(other: CGSize) -> (CGFloat, CGFloat) {
    return (other.width / width, other.height / height)
  }
  
  var maxWrappedSquare: CGSize {
    let side = Swift.min(width, height)
    return CGSize(width: side, height: side)
  }
  
  var minWrappingSquare: CGSize {
    return .square(width.max(height))
  }
  
  func setHeight(height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
  }
  
  func setWidth(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
  }
  
  func rect(origin origin: CGPoint = .zero) -> CGRect {
    return CGRect(origin: origin, size: self)
  }
  
  func rect(center center: CGPoint) -> CGRect {
    return CGRect(origin: center.subtract(self.center), size: self)
  }
  
  func rect(bottomLeft bottomLeft: CGPoint) -> CGRect {
    return CGRect(origin: CGPoint(x: bottomLeft.x, y: bottomLeft.y - height), size: self)
  }
  
  func rect(topCenter topCenter: CGPoint) -> CGRect {
    return CGRect(origin: CGPoint(x: topCenter.x - width / 2, y: topCenter.y), size: self)
  }
  
  var center: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }
  
  var point: CGPoint {
    return CGPoint(x: width, y: height)
  }
  
  var maxRadius: CGFloat {
    return ceil(Swift.min(width, height) / 2)
  }
  
  var pixels: CGSize {
    return CGSize(width: width.pixels, height: height.pixels)
  }
  
  var points: CGSize {
    return CGSize(width: width.points, height: height.points)
  }
  
//  func underlinedImage(width: CGFloat, color: UIColor = .Tint) -> UIImage {
//    return UIImage.imageWithRects([(color, CGSize(width: self.width, height: width).rect(origin: CGPoint(x: 0, y: height - width)).pixels)])
//  }
}
