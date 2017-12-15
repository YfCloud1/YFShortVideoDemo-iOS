//
//  YFDrawButton.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 8/1/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFDrawButton.h"

@implementation YFDrawButton

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p1 = [touch locationInView:self];
    CGPoint p2 = [touch previousLocationInView:self];
    
    CGPoint center = self.center;
    center.x += (p1.x - p2.x);
    center.y += (p1.y - p2.y);
    
    self.center = center;
}

@end
