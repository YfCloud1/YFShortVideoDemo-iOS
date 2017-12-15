//
//  YFInsFilterView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 8/15/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFInsFilterView.h"
#import "Masonry.h"
@interface YFInsFilterView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation YFInsFilterView
#define itemCount 8
- (instancetype)init{
    if (self = [super init]) {
        
        self.scrollView = [[UIScrollView alloc] init];
        CGFloat marginX = 10;
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        CGFloat viewW = 47;
        CGFloat viewH = viewW;
        self.scrollView.contentSize = CGSizeMake(itemCount* (viewW+marginX), 0);
        self.scrollView.pagingEnabled = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        self.scrollView.frame = CGRectMake(0, 40, size.width, 200-60);
        [self addSubview:self.scrollView];
        
        for (int i = 0; i < itemCount; ++i) {
            
            UIButton *btn = [[UIButton alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"filter%d",i];
            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(marginX+i*(marginX+viewW), 5, viewW, viewH);
            if (i == 0) {
                self.selectedBtn = btn;
            }
            [self.scrollView addSubview:btn];
        }
        
        __weak typeof(self)weakSelf = self;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:87/255.0 green:128/255.0 blue:127/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.right.equalTo(weakSelf).offset(-15);
            make.bottom.equalTo(weakSelf).offset(-57);
            make.height.mas_equalTo(2);
        }];
        
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [cancel addTarget:self action:@selector(didClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf).offset(-25);
            make.bottom.equalTo(weakSelf).offset(-5);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"滤镜";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf).offset(25);
            make.centerY.equalTo(cancel);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
    }
    
    return self;
}

- (void)didClickCancel:(UIButton *)sender{
    if (self.cancel) {
        self.cancel();
    }
}

- (void)didClickBtn:(UIButton *)sender{
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    sender.selected = YES;
    if (self.callBack) {
        if (sender.tag == 0) {
            self.callBack(0);
        }else if (sender.tag == 1){
           self.callBack(1);
        }else if (sender.tag == 2){
            self.callBack(2);
        }else if (sender.tag == 3){
            self.callBack(3);
        }else if (sender.tag == 4){
            self.callBack(4);
        }else if (sender.tag == 5){
            self.callBack(5);
        }else if (sender.tag == 6){
            self.callBack(6);
        }else if (sender.tag == 7){
            self.callBack(7);
        }
    }
    
}

@end
