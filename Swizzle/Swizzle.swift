//
//  Swizzle.swift
//  Swizzle
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import ObjectiveC

private func _swizzleMethod(_ class_: AnyClass, from selector1: Selector, to selector2: Selector, isClassMethod: Bool)
{
    let c: AnyClass
    if isClassMethod {
        c = object_getClass(class_)
    }
    else {
        c = class_
    }

    let method1: Method = class_getInstanceMethod(c, selector1)
    let method2: Method = class_getInstanceMethod(c, selector2)

    if class_addMethod(c, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
        class_replaceMethod(c, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
    }
    else {
        method_exchangeImplementations(method1, method2)
    }
}

/// Instance-method swizzling.
public func swizzleInstanceMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
    _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: false)
}

/// Instance-method swizzling for unsafe raw-string.
/// - Note: This is useful for non-`#selector`able methods e.g. `dealloc`, private ObjC methods.
public func swizzleInstanceMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
    swizzleInstanceMethod(class_, from: Selector(sel1), to: Selector(sel2))
}

/// Class-method swizzling.
public func swizzleClassMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
    _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: true)
}

/// Class-method swizzling for unsafe raw-string.
public func swizzleClassMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
    swizzleClassMethod(class_, from: Selector(sel1), to: Selector(sel2))
}
