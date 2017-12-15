//
//  YFLiveSettingView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/5/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFLiveSettingView : UIView

@property (nonatomic, copy) void (^cancel)();

- (instancetype)initWithCallBack:(void(^)(UIButton *icon,UIButton *btn))callBack;

@end
