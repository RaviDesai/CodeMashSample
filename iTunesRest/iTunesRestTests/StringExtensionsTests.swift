//
//  StringExtensionsTests.swift
//  iTunesRest
//
//  Created by Ravi Desai on 10/29/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation
import Quick
import Nimble
import iTunesRest

class StringExtensionsSpec : QuickSpec {
    override func spec() {
        describe("String extension specs") {
            it("regular substring with String.Index still works") {
                var mystr = "I love swift string extensions"
                var start = advance(mystr.startIndex, 2)
                var end = advance(start, 4)
                expect(mystr[start..<end]).to(equal("love"))
            }
            it("substring range with integer") {
                var mystr = "I love swift string extensions"
                expect(mystr[2...5]).to(equal("love"))
            }
            it("set with Integer") {
                var mystr = "I love swift string extensions"
                mystr[2...5] = "like"
                expect(mystr).to(equal("I like swift string extensions"))
            }
        }
    }
}
