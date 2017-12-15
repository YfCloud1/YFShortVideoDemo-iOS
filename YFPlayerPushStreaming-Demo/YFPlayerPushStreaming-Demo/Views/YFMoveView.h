//
//  YFMoveView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/13/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFMoveView : UIView

@property (nonatomic, copy) void(^moveCallBack)(CGFloat pointX);

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat pointX;

@end
