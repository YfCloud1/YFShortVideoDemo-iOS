//
//  YFPaintView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/17/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFPaintView : UIView

@property(nonatomic,assign)CGFloat myLineWidth;
@property (nonatomic,strong) UIColor *myColor;

@property (nonatomic, assign) CGFloat progress;
//贝塞尔曲线数组
@property(nonatomic,strong)NSMutableArray *pathPoints;

- (void)startWithProgress:(CGFloat)start;

- (void)endWithProgress:(CGFloat)end;

- (void)clear;
- (void)removeLast;

@end
