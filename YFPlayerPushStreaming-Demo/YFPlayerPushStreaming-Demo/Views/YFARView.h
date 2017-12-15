//
//  YFARView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/4/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFARView : UIView

@property (nonatomic, copy) void (^cancel)();
@property (nonatomic, copy) void (^callBack)(int i);

@end
