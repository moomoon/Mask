//
//  StringExtensions.swift
//  kaipai2
//
//  Created by Jia Jing on 12/29/15.
//  Copyright (c) 2015 Kaipai. All rights reserved.
//

import Foundation


extension NSTextCheckingResult {
  
  private func fromNSRange(range: NSRange) -> Range<Int> {
    return Range(start: range.location, end: range.length + range.location)
  }
  
  private func fromRangeInt(s: String, r: Range<Int>) -> Range<String.Index> {
    return Range(start: s.startIndex.advancedBy(r.startIndex, limit: s.endIndex), end: s.startIndex.advancedBy(r.endIndex, limit: s.endIndex))
  }
  
  // String.Index need s
  func matchedRanges(s: String) -> [Range<String.Index>] {
    
    func strRange(i: Int) -> Range<String.Index> {
      let range = rangeAtIndex(i)
      let rint = fromNSRange(range)
      return fromRangeInt(s, r: rint)
    }
    
    return Range(start: 0, end: numberOfRanges).map(strRange)
  }
  
}



extension String.Index {
  func indexIn(string: String) -> Int {
    var index = 0
    var current = self
    while current > string.startIndex {
      index++
      current = current.successor()
    }
    return index
  }
  
  func isFirstIn(string: String) -> Bool {
    return self == string.startIndex
  }
}



extension String {
  public subscript(range: Range<Int>) -> String {
    let start = startIndex.advancedBy(range.startIndex)
    let end = startIndex.advancedBy(range.endIndex)
    return self.substringWithRange(Range(start: start, end: end))
  }
  
//  var url: NSURL? {
//    if self =~ ".*\\S+.*" {
//      return NSURL(string: self)
//    } else {
//      return nil
//    }
//  }
  
  var fileURL: NSURL? {
    return NSURL(fileURLWithPath: self)
  }
  
  func matchWithPattern(pattern: String) -> [Range<String.Index>]? {
    do {
      let rexp = try NSRegularExpression(pattern: pattern, options: [])
      let str = self
      let range = NSRange(location: 0, length: str.characters.count)
      let result = rexp.matchesInString(str, options: [], range: range)
      
      if result.count > 0 {
        return result[0].matchedRanges(str)
      } else {
        return nil
      }
    } catch let e as NSError {
      print("regex error " + e.localizedDescription)
      return nil
    }
  }
  
  var lastPathComponent: String {
    return (self as NSString).lastPathComponent
  }
  var pathExtension: String {
    return (self as NSString).pathExtension
  }
  var stringByDeletingLastPathComponent: String {
    return (self as NSString).stringByDeletingLastPathComponent
  }
  var stringByDeletingPathExtension: String {
    return (self as NSString).stringByDeletingPathExtension
  }
  var pathComponents: [String] {
    return (self as NSString).pathComponents
  }
  
  func stringByAppendingPathComponent(path: String) -> String {
    let nsSt = self as NSString
    return nsSt.stringByAppendingPathComponent(path)
  }
  
  func stringByAppendingPathExtension(ext: String) -> String? {
    let nsSt = self as NSString
    return nsSt.stringByAppendingPathExtension(ext)
  }
  
  
  func split(count: Int) -> [String] {
    var arr = [String]()
    for (var start = startIndex, end = startIndex.advancedBy(count, limit: endIndex);
      start < endIndex;
      start = start.advancedBy(count, limit: endIndex), end = end.advancedBy(count, limit: endIndex)) {
        arr.append(substringWithRange(start..<end))
    }
    return arr
  }
  
  func data(encoding: UInt = NSUTF8StringEncoding) -> NSData? {
    return (self as NSString).dataUsingEncoding(encoding)
  }
  
  var trimmed: String {
    return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
  
  var nsstring: NSString {
    return self as NSString
  }
  
  func substringAfterLastOccurance(str: String) -> String? {
    return (rangeOfString(str, options: .BackwardsSearch)?.endIndex).map { self.substringFromIndex($0) }
  }
  
  var lastExtension: String? {
    return substringAfterLastOccurance(".")
  }
  
}

extension NSString {
  func rangesBetween(begin: NSString, _ end: NSString, seperator: NSString)  -> [(Int, NSRange)] {
    return rangesBetween(begin.characterAtIndex(0), end: end.characterAtIndex(0), seperator: seperator.characterAtIndex(0))
  }
  
  func rangesBetween(begin: unichar, end: unichar, seperator: unichar) -> [(Int, NSRange)] {
    var substack = [0]
    var stack = [0]
    var result = [(Int, NSRange)]()
    for i in (0..<length) {
      let char = characterAtIndex(i)
      if char == begin {
        stack.append(i)
        substack.append(i + 1)
      } else if char == seperator {
        let substart = substack.replaceLast(i + 1)!
        result.append((stack.count, NSRange(location: substart, length: i - substart)))
      } else {
        if char == end {
          let substart = substack.removeLast()
          result.append((stack.count, NSRange(location: substart, length: i - substart)))
          stack.removeLast()
        }
        
        if i == length - 1 {
          stack.removeLast()
          let substart = substack.removeLast()
          result.append((1, NSRange(location: substart, length: i - substart + 1)))
        }
      }
    }
    return result
  }
  
}