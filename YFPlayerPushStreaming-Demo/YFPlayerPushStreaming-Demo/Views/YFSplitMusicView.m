//
//  YFSplitMusicView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/29/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFSplitMusicView.h"

@interface YFSplitMusicView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YFSplitMusicView



- (instancetype)init{
    if (self = [super init]) {
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = self.bounds;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audioPicture"]];
        iconView.frame = CGRectMake(0, 0, 2*screenSize.width, self.bounds.size.height);
        [self.scrollView addSubview:iconView];
        
        self.scrollView.contentSize = CGSizeMake(2*screenSize.width, self.bounds.size.height);
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
    });
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGPoint offset = self.scrollView.contentOffset;
    
    if (self.scrollViewCallback) {
        self.scrollViewCallback(offset.x);
    }
}


@end
