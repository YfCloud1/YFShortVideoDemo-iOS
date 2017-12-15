//
//  YFPaintView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/17/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFPaintView.h"
#import "YFBezierPath.h"

@implementation YFPaintView

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i<self.pathPoints.count; i++) {
        
            YFBezierPath *path = self.pathPoints[i];
            [path.myColor set];
            CGContextSetLineWidth(ctx, path.mylineWidth);
            //添加路径
            CGContextAddPath(ctx, path.CGPath);
            CGContextStrokePath(ctx);
    }
    
}

- (void)startWithProgress:(CGFloat)start{
    YFBezierPath *path = [YFBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start, 0)];
    NSLog(@"#######strat = %f",start);
    //设置自己的颜色，线宽
    path.mylineWidth = self.myLineWidth == 0 ? 15:self.myLineWidth;
    path.myColor = self.myColor;
    
    [self.pathPoints addObject:path];
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress{
    
    YFBezierPath *path =  [self.pathPoints lastObject];
    [path addLineToPoint:CGPointMake(progress, 0)];
    [self setNeedsDisplay];
    
}

- (void)endWithProgress:(CGFloat)end{
    YFBezierPath *path = [self.pathPoints lastObject];
    [path addLineToPoint:CGPointMake(end, 0)];
    NSLog(@"######end = %f",end);
    [self setNeedsDisplay];
}

#pragma mark - 懒加载

//懒加载
- (NSMutableArray *)pathPoints{
    if (!_pathPoints) {
        _pathPoints = [NSMutableArray array];
    }
    
    return _pathPoints;
}

//清除
- (void)clear{
    [self.pathPoints removeAllObjects];
    [self setNeedsDisplay];
}

//撤销
- (void)removeLast{
    [self.pathPoints removeLastObject];
    [self setNeedsDisplay];
}

@end
