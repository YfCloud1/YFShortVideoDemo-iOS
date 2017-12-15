//
//  YFImageView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/30/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFImageView.h"

@implementation YFImageView

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p1 = [touch locationInView:self.superview];
    CGPoint p2 = [touch previousLocationInView:self.superview];
    
    CGPoint center = self.center;
    
    if (self.leftLimitValue) {
        if (center.x < self.leftLimitValue) {
            center.x = self.leftLimitValue;
        }
    }
    if (self.rightLimitValue) {
        if (center.x > self.rightLimitValue) {
            center.x = self.rightLimitValue;
        }
    }
    
    center.x += (p1.x - p2.x);
    
    self.center = center;
    
    if (self.touchValue) {
        self.touchValue(p1.x);
    }
}

@end
