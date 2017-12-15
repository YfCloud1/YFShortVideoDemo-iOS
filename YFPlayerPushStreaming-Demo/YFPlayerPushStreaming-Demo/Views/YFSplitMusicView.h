//
//  YFSplitMusicView.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/29/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSplitMusicView : UIView

@property (nonatomic, copy) void (^scrollViewCallback)(CGFloat leftValue);

@end
