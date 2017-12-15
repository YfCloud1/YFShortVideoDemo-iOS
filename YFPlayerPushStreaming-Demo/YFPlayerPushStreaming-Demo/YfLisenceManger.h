//
//  YfLisenceManger.h
//  IJKMediaPlayer
//
//  Created by 张涛 on 2017/7/25.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>


//鉴权失败，不允许使用
#define _YfAuthResult_Error  -1;


//正常鉴权 允许使用
#define _YfAuthResult_Success 0


//超时情况下 让使用一次
#define _YfAuthResult_TimeOut 1

typedef void(^YfAuthResult)(int flag, NSString *description);


@interface YfLisenceManger : NSObject


//测试ak
//5cac66cf999fba09a9aabe674d21a82098d597d4

//测试tk
//fc00e8546afd27dbce70222c2a8f963f337fdaea

//针对流媒体鉴权，本地文件不鉴权
+ (void)LisenceWithAK:(const char*)access_key Token:(const char*)token YfAuthResult:(YfAuthResult)YfAuthResult;

@end
