//
//  YFSplitVideoView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/30/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSplitVideoView : UIView

@property (nonatomic, assign) int pictureCount;

@property (nonatomic, strong) NSString *rightText;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, copy) void (^leftCallBack)(CGFloat value);

@property (nonatomic, copy) void (^rightCallBack)(CGFloat value);

@end
