//
//  NSObject+Dealloc.m
//  Swizzle
//
//  Created by Yasuhiro Inami on 2014/10/05.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

#import "NSObject+Dealloc.h"

@implementation NSObject (Dealloc)

- (void)_objc_dealloc
{
    NSLog(@"_objc_dealloc");
    [self _objc_dealloc];
}

@end
