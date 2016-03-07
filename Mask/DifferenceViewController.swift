//
//  DifferenceViewController.swift
//  Mask
//
//  Created by Jia Jing on 3/3/16.
//  Copyright © 2016 Jia Jing. All rights reserved.
//

import Foundation
import GLKit
import RxSwift
import UIKit

enum BrushColor {
  case White, Black
}

final class DifferenceViewController: UIViewController {
  var backgroundURL = NSBundle.mainBundle().URLForResource("IMG_0324", withExtension: "png")!
  var foregroundURL = NSBundle.mainBundle().URLForResource("IMG_0325", withExtension: "png")!
  
  var brightness: Float = 0.8
  var contrast: Float = 3.35714
  
  var clampAlpha: Float = 0.006

  
  let denoise5 = loadCIKLFile("kn_Denoise5x5").flatMap(CIKernel.init)
  let denoise3 = loadCIKLFile("kn_Denoise3x3").flatMap(CIKernel.init)
  let kn_clampAlpha = loadCIKLFile("kn_ClampAlpha").flatMap(CIColorKernel.init)!

  
  @IBOutlet weak var button: UIButton! {
    didSet {
      currentColor.asObservable().subscribeNext { [weak self] in
        switch $0 {
        case .Black: self?.button.setTitle("橡皮", forState: [])
        case .White: self?.button.setTitle("铅笔", forState: [])
        }
      }
    }
  }
  
  private let glContext = (EAGLContext(API: .OpenGLES3) ?? EAGLContext(API: .OpenGLES2))!
  private lazy var ciContext: CIContext = CIContext(EAGLContext: self.glContext)
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var glkView: GLKView! {
    didSet {
      glkView.context = glContext
    }
  }
  
  
  let currentColor = Variable<BrushColor>(.Black)
  
  var background: CIImage!
  var foreground: CIImage!
  var denoised: CIImage!
  
  var cgimage: CGImage!
  override func viewDidAppear(animated: Bool) {
  
    super.viewDidAppear(animated)
    
    self.view.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 0, alpha: 1)
    self.glkView.backgroundColor = UIColor(colorLiteralRed: 0, green: 1, blue: 0, alpha: 1)
//    glkView.context ->> logger("context")
    
    let loadOpts = [GLKTextureLoaderApplyPremultiplication: NSNumber(bool: false)]
    EAGLContext.setCurrentContext(glContext)
//    do {
    
    guard let backgroundTextureInfo = try? GLKTextureLoader.textureWithContentsOfURL(backgroundURL, options: loadOpts),
      foregroundTextureInfo = try? GLKTextureLoader.textureWithContentsOfURL(foregroundURL, options: loadOpts) else {
        print("return")
        return
    }
    
//    } catch let e {
//      print("caught error \(e)")
//    }
    
    
    let backgroundImage = CIImage(
      texture     : backgroundTextureInfo.name ->> logger("name background"),
      size        : CGSize(width: Int(backgroundTextureInfo.width), height: Int(backgroundTextureInfo.height)),
      flipped     : true,
      colorSpace  : CGColorSpaceCreateDeviceRGB()).imageByApplyingOrientation(6)

    let foregroundImage = CIImage(
      texture: foregroundTextureInfo.name ->> logger("name foreground"),
      size: CGSize(width: Int(foregroundTextureInfo.width), height: Int(foregroundTextureInfo.height)),
      flipped: true,
      colorSpace: CGColorSpaceCreateDeviceRGB()
    ).imageByApplyingOrientation(6)
    
    self.background = backgroundImage
    self.foreground = foregroundImage
    
    let differenced = foregroundImage.imageByApplyingFilter("CIDifferenceBlendMode", withInputParameters: [kCIInputBackgroundImageKey: backgroundImage])
    
    let colorControlled = differenced.imageByApplyingFilter("CIColorControls", withInputParameters: ["inputContrast": NSNumber(float: contrast),
      ]).imageByApplyingFilter("CIColorControls", withInputParameters: ["inputBrightness": NSNumber(float: brightness)])

    
    let alphaClamped = kn_clampAlpha.applyWithExtent(colorControlled.extent, arguments: [colorControlled, NSNumber(float: clampAlpha)])
    
