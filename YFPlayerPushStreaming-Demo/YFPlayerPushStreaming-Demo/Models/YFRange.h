//
//  YFRange.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/16/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YFMediaPlayerPushStreaming/YfSessionCamera.h>
typedef enum : NSUInteger {
    ActionNone = 0,
    ActionTextures,//faceU
    ActionBeautifulFilter,//美颜
    ActionInsFilter,//ins
    ActionSpecialFilter,//特效
    ActionTextureFilter,//水印
    ActionAmazingFilter, //特殊效果等等
} Type;

typedef enum : NSUInteger {
    None = 0,
    SoulShake,//灵魂抖动
    Gif, //gif
    MultiBoxNine, //九宫格
    MultiBoxFour, //四宫格
    MirrorUpDown,   //上下镜像
    MirrorLeftRight, //左右镜像
} YfAmazingFilter;

@interface YFRange : NSObject

@property (nonatomic, assign) CGFloat loc;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) Type type;
@property (nonatomic, assign) YFINSTCameraFilterType insType;
@property (nonatomic, assign) YfSessionCameraBeautifulFilter beautyType;
@property (nonatomic, assign) YfSessionCameraFilter specialType;
@property (nonatomic, assign) YfAmazingFilter amazingFilter;

@property (nonatomic, strong) NSString *texTureName;
//@property (nonatomic, assign) NSInteger state;//1-loc,2-end,0-loc&end

+ (instancetype)rangeWithLoc:(CGFloat)loc end:(CGFloat)end type:(Type)type;

@end
