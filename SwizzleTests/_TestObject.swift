//
//  _TestObject.swift
//  SwizzleTests
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import Foundation

extension NSObject
{
    func hello() -> String
    {
        return "NSObject-hello"
    }
    
    func bye() -> String
    {
        return "NSObject-bye"
    }
    
    class func hello() -> String
    {
        return "NSObject+hello"
    }
    
    class func bye() -> String
    {
        return "NSObject+bye"
    }
}

class MyObject: NSObject
{
    // NOTE: dynamic is required for method-swizzling
    dynamic func bonjour() -> String
    {
        return "MyObject-bonjour"
    }
    
    dynamic class func bonjour() -> String
    {
        return "MyObject+bonjour"
    }
}