//
//  CameraController.swift
//  Mask
//
//  Created by Jia Jing on 3/4/16.
//  Copyright © 2016 Jia Jing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBlocking
import Box

final class CameraController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  let photos = Variable<[UIImage]>([])
  let disposeBag = DisposeBag()
  
  lazy var recorder: SCRecorder = {
    let recorder = SCRecorder()
    recorder.photoConfiguration.enabled = true
    return recorder
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    recorder.previewView = view
    recorder.startRunning()
    photos.asObservable()
      .map { $0.count }
      .observeOn(MainScheduler.instance)
      .subscribeNext { [weak self] in self?.label.text = "\($0)" }
      .addDisposableTo(disposeBag)
    
    
    photos.asObservable()
      .filter { $0.count > 1 }
      .flatMap(saveImages)
      .subscribeNext { [weak self] paths in
        self?.performSegueWithIdentifier("difference", sender: paths)

        MainQueue.dispatchAsync {
          self?.photos.value = []
        }
      }
      .addDisposableTo(disposeBag)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if case let ("difference"?, controller as DifferenceViewController, paths as [String]) = (segue.identifier, segue.destinationViewController, sender) where paths.count > 1 {
      controller.backgroundURL = NSURL(fileURLWithPath: paths[0])
      controller.foregroundURL = NSURL(fileURLWithPath: paths[1])
    }
  }
  
  @IBAction func shoot(sender: UIButton) {
    recorder.capturePhoto { error, photo in
      guard let photo = photo else { return }
      self.photos.value.append(photo)
    }
    
    
  }
}


private func saveImages(images: [UIImage]) -> Observable<[String]> {
  return Observable.create { observer in
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let imagePaths: [String] = images.enumerate().map { id, image in
      let filePath = "\(paths[0])/\(id).png"
      _ = try? NSFileManager.defaultManager().removeItemAtPath(filePath)
      UIImagePNGRepresentation(image)?.writeToFile(filePath, atomically: true)
      return filePath
    }
    observer.onNext(imagePaths)
    return NopDisposable.instance
  }

}