//
//  StringExtensions.swift
//  iTunesRest
//
//  Created by Ravi Desai on 10/29/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

extension String {
    public subscript(r:Range<Int>) -> String {
        get {
            let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
            let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
            return self.substringWithRange(Range(start: subStart, end: subEnd))
        }
        set(newValue) {
            let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
            let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
            self = self.substringWithRange(Range(start: self.startIndex, end: subStart)) + newValue +
                self.substringWithRange(Range(start: subEnd, end: self.endIndex));
        }
    }
}
