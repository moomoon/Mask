//
//  OptionalExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 2/5/16.
//  Copyright © 2016 Kaipai. All rights reserved.
//

import Foundation

protocol OptionalType {
  typealias Wrapped
  var value: Wrapped? { get }
}

extension Optional: OptionalType {
  var value: Wrapped? { return self }
}


extension Optional {
  func getOrElse(@autoclosure val: () -> Wrapped) -> Wrapped  {
    return self ?? val()
  }
  
  func getOrElse(@autoclosure val: () -> Wrapped?) -> Wrapped? {
    return self ?? val()
  }
  
  func whenNil(@noescape notNil: Wrapped -> () = { _ in }, @noescape isNil: Closure) {
    nil == self ? isNil() : notNil(self!)
  }
  
  func some(@noescape runnable: Wrapped -> ()) {
    switch self {
    case let .Some(val): runnable(val)
    default: ()
    }
  }
  
}

extension OptionalType where Wrapped == Bool {
  var isTrue: Bool {
    return value ?? false
  }
  
  var notFalse: Bool {
    return value ?? true
  }
}