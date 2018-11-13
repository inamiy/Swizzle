//
//  SwizzleTests.swift
//  SwizzleTests
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import Swizzle
import AppKit
import XCTest

private let _key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)

class SwizzleUITests: XCTestCase
{
    func testHoge()
    {
        let swizzle: () -> Void = {
            swizzleInstanceMethod(
                NSView.self,
                from: #selector(getter: NSView.alphaValue),
                to: #selector(getter: NSView.__alphaValue)
            )
        }

        let view = NSView()

        // original
        XCTAssertEqual(view.alphaValue, 1)

        swizzle()

        // swizzled
        XCTAssertEqual(view.alphaValue, 0.5)

        // NOTE: Setter is not swizzled.
        view.alphaValue = 0.6

        XCTAssertEqual(view.alphaValue, 0.1, accuracy: 0.0001)

        swizzle()   // clean up

        XCTAssertEqual(view.alphaValue, 0.6)

        view.alphaValue = 1

        XCTAssertEqual(view.alphaValue, 1)
    }

    func testHoge2()
    {
        let swizzle: () -> Void = {
            swizzleInstanceMethod(
                NSView.self,
                from: #selector(getter: NSView.alphaValue),
                to: #selector(getter: NSView.__alphaValue2)
            )

            swizzleInstanceMethod(
                NSView.self,
                from: #selector(setter: NSView.alphaValue),
                to: #selector(NSView.__setAlphaValue2(_:))
            )
        }

        let view = NSView()

        // original
        XCTAssertEqual(view.alphaValue, 1)

        swizzle()

        // swizzled
        XCTAssertEqual(view.alphaValue, -1)

        // NOTE: Setter is not swizzled.
        view.alphaValue = 0.6

        XCTAssertEqual(view.alphaValue, 0.6)

        swizzle()   // clean up

        XCTAssertEqual(view.alphaValue, 0.6)

        view.alphaValue = 1

        XCTAssertEqual(view.alphaValue, 1)
    }
}

// MARK: - Private

extension NSView
{
    @objc fileprivate var __alphaValue: CGFloat
    {
        return self.__alphaValue - 0.5
    }

    @objc fileprivate var __alphaValue2: CGFloat
    {
        if let value = objc_getAssociatedObject(self, _key) as? CGFloat {
            return value
        }
        else {
            return -1 // default value
        }
    }

    @objc fileprivate func __setAlphaValue2(_ alpha: CGFloat)
    {
        self.__setAlphaValue2(alpha)
        objc_setAssociatedObject(self, _key, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
