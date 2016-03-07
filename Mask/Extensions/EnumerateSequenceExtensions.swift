//
//  EnumerateSequenceExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 1/4/16.
//  Copyright (c) 2016 Kaipai. All rights reserved.
//

import Foundation


extension EnumerateSequence {
  func map<U>(@noescape transform: (Int, Base.Generator.Element) -> U) -> [U] {
    var array = [U]()
    for (index, element) in self {
      array.append(transform(index, element))
    }
    return array
  }
  
  func each(@noescape process: (Int, Base.Generator.Element) -> ()) {
    map(process)
  }
  
  func filter(@noescape includeElement: (Int, Base.Generator.Element) -> Bool) -> [(Int, Base.Generator.Element)] {
    var array: [(Int, Base.Generator.Element)] = []
    for (index, element) in self {
      if includeElement(index, element) {
        array.append((index, element))
      }
    }
    return array
  }
}
