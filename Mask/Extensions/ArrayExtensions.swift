//
//  ArrayExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 12/31/15.
//  Copyright (c) 2015 Kaipai. All rights reserved.
//

import Foundation


extension Array where Element: OptionalType {
  func compact() -> [Element.Wrapped] {
    var result: [Element.Wrapped] = []
    for elem in self {
      if let val = elem.value {
        result.append(val)
      }
    }
    return result
  }
}

extension Array {
  
  func inserted(newElement: Element, atIndex i: Int) -> [Element] {
    var v = self
    v.insert(newElement, atIndex: i)
    return v
  }
  
  func safeGet(index: Int) -> Element? {
    if index >= 0 && index < count {
      return self[index]
    } else {
      return nil
    }
  }
  
  func safeGetInversed(index: Int) -> Element? {
    return safeGet(count - index - 1)
  }
  
  func removedAtIndices(indices: [Int]) -> [Element]{
    return enumerate().filter { id, _ in !indices.contains { id == $0 } }.map { $1 }
  }
  
  mutating func replaceLast(last: Element) -> Element? {
    if count > 0 {
      let origin = self[count - 1]
      self[count - 1] = last
      return origin
    } else {
      return nil
    }
  }
  
  subscript(ratio: Float) -> Element {
    let index = Int(Float(count) * ratio) % count
    return self[index]
  }
  
  func appendTo(heads: [Element]) -> [Element] {
    return heads + self
  }
  
  func appendTo(head: Element) -> [Element] {
    return [head] + self
  }
  
  func appended(tail: Element) -> [Element] {
    var copy = self
    copy.append(tail)
    return copy
  }
  
  func tail(num: Int) -> Element? {
    let id = count - num - 1
    if id >= 0 {
      return self[id]
    } else {
      return nil
    }
  }
  
  func rest(numElements: Int = 1) -> [Element] {
    var result: [Element] = []
    guard (numElements < self.count) else { return result }
    for index in numElements ..< self.count {
      result.append(self[index])
    }
    return result
  }
  
  func each(apply: Element -> ()) {
    for element in self {
      apply(element)
    }
  }
  
  
  func findFirst(@noescape predicate: Element -> Bool) -> Element? {
    for t in self {
      if predicate(t){
        return t
      }
    }
    return nil
  }
  
  func find<U: Equatable>(value: U, transform: Element -> U) -> Element? {
    return findFirst { transform($0) == value }
  }
  
  func findFirstIndexOf(@noescape predicate: Element -> Bool) -> Int? {
    var index = 0
    for t in self {
      if predicate(t) {
        return index
      }
      index++
    }
    return nil
  }
  
//  func flatMapOptional<U>(transform: Element -> U?) -> [U] {
//    return compact(map(transform))
//  }
  
  func contains(@noescape predicate: Element -> Bool) -> Bool {
    return nil != findFirstIndexOf(predicate)
  }
  
  
  func reduceIfAny<U>(@noescape firstElementTransformer: Element -> U, @noescape combine: (U, Element) -> U) -> U? {
    return reduceAll(self, firstElementTransformer: firstElementTransformer, combine: combine)
  }
  
  func compress(@noescape combine: (Element, Element) -> Element) -> Element? {
    return reduceAll(self, firstElementTransformer: identity, combine: combine)
  }
  
  
  
  var randomElement: Element? {
    return count > 0 ? self[Int(arc4random_uniform(UInt32(count)))] : nil
  }
  
  
  func split<U: Hashable>(transform: Element -> U) -> [U : [Element]] {
    var dict = [U: [Element]]()
    for element in self {
      let key = transform(element)
      var arr = dict[key] ?? []
      arr.append(element)
      dict[key] = arr
    }
    return dict
  }
  
  func split<U: Equatable>(transform: (U?, Element) -> U) -> [(U, [Element])] {
    var key: U?
    var currArr = [Element]()
    var array = [(U, [Element])]()
    for element in self {
      let newKey = transform(key, element)
      if newKey == key {
        currArr.append(element)
      } else if let currKey = key where currArr.count > 0 {
        array.append((currKey, currArr))
        currArr = [element]
      }
      key = newKey
    }
    if let currKey = key where currArr.count > 0 {
      array.append((currKey, currArr))
    }
    return array
  }
  
//  var enumerate: EnumerateSequence<Array<Element>> {
//    return Swift.enumerate(self)
//  }
  
//  func orderDictionary<K: Hashable>(transform: Element -> K) -> [K : Int] {
//    return Dictionary.from(map(transform).enumerate().map(swap))
//  }
  
  func dictionary<K: Hashable>(transform: Element -> K) -> [K: Element] {
    return Dictionary.from(map { (transform($0), $0) })
  }
}

@inline(never)func reduceAll<S: SequenceType, U>(sequence: S, @noescape firstElementTransformer: S.Generator.Element -> U, @noescape combine: (U, S.Generator.Element) -> U) -> U? {
  var generator = sequence.generate()
  if var ret = generator.next().map(firstElementTransformer) {
    while let next = generator.next() {
      ret = combine(ret, next)
    }
    return ret
  }
  return nil
}

@inline(__always)public func identity<T>(t: T) -> T {
  return t
}


