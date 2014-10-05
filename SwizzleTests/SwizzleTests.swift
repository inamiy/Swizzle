//
//  SwizzleTests.swift
//  SwizzleTests
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import Swizzle
import XCTest

class SwizzleTests: _TestCase
{
    func testSwizzleInstanceMethod()
    {
        let swizzle: Void -> Void = {
            swizzleInstanceMethod(NSObject.self, "hello", "bye")
        }
        
        let obj = NSObject()
        
        // original
        XCTAssertEqual(obj.hello(), "NSObject-hello")
        XCTAssertEqual(obj.bye(), "NSObject-bye")
        
        swizzle()
        
        // swizzled
        XCTAssertEqual(obj.hello(), "NSObject-bye")
        XCTAssertEqual(obj.bye(), "NSObject-hello")
        
        swizzle()   // clean up
        
        // back to original
        XCTAssertEqual(obj.hello(), "NSObject-hello")
        XCTAssertEqual(obj.bye(), "NSObject-bye")
    }
    
    func testSwizzleClassMethod()
    {
        let swizzle: Void -> Void = {
            swizzleClassMethod(NSObject.self, "hello", "bye")
        }
        
        let obj = NSObject()
        
        // original
        XCTAssertEqual(NSObject.hello(), "NSObject+hello")
        XCTAssertEqual(NSObject.bye(), "NSObject+bye")
        
        swizzle()
        
        // swizzled
        XCTAssertEqual(NSObject.hello(), "NSObject+bye")
        XCTAssertEqual(NSObject.bye(), "NSObject+hello")
        
        swizzle()   // clean up
        
        // back to original
        XCTAssertEqual(NSObject.hello(), "NSObject+hello")
        XCTAssertEqual(NSObject.bye(), "NSObject+bye")
    }

    func testCustomOperator()
    {
        let swizzle: Void -> Void = {
            (NSObject.self, "hello") <-> "bye"  // swizzleInstanceMethod
            (NSObject.self, "hello") <+> "bye"  // swizzleClassMethod
        }
        
        let obj = NSObject()
        
        // original
        XCTAssertEqual(obj.hello(), "NSObject-hello")
        XCTAssertEqual(obj.bye(), "NSObject-bye")
        XCTAssertEqual(NSObject.hello(), "NSObject+hello")
        XCTAssertEqual(NSObject.bye(), "NSObject+bye")
        
        swizzle()
        
        // swizzled
        XCTAssertEqual(obj.hello(), "NSObject-bye")
        XCTAssertEqual(obj.bye(), "NSObject-hello")
        XCTAssertEqual(NSObject.hello(), "NSObject+bye")
        XCTAssertEqual(NSObject.bye(), "NSObject+hello")
        
        swizzle()   // clean up
        
        // back to original
        XCTAssertEqual(obj.hello(), "NSObject-hello")
        XCTAssertEqual(obj.bye(), "NSObject-bye")
        XCTAssertEqual(NSObject.hello(), "NSObject+hello")
        XCTAssertEqual(NSObject.bye(), "NSObject+bye")
    }

    func testSubclass()
    {
        // NOTE: MyObject-hello is not implemented (uses super-method)
        
        let swizzle: Void -> Void = {
            (MyObject.self, "hello") <-> "bonjour"
            (MyObject.self, "hello") <+> "bonjour"
        }
        
        let obj = NSObject()
        let myObj = MyObject()
        
        // original
        XCTAssertEqual(myObj.hello(), "NSObject-hello")
        XCTAssertEqual(MyObject.hello(), "NSObject+hello")
        XCTAssertEqual(myObj.bonjour(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.bonjour(), "MyObject+bonjour")
        
        swizzle()
        
        // swizzled
        XCTAssertEqual(myObj.hello(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.hello(), "MyObject+bonjour")
        XCTAssertEqual(myObj.bonjour(), "NSObject-hello")
        XCTAssertEqual(MyObject.bonjour(), "NSObject+hello")
        
        swizzle()   // clean up
        
        // back to original
        XCTAssertEqual(myObj.hello(), "NSObject-hello")
        XCTAssertEqual(MyObject.hello(), "NSObject+hello")
        XCTAssertEqual(myObj.bonjour(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.bonjour(), "MyObject+bonjour")
    }
    
    func testSubclass_reversed()
    {
        // NOTE: MyObject-hello is not implemented (uses super-method)
        
        let swizzle: Void -> Void = {
            (MyObject.self, "bonjour") <-> "hello"  // reversed
            (MyObject.self, "bonjour") <+> "hello"  // reversed
        }
        
        let obj = NSObject()
        let myObj = MyObject()
        
        // original
        XCTAssertEqual(myObj.hello(), "NSObject-hello")
        XCTAssertEqual(MyObject.hello(), "NSObject+hello")
        XCTAssertEqual(myObj.bonjour(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.bonjour(), "MyObject+bonjour")
        
        swizzle()
        
        // swizzled
        XCTAssertEqual(myObj.hello(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.hello(), "MyObject+bonjour")
        XCTAssertEqual(myObj.bonjour(), "NSObject-hello")
        XCTAssertEqual(MyObject.bonjour(), "NSObject+hello")
        
        swizzle()   // clean up
        
        // back to original
        XCTAssertEqual(myObj.hello(), "NSObject-hello")
        XCTAssertEqual(MyObject.hello(), "NSObject+hello")
        XCTAssertEqual(myObj.bonjour(), "MyObject-bonjour")
        XCTAssertEqual(MyObject.bonjour(), "MyObject+bonjour")
    }
    
    func testDealloc()
    {
        let swizzle: Void -> Void = {
//            (MyObject.self, "dealloc") <-> "_swift_dealloc"   // comment-out: doesn't work
            (MyObject.self, "dealloc") <-> "_objc_dealloc"  // NOTE: swizzled_dealloc must be implemented as ObjC code
        }
        
        swizzle()
        
        let expect = self.expectationWithDescription(__FUNCTION__)
        
        MyObject() { // deinitClosure
            expect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
}
