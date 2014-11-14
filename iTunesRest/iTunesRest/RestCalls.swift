//
//  RestCalls.swift
//  iTunesRest
//
//  Created by Ravi Desai on 11/8/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias RestCallbackFunction = (request: NSURLRequest?, response: RestResponse, result: JSON?) -> Void

@objc public class RestCalls {
    public var result: JSON?
    
    private let callback : RestCallbackFunction
    private let startImmediately: Bool
    private var data = NSMutableData()

    private var conn: NSURLConnection?
    private var url: NSURL?
    private var request: NSURLRequest?
    private var response: NSHTTPURLResponse?
    
    public init(startImmediately: Bool, callback: RestCallbackFunction) {
        self.callback = callback
        self.startImmediately = startImmediately;
    }

    public convenience init(callback: RestCallbackFunction) {
        self.init(startImmediately: true, callback: callback);
    }
    
    private func createUrlRequest(urlString : String) -> NSMutableURLRequest? {
        var result: NSMutableURLRequest? = nil
        if let url =  NSURL(string: urlString) {
            self.url = url;
            result = NSMutableURLRequest(URL: url)
            result!.setValue("application/json", forHTTPHeaderField: "Accept")
            
            self.request = result! as NSURLRequest;
        }
        
        if result == nil {
            var err = NSError(domain: "iTunesRest", code: 99, userInfo: [NSLocalizedDescriptionKey: "Bad URL for RestCall.  Cannot connect."])
            self.callback(request: self.request, response: RestResponse.SystemFailure(err), result: nil)
        }
        return result
    }
    
    private func configure(urlString : String, forMethodName: String, withBody: NSData?) -> Bool {
        var result = false;
        if let mutableRequest = self.createUrlRequest(urlString) {
            mutableRequest.HTTPMethod = forMethodName
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            if let body = withBody {
                mutableRequest.HTTPBody = body
            }
            
            self.request = mutableRequest as NSURLRequest;
            self.conn = NSURLConnection(request: self.request!, delegate: self, startImmediately: self.startImmediately)
            result = self.conn != nil
        }
        
        if !result {
            var err = NSError(domain: "iTunesRest", code: 99, userInfo: [NSLocalizedDescriptionKey: "Bad URL for RestCall.  Cannot connect."])
            self.callback(request: self.request, response: RestResponse.SystemFailure(err), result: nil)
        }
        return result;
    }
    
    public func configureForGet(urlString: String) -> Bool {
        return configure(urlString, forMethodName: "GET", withBody: nil)
    }
    
    public func configureForPost(urlString: String, data: NSData) -> Bool {
        return configure(urlString, forMethodName: "POST", withBody: data)
    }

    public func configureForPut(urlString: String, data: NSData) -> Bool {
        return configure(urlString, forMethodName: "PUT", withBody: data)
    }

    public func configureForDelete(urlString: String) -> Bool {
        return configure(urlString, forMethodName: "DELETE", withBody: nil)
    }

    
    public func start() -> Bool {
        if self.startImmediately { return true }
        
        if let conn = self.conn {
            conn.start();
            return true;
        }
        
        return false;
    }
    
    public func cancel() -> Bool {
        if let conn = self.conn {
            conn.cancel();
            return true;
        }
        
        return false;
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse) {
        self.response = response as? NSHTTPURLResponse
        self.data.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError) {
        self.callback(request: self.request, response: RestResponse.SystemFailure(error), result: nil)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var restResponse: RestResponse = RestResponse.HttpFailure(0, "no HTTP response received");
        
        if let httpResponse = self.response {
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                restResponse = RestResponse.HttpSuccess(httpResponse.statusCode, httpResponse.description)
                var jsonString = NSString(data: self.data, encoding: NSUTF8StringEncoding);
                
                var jsonErrorOptional: NSError?;
                self.result = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional);
                
                if let error = jsonErrorOptional {
                    restResponse = RestResponse.JsonFailure(error)
                }
            } else {
                restResponse = RestResponse.HttpFailure(httpResponse.statusCode, httpResponse.description)
            }
        }
        
        self.callback(request: self.request, response: restResponse, result: self.result)
    }    
}