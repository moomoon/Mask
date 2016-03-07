//
//  BoolExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 2/5/16.
//  Copyright © 2016 Kaipai. All rights reserved.
//

import Foundation

extension Bool {
  var int: Int {
    return self ? 1 : 0
  }
  
  var not: Bool {
    return !self
  }
}
