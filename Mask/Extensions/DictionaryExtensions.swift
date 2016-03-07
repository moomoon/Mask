//
//  DictionaryExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 12/31/15.
//  Copyright (c) 2015 Kaipai. All rights reserved.
//

import Foundation


extension Dictionary {
  func map<U>(transform: (Key, Value) -> U) -> [U] {
    var array = [U]()
    for k in keys {
      array.append(transform(k, self[k]!))
    }
    return array
  }
  
  func mapValue<U>(transform: Value -> U) -> [Key: U] {
    var dict = [Key: U]()
    for k in keys {
      if let value = self[k] {
        dict[k] = transform(value)
      }
    }
    return dict
  }
  
  static func from<T: SequenceType where T.Generator.Element == (Key, Value)>(seq: T) -> Dictionary {
    var dict = Dictionary()
    for (key, value) in seq {
      dict[key] = value
    }
    return dict
  }
}
