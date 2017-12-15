//
//  YFFunModel.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFFunModel : NSObject

@property (nonatomic, strong) NSString *iconNomal;
@property (nonatomic, strong) NSString *iconSelected;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)funcModelWithDict:(NSDictionary *)dict;

@end
