//
//  YFImageView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/30/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFImageView : UIImageView

@property (nonatomic, assign) CGFloat leftLimitValue;
@property (nonatomic, assign) CGFloat rightLimitValue;
@property (nonatomic, copy) void (^touchValue)(CGFloat value);


@end
