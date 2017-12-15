//
//  NSObject+Time.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/3/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "NSObject+Time.h"

struct timeval start;
struct timeval end;

@implementation NSObject (Time)

- (struct timeval)getStartTime{
    gettimeofday(&start, nil);
    NSLog(@"开始时间%ld",1000000 *start.tv_sec+start.tv_usec);
    return start;
}

- (struct timeval)getEndTime{
    gettimeofday(&end, nil);
    return end;
}

- (long int)getIntervalTime{
    
    return 1000000 * (end.tv_sec-start.tv_sec)+ end.tv_usec-start.tv_usec;
}

@end
