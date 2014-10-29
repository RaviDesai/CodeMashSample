//
//  iTunesRestTests.swift
//  iTunesRest
//
//  Created by Ravi Desai on 10/29/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation
import Quick
import Nimble
import iTunesRest


class RestTest : QuickSpec {
    override func spec() {
        describe("") {
            it("HTTP success") {
                var rr = RestResponse.HttpSuccess(201, "OK")
                expect(rr.didSucceed()).to(beTruthy())
                expect(rr.getShortMessage()).to(equal("Success [201]"))
                expect(rr.getLongMessage()).to(equal("Success [OK]"))
            }
            it("System Failure") {
                var err = NSError(domain: "Domain", code: 99, userInfo: [NSLocalizedDescriptionKey: "My Error"])
                var rr = RestResponse.SystemFailure(err);
                expect(rr.didSucceed()).to(beFalsy())
                expect(rr.didFail()).to(beTruthy())
                expect(rr.getShortMessage()).to(equal("System failure: My Error"))
                var re = rr.getLongMessage();
                
                expect(re).to(beginWith("System failure: Error Domain=Domain Code=99 \"My Error\" UserInfo=0x"))
                expect(re).to(endWith("{NSLocalizedDescription=My Error}"))
            }
            it("HTTP failure") {
                var rr = RestResponse.HttpFailure(403, "Forbidden")
                expect(rr.didSucceed()).to(beFalsy())
                expect(rr.didFail()).to(beTruthy())
                expect(rr.getShortMessage()).to(equal("Failure [403]"))
                expect(rr.getLongMessage()).to(equal("Failure [Forbidden]"))
            }
            it("JSON failure") {
                var err: NSError?;
                var jsonString: NSString = "bad json"
                var data = jsonString.dataUsingEncoding(NSUTF8StringEncoding);
                
                var ser : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &err);
                
                if let myerr = err {
                    var rr = RestResponse.JsonFailure(myerr)
                    expect(rr.didSucceed()).to(beFalsy())
                    expect(rr.didFail()).to(beTruthy())
                    expect(rr.getShortMessage()).to(equal("Failure parsing JSON: The data couldn’t be read because it isn’t in the correct format."))
                    var re = rr.getLongMessage()
                    expect(re).to(beginWith("Failure parsing JSON: Error Domain=NSCocoaErrorDomain Code=3840 \"The data couldn’t be read because it isn’t in the correct format.\" (Invalid value around character 0.) UserInfo="))
                    expect(re).to(endWith("{NSDebugDescription=Invalid value around character 0.}"))
                } else {
                    fail("should have produced a json error")
                }
                
            }
        }
    }
}