//
//  YFMoveView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/13/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFMoveView.h"

@implementation YFMoveView

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint p1 = [touch locationInView:self.superview];
    CGPoint p2 = [touch previousLocationInView:self.superview];
    
    CGPoint center = self.center;
    
    center.x += (p1.x - p2.x);
    
    self.center = center;

    if (self.moveCallBack) {
        self.moveCallBack(p1.x);
    }
}

- (void)setPointX:(CGFloat)pointX{
    
    if (isnan(pointX)) {
        return;
    }
    
    _pointX = pointX;
    CGPoint center = self.center;
    center.x = pointX;
    
    self.center = center;
}

@end
