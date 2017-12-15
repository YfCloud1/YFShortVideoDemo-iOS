//
//  YFProgressView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 5/16/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat startPointX;

@end
