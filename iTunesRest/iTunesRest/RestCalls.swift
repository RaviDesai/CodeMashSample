//
//  RestCalls.swift
//  iTunesRest
//
//  Created by Ravi Desai on 11/8/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONDictionary = [String: JSON]
public typealias JSONArray = [JSON]
public typealias RestCallbackFunction = (request: NSURLRequest?, error: NSError?, result: JSONDictionary?) -> Void

@objc public class RestCalls {
    public var result: JSONDictionary?
    
    private let callback : RestCallbackFunction
    private let startImmediately: Bool
    private var data = NSMutableData()

    private var conn: NSURLConnection?
    private var url: NSURL?
    private var request: NSURLRequest?
    
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
            self.callback(request: self.request, error: err, result: nil)
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
            self.callback(request: self.request, error: err, result: nil)
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
        self.data.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError) {
        self.callback(request: self.request, error: error, result: nil)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var jsonString = NSString(data: self.data, encoding: NSUTF8StringEncoding);
        
        var jsonErrorOptional: NSError?;
        var jsonOptional : JSON? = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional);
        
        var error = jsonErrorOptional;
        
        if error == nil {
            if let jsonDictionary = jsonOptional as? JSONDictionary {
                self.result = jsonDictionary
            }
        }
        
        self.callback(request: self.request, error: error, result: self.result)
    }
    
    
    
}