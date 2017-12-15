//
//  YFRange.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/16/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFRange.h"

@implementation YFRange

+ (instancetype)rangeWithLoc:(CGFloat)loc end:(CGFloat)end type:(Type)type {
    YFRange *instance = [[YFRange alloc]init];
    instance.loc = loc;
    instance.end = end;
    instance.type = type;
    return instance;
}

@end
