//
//  YFUploadProcessView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/27/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFUploadProcessView.h"
#import "Masonry.h"
@interface YFUploadProcessView()

@property (nonatomic, weak) UILabel *label;

@end

@implementation YFUploadProcessView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat arc = M_PI * 2 * self.progress;
    CGContextAddArc(ctx, rect.size.width * 0.5, rect.size.height * 0.5, 100, 0, arc, 0);
    CGContextAddLineToPoint(ctx, rect.size.width * 0.5, rect.size.height * 0.5);
    CGContextClosePath(ctx);
    
    [[UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1] set];
    CGContextFillPath(ctx);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (instancetype)init{
    if (self = [super init]) {
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        __weak typeof(self)weakSelf = self;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        label.textColor = [UIColor whiteColor];
        label.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        label.textAlignment = NSTextAlignmentCenter;
        self.label = label;
    }
    return self;
}


- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    });
    [self setNeedsDisplay];
}

@end
