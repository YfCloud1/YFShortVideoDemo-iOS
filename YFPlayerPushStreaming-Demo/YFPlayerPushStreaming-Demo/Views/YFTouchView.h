//
//  YFTouchView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTouchView : UIView

@property (nonatomic, strong) NSString *iconStringNomal;
@property (nonatomic, strong) NSString *iconStringSelected;
@property (nonatomic, strong) NSString *themeString;

@property (nonatomic, copy) void (^touchDownCallBack)(UIButton *icon,UIButton *title);

@property (nonatomic, copy) void (^touchExitCallBack)(UIButton *icon,UIButton *title);

//must call this func
- (instancetype)initWithIconNomal:(NSString *)nomal andSelected:(NSString *)selected andTheme:(NSString *)theme;

@end
