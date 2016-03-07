//
//  CGAffineTransformExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/4/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


extension CGAffineTransform: CustomStringConvertible {
  
  typealias Semantic = (scale: CGFloat, rotation: CGFloat, translation: CGPoint)
  static func from(semantic: Semantic) -> CGAffineTransform  {
    return self.makeScale(semantic.scale).rotate(semantic.rotation).postTranslate(semantic.translation.value)
  }
  
  var xScale: CGFloat {
    return sqrt(a * a + c * c)
  }
  
  static var identity: CGAffineTransform {
    return CGAffineTransformIdentity
  }
  
//  func videoCompositionLayerInstruction(track: AVAssetTrack) -> AVVideoCompositionLayerInstruction {
//    let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
//    instruction.setTransform(self, atTime: kCMTimeZero)
//    return instruction
//  }
  
  func concat(other: CGAffineTransform) -> CGAffineTransform {
    return CGAffineTransformConcat(self, other)
  }
  
  
  
  static func makeScale(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
    //        return concat(CGAffineTransformMakeScale(sx, sy))
    return CGAffineTransformMakeScale(sx, sy)
  }
  
  static func makeScale(factor: CGFloat) -> CGAffineTransform {
    //        return concat(CGAffineTransformMakeScale(sx, sy))
    return CGAffineTransformMakeScale(factor, factor)
  }
  
  func scale(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
    //        return concat(CGAffineTransformMakeScale(sx, sy))
    return CGAffineTransformScale(self, sx, sy)
  }
  
  func scale(factor: CGFloat) -> CGAffineTransform {
    //        return concat(CGAffineTransformMakeScale(sx, sy))
    return CGAffineTransformScale(self, factor, factor)
  }
  
  func postScale(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
    return concat(CGAffineTransformMakeScale(sx, sy))
  }
  
  func postScale(factor: CGFloat) -> CGAffineTransform {
    return concat(CGAffineTransformMakeScale(factor, factor))
  }
  
  func translate(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
    //        return concat(.makeTranslation(ty, ty))
    return CGAffineTransformTranslate(self, tx, ty)
  }
  
  func postTranslate(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
    return concat(CGAffineTransformMakeTranslation(tx, ty))
  }
  
  func rotate(angle: CGFloat) -> CGAffineTransform {
    //        return concat(CGAffineTransformMakeRotation(angle))
    return CGAffineTransformRotate(self, angle)
  }
  
  func postRotate(angle: CGFloat) -> CGAffineTransform {
    return concat(CGAffineTransformMakeRotation(angle))
  }
  
  func concatTo(other: CGAffineTransform) -> CGAffineTransform {
    return other.concat(self)
  }
  
  static func makeTranslation(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
    return CGAffineTransformMakeTranslation(tx, ty)
  }
  
  static func makeRotation(angle: CGFloat) -> CGAffineTransform {
    return CGAffineTransformMakeRotation(angle)
  }
  
  
  var invert : CGAffineTransform {
    return CGAffineTransformInvert(self)
  }
  
  public var description: String {
    return NSStringFromCGAffineTransform(self)
  }
  
}


