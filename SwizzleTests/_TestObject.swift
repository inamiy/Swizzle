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
    @objc func hello() -> String
    {
        return "NSObject-hello"
    }

    @objc func bye() -> String
    {
        return "NSObject-bye"
    }

    @objc class func hello() -> String
    {
        return "NSObject+hello"
    }

    @objc class func bye() -> String
    {
        return "NSObject+bye"
    }
}

class MyObject: NSObject
{
    // NOTE: dynamic is required for method-swizzling
    @objc dynamic func bonjour() -> String
    {
        return "MyObject-bonjour"
    }

    @objc dynamic class func bonjour() -> String
    {
        return "MyObject+bonjour"
    }

    let deinitClosure: (() -> Void)?

    init(deinitClosure: (() -> Void)? = nil)
    {
        self.deinitClosure = deinitClosure
        super.init()

        print("[init] \(self)")
    }

    deinit
    {
        print("[deinit] \(self)")

        self.deinitClosure?()
    }

    // WARNING: swizzling `dealloc` in Swift won't work
    @objc dynamic func _swift_dealloc()
    {
        print("_swift_dealloc")
        self._swift_dealloc()
    }
}
