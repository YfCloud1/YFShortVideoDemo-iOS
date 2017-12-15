//
//  YFARView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/4/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFARView.h"
#import "Masonry.h"

@interface YFARView ()

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation YFARView

- (instancetype)init{
    if (self = [super init]) {
        __weak typeof(self)weakSelf = self;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat marginX = 0;
        CGFloat marginY = 10;
        
        CGFloat viewW = (screenSize.width - 5 * 30)/4;
        CGFloat viewH = viewW;
        
        NSInteger isVertical = [[NSUserDefaults standardUserDefaults] integerForKey:@"isVertical"];
        if (isVertical) {
            marginX = 30;
        }else{
            marginX = (screenSize.height - 4*47)/5;
        }
        
        int colCount = 4;
        for (int i = 0; i < 8; i++) {
            
            int col_count = i%colCount;
            int row_count = i/colCount;
            
            UIButton * arview = [[UIButton alloc] init];
            arview.selected = NO;
            arview.tag = i;
            
            if (i == 0) {
                [arview setTitle:@"无" forState:UIControlStateNormal];
                [arview setBackgroundImage:[UIImage imageNamed:@"nomal"] forState:UIControlStateNormal];
            }else{
                NSString *imgName = [NSString stringWithFormat:@"arViewName%d",i];
                [arview setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            }
            [arview addTarget:self action:@selector(didClickARBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:arview];
            [arview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf).offset(marginX + col_count*(marginX + viewW));
                make.top.equalTo(weakSelf).offset(marginY + row_count*(marginY + viewH));
                make.size.mas_equalTo(CGSizeMake(47, 47));
            }];
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:87/255.0 green:128/255.0 blue:127/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.right.equalTo(weakSelf).offset(-15);
            make.bottom.equalTo(weakSelf).offset(-67);
            make.height.mas_equalTo(2);
        }];
        
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [cancel addTarget:self action:@selector(cancelAREvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf).offset(-25);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"AR";
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

- (void)didClickARBtn:(UIButton *)sender{
    
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    sender.selected = YES;
    
    if (sender.tag == 0) {
        if (self.callBack) {
            self.callBack(0);
        }
    }else if (sender.tag == 1){
        if (self.callBack) {
            self.callBack(1);
        }
    }else if (sender.tag == 2){
        if (self.callBack) {
            self.callBack(2);
        }
    }else if (sender.tag == 3){
        if (self.callBack) {
            self.callBack(3);
        }
    }else if (sender.tag == 4){
        if (self.callBack) {
            self.callBack(4);
        }
    }else if (sender.tag == 5){
        if (self.callBack) {
            self.callBack(5);
        }
    }else if (sender.tag == 6){
        if (self.callBack) {
            self.callBack(6);
        }
    }else if (sender.tag == 7){
        if (self.callBack) {
            self.callBack(7);
        }
    }
}

//取消事件
- (void)cancelAREvent:(UIButton *)sender{
    
    if (self.cancel) {
        self.cancel();
    }
}

@end
