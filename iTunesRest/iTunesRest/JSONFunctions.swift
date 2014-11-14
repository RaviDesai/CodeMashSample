//
//  JSONFunctions.swift
//  iTunesRest
//
//  Created by Ravi Desai on 11/13/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONDictionary = [String: JSON]
public typealias JSONArray = [JSON]

//map operator (other languages use >>=)
infix operator >>- { associativity left precedence 150 }

// Optional value on left, function on right.  If the value is
// non-nil, apply the function, otherwise return nil
func >>-<A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

func toString(object: JSON) -> String? {
    return object as? String
}

func toDouble(object: JSON) -> Double? {
    return object as? Double
}

func toInt(object: JSON) -> Int? {
    return object as? Int
}

func toDictionary(object: JSON) -> NSDictionary? {
    return object as? NSDictionary
}

func toArray(object: JSON) -> NSArray? {
    return object as? NSArray;
}

func toUrl(object: JSON) -> NSURL? {
    if let urlString = object as? String {
        return NSURL(string: urlString)
    }
    return nil
}

// fmap operator (other languages use <$>)
infix operator <^> { associativity left }

// applicative apply operator
infix operator <*> { associativity left }
infix operator<**> { associativity left }

// Function on left, optional value on right.  If value isn't nil
// apply the function, otherwise return nil.
func <^><A, B>(f: A -> B, a: A?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

// Optional function on left, optional value on right.  If both
// the function and value are non-nil, apply the function to the value,
// otherwise return nil.
func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    if let x = a {
        if let fx = f {
            return fx(x)
        }
    }
    return .None
}

func <**><A,B>(f: (A?->B)?, a: A?) -> B? {
    if let fx = f {
        return fx(a)
    }
    return .None
}