    let denoised = denoise3!.applyWithExtent(alphaClamped!.extent, roiCallback: { _ in alphaClamped!.extent }, arguments: [alphaClamped!])
    
    let denoised1 = denoise5!.applyWithExtent(alphaClamped!.extent, roiCallback: { _ in alphaClamped!.extent }, arguments: [denoised!])!

    
    self.denoised = denoised1.imageByApplyingTransform(.makeScale(denoised1.extent.size.scaleTo(imageView.bounds.size) ->> logger("scale")))
    
    
    self.cgimage = ciContext.createCGImage(self.denoised, fromRect: self.denoised.extent)
//    imageView.image = UIImage(CIImage: self.denoised) ->> logger("init image")
//
    
//    button.frame ->> logger("button.frame")
//      self.ciContext.drawImage(self.denoised, inRect: self.glkView.bounds.pixels ->> logger("bounds"), fromRect: self.denoised.extent ->> logger("extent"))
//      self.glkView.setNeedsDisplay()
    update()
  }
  
  @IBAction func switchColor(sender: AnyObject) {
    currentColor.value = currentColor.value == .Black ? .White : .Black
    print("switch color")
  }
  
  func update() {
    guard let image: CIImage = CIImage(CGImage: cgimage) else { return }
//    if let uiimage = imageView.image, ciimage = CIImage(image: uiimage) ->> logger("CGImage"){
//      image = ciimage.imageByApplyingTransform(CGAffineTransform.makeScale(image.extent.width / ciimage.extent.width, image.extent.height / ciimage.extent.height)).imageByCompositingOverImage(image)
//    }
    
    let alphaMask = image.imageByApplyingFilter("CIMaskToAlpha", withInputParameters: nil).imageByApplyingFilter("CIMaskToAlpha", withInputParameters: nil).imageByApplyingFilter("CIColorMatrix", withInputParameters: ["inputAVector": CIVector(x: 0, y: 0, z: 0, w: 0.5)])

    
    
    let weaken = image.imageByApplyingFilter("CIColorMatrix", withInputParameters: ["inputRVector": CIVector(x: 1, y: 0, z: 0, w: 0),
            "inputGVector": CIVector(x: 0, y: 0.0, z: 0, w: 0),
            "inputBVector": CIVector(x: 0, y: 0, z: 0.0, w: 0)
            ])
    
    let output = weaken.imageByApplyingFilter("CIBlendWithAlphaMask", withInputParameters: [kCIInputBackgroundImageKey: foreground.imageByApplyingTransform(.makeScale(foreground.extent.size.scaleTo(imageView.bounds.size))), kCIInputMaskImageKey: alphaMask])
    
    
    self.ciContext.drawImage(output, inRect: self.glkView.bounds.pixels ->> logger("bounds"), fromRect: output.extent ->> logger("extent"))
    self.glkView.setNeedsDisplay()

  }
  
  @IBAction func onPan(sender: UIPanGestureRecognizer) {
    let (translation, point) = (sender.consumePan(imageView), sender.locationInView(imageView))
    print("pan \(translation)")
    
    drawLineFrom(point.subtract(translation), toPoint: point)
    update()
    
  }
  
  
  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
    
    // 1
    UIGraphicsBeginImageContext(view.frame.size)
    let context = UIGraphicsGetCurrentContext()
//    
    CGContextTranslateCTM(context, 0, view.bounds.height)
    CGContextScaleCTM(context, 1, -1)

    CGContextDrawImage(context, CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), cgimage)
//    imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//    
    
    CGContextTranslateCTM(context, 0, view.bounds.height)
    CGContextScaleCTM(context, 1, -1)

    // 2
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
    
    // 3
    CGContextSetLineCap(context, .Round)
    CGContextSetLineWidth(context, 30)
    switch currentColor.value {
    case .Black: CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
    case .White: CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0)
    }
    CGContextSetBlendMode(context, .Normal)
    
    // 4
    CGContextStrokePath(context)
    
    // 5
    cgimage = CGBitmapContextCreateImage(context)
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//    imageView.alpha = opacity
    UIGraphicsEndImageContext()
    
  }

  @IBAction func finish(sender: AnyObject) {
    guard let image: CIImage = CIImage(CGImage: cgimage) else { return }
    let alphaMask = image.imageByApplyingFilter("CIMaskToAlpha", withInputParameters: nil).imageByApplyingFilter("CIColorMatrix", withInputParameters: ["inputRVector": CIVector(x: 0.3, y: 0.0, z: 0, w: 0),"inputGVector": CIVector(x: 0, y: 0.3, z: 0, w: 0),"inputBVector": CIVector(x: 0, y: 0.0, z: 0.3, w: 0),
      ]).imageByApplyingFilter("CIMaskToAlpha", withInputParameters: nil).imageByApplyingTransform(.makeScale(image.extent.size.scaleTo(foreground.extent.size)))

    let image_foreground_blued = foreground.imageByApplyingFilter("CIColorMonochrome", withInputParameters: ["inputColor": CIColor(color: UIColor.fromString("89C1FF")!)])
    let output = image_foreground_blued.imageByApplyingFilter("CIBlendWithAlphaMask", withInputParameters: [kCIInputBackgroundImageKey: background, kCIInputMaskImageKey: alphaMask])
    ciContext.drawImage(output, inRect: glkView.bounds.pixels, fromRect: output.extent)
    glkView.setNeedsDisplay()

  }
  
  
}

func loadCIKLFile(fileName: String) -> String? {
  if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "cikl") {
    return try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
  } else {
    return nil
  }
}

func logger<T>(prefix: String = "") -> T -> T{
  return side { print(prefix + " \($0)") }
  //  return identity
}
func side<T>(handler: T ->()) -> T -> T{
  return {
    handler($0)
    return $0
  }
}


infix operator ->> {
associativity left

// Lower precedence than the logical comparison operators
// (`&&` and `||`), but higher precedence than the assignment
// operator (`=`)
precedence 100
}

@inline(__always)func ->><F, T>(lhs: F, rhs: F -> T) -> T {
  return rhs(lhs)
}





var MainQueue: dispatch_queue_t {
  return dispatch_get_main_queue()
}

func runOnMainQueue(sync: Bool = false, closure: Closure) {
  if NSThread.currentThread().isMainThread {
    closure()
  } else if sync {
    MainQueue.dispatchSync(closure)
  } else {
    MainQueue.dispatchAsync(closure)
  }
}

func runOnBackgroundQueue(closure: () -> () -> ()) {
  dispatch_get_global_queue(0, 0).dispatchAsync { [closure] in
    let onBackground = closure()
    MainQueue.dispatchAsync(onBackground)
  }
}

extension OS_dispatch_queue {
  
  
  func dispatchAsync(block: dispatch_block_t) {
    dispatch_async(self, block)
  }
  
  func dispatchSync(block: dispatch_block_t) {
    dispatch_sync(self, block)
  }
}

typealias Closure = () -> ()


extension UIPanGestureRecognizer {
  func consumePan(view: UIView? = nil) -> CGPoint {
    let pan = translationInView((view ?? self.view)!)
    setTranslation(CGPointZero, inView: (view ?? self.view)!)
    return pan
  }
}

extension UIColor {
  class func fromString(str: String) -> UIColor? {
    let regex = "(?<=^#?)[0-9a-f]{6,8}"
    if let substring = str.lowercaseString.matchWithPattern(regex)?.first.map ({ str.substringWithRange($0) }) where substring.characters.count != 7 {
      let components: [UInt32] = substring.split(2).map {
        var number: UInt32 = 0
        return NSScanner(string: $0).scanHexInt(&number) ? number : 0
      }
      return fromComponents(components)
    }
    return nil
  }

  
  private class func fromComponents(components: [UInt32]) -> UIColor? {
    if components.count == 3 {
      return UIColor(red: CGFloat(components[0]) / 0xFF, green: CGFloat(components[1]) / 0xFF, blue: CGFloat(components[2]) / 0xFF, alpha: 1)
    } else if components.count == 4 {
      return UIColor(red: CGFloat(components[1]) / 0xFF, green: CGFloat(components[2]) / 0xFF, blue: CGFloat(components[3]) / 0xFF, alpha: CGFloat(components[0]) / 0xFF)
    } else {
      return nil
    }
  }
}
