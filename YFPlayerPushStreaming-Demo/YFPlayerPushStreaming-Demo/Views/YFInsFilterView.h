//
//  YFInsFilterView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 8/15/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFInsFilterView : UIView

@property (nonatomic, copy) void (^cancel)();
@property (nonatomic, copy) void (^callBack)(int i);

@end
