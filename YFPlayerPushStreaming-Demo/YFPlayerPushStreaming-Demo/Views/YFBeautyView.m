//
//  YFBeautyView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFBeautyView.h"
#import "Masonry.h"
@interface YFBeautyView ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation YFBeautyView

- (instancetype)init{
    if (self = [super init]) {
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    __weak typeof(self)weakSelf = self;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSInteger isVertical = [[NSUserDefaults standardUserDefaults] integerForKey:@"isVertical"];
    CGFloat margin = 0;
    CGFloat viewW = (screenSize.width - 6 * 30)/5;
    if (isVertical) {
        margin = 30;
    }else{
        margin = (screenSize.height - 5*47)/6;
    }
    
    for (int i = 0; i < 5; ++i) {
        
        int col_count = i % 5;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.selected = NO;
        if (i == 0) {
            [btn setTitle:@"无" forState:UIControlStateNormal];
        }else{
            [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"nomal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(didClickBeautyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(margin + col_count * (margin + viewW));
            make.top.equalTo(weakSelf).offset(20);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:87/255.0 green:128/255.0 blue:127/255.0 alpha:1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(margin);
        make.right.equalTo(weakSelf).offset(-margin);
        make.bottom.equalTo(weakSelf).offset(-67);
        make.height.mas_equalTo(2);
    }];
    
    UIButton *cancel = [[UIButton alloc] init];
    [cancel setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf).offset(-25);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"美颜";
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf).offset(25);
        make.centerY.equalTo(cancel);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
}

- (void)didClickBeautyBtn:(UIButton *)sender{
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    sender.selected = YES;
    
    if (self.callBack) {
        [self callBackEvent:sender];
    }
}

- (void)cancelEvent:(UIButton *)sender{
    
    if (self.cancel) {
        self.cancel();
    }
    
}

- (void)callBackEvent:(UIButton *)btn{
    NSString *title = btn.titleLabel.text;
    if ([title containsString:@"无"]) {
        self.callBack(0);
    }else if ([title isEqualToString:@"1"]){
        self.callBack(1);
    }else if ([title isEqualToString:@"2"]){
        self.callBack(2);
    }else if ([title isEqualToString:@"3"]){
        self.callBack(3);
    }else if ([title isEqualToString:@"4"]){
        self.callBack(4);
    }
}

- (NSArray *)dataArr{
    if (_dataArr) {
        _dataArr = @[@"无",@"1",@"2",@"3",@"4"];
    }
    return _dataArr;
}

@end
