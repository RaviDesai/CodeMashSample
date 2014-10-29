//
//  RestResponse.swift
//  iTunesRest
//
//  Created by Ravi Desai on 10/28/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public enum RestResponse {
    case HttpSuccess(Int)
    case HttpFailure(Int)
    case JsonFailure(NSError)
    case SystemFailure(NSError)
    
    func didFail() -> Bool {
        switch(self) {
        case .HttpSuccess:
            return false;
        default:
            return true;
        }
    }
    func didSucceed() -> Bool {
        return !self.didFail();
    }
    func getShortMessage() -> String {
        switch(self) {
        case let .HttpSuccess(statusCode):
            return "Success [\(statusCode)]"
        case let .HttpFailure(statusCode):
            return "Failure [\(statusCode)]"
        case let .JsonFailure(error):
            return "Fsilure parsing JSON \(error.localizedDescription)"
        case let .SystemFailure(error):
            return "System failure \(error.localizedDescription)"
        }
    }
}

