//
//  RestResponse.swift
//  iTunesRest
//
//  Created by Ravi Desai on 10/28/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public enum RestResponse {
    case HttpSuccess(Int, String)
    case HttpFailure(Int, String)
    case JsonFailure(NSError)
    case SystemFailure(NSError)
    
    public func didFail() -> Bool {
        switch(self) {
        case .HttpSuccess:
            return false;
        default:
            return true;
        }
    }
    public func didSucceed() -> Bool {
        return !self.didFail();
    }
    public func getShortMessage() -> String {
        switch(self) {
        case let .HttpSuccess(statusCode, localizedMessage):
            return "Success [\(statusCode)]"
        case let .HttpFailure(statusCode, localizedMessage):
            return "Failure [\(statusCode)]"
        case let .JsonFailure(error):
            return "Failure parsing JSON: \(error.localizedDescription)"
        case let .SystemFailure(error):
            return "System failure: \(error.localizedDescription)"
        }
    }
    
    public func getLongMessage() -> String {
        switch(self) {
        case let .HttpSuccess(statusCode, localizedMessage):
            return "Success [\(localizedMessage)]"
        case let .HttpFailure(statusCode, localizedMessage):
            return "Failure [\(localizedMessage)]"
        case let .JsonFailure(error):
            return "Failure parsing JSON: \(error)"
        case let .SystemFailure(error):
            return "System failure: \(error)"
        }
    }
}

