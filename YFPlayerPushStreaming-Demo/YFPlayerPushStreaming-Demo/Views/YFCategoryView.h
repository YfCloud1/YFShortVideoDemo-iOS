//
//  YFCategoryView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/31/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFCategoryView : UIView

@property (nonatomic, copy) void (^specialCallBack)();
@property (nonatomic, copy) void (^gifCallBack)();
@property (nonatomic, copy) void (^timeSpecialCallBack)();

@end
