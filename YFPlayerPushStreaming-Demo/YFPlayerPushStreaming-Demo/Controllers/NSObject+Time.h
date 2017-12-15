//
//  NSObject+Time.h
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/3/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/time.h>
@interface NSObject (Time)

- (struct timeval)getStartTime;

- (struct timeval)getEndTime;

//microseconds
- (long int)getIntervalTime;

@end
