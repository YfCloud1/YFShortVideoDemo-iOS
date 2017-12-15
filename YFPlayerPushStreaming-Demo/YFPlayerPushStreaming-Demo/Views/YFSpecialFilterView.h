//
//  YFSpecialFilterView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/31/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSpecialFilterView : UIView

@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, copy) void (^touchDownCallBack)(UIButton *icon,UIButton *title);
@property (nonatomic, copy) void (^touchExitCallBack)(UIButton *icon,UIButton *title);


@end
