//
//  Swizzle.swift
//  Swizzle
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import ObjectiveC

internal func swizzleMethod(var class_: AnyClass!, selector1 sel1: String!, selector2 sel2: String!, #isClassMethod: Bool)
{
    if isClassMethod {
        class_ = object_getClass(class_)
    }
    
    let selector1 = Selector(sel1)
    let selector2 = Selector(sel2)
    
    var method1: Method = class_getInstanceMethod(class_, selector1)
    var method2: Method = class_getInstanceMethod(class_, selector2)
    
    if class_addMethod(class_, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
        class_replaceMethod(class_, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
    }
    else {
        method_exchangeImplementations(method1, method2)
    }
}

public func swizzleInstanceMethod(var class_: AnyClass!, sel1: String!, sel2: String!)
{
    swizzleMethod(class_, selector1: sel1, selector2: sel2, isClassMethod: false)
}

public func swizzleClassMethod(var class_: AnyClass!, sel1: String!, sel2: String!)
{
    swizzleMethod(class_, selector1: sel1, selector2: sel2, isClassMethod: true)
}

//--------------------------------------------------
// MARK: - Custom Operators
// + - * / % = < > ! & | ^ ~ .
//--------------------------------------------------

infix operator <-> { associativity left }

/// Usage: (MyObject.self, "hello") <-> "bye"
public func <-> (tuple: (class_: AnyClass!, selector1: String!), selector2: String!)
{
    swizzleInstanceMethod(tuple.class_, tuple.selector1, selector2)
}

infix operator <+> { associativity left }

/// Usage: (MyObject.self, "hello") <+> "bye"
public func <+> (tuple: (class_: AnyClass!, selector1: String!), selector2: String!)
{
    swizzleClassMethod(tuple.class_, tuple.selector1, selector2)
}
