//
//  YFFunModel.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFFunModel.h"

@implementation YFFunModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)funcModelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

@end
