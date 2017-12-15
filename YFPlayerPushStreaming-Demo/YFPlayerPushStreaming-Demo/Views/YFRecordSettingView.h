//
//  YFRecordSettingView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFRecordSettingView : UIView

@property (nonatomic, copy) void (^cancel)();

- (instancetype)initWithCallBack:(void(^)(UIButton *icon,UIButton *btn))callBack;

@end
