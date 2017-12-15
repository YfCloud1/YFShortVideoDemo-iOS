//
//  YFDisplayView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/13/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFDisplayView : UIView
//将点的值传出去
@property (nonatomic, copy) void (^touchValue)(CGPoint point);

@end
