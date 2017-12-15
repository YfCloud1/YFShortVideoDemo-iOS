//
//  YFBeautyView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBeautyView : UIView

@property (nonatomic, copy) void (^callBack)(int i);
@property (nonatomic, copy) void (^cancel)();

@end
