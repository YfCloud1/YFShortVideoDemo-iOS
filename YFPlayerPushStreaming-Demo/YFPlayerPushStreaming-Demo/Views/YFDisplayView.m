//
//  YFDisplayView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/13/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFDisplayView.h"

@implementation YFDisplayView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p1 = [touch locationInView:self.superview];
    NSLog(@"p1.x = %f",p1.x);
    if (self.touchValue) {
        self.touchValue(p1);
    }
}

@end
