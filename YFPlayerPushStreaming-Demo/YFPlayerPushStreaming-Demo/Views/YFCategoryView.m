//
//  YFCategoryView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/31/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFCategoryView.h"
#import "Masonry.h"
#import "YFFuncView.h"
@interface YFCategoryView ()

@property (nonatomic, strong) YFFuncView *special;

@property (nonatomic, strong) YFFuncView *gif;

@property (nonatomic, strong) YFFuncView *timeSpecial;

@end

@implementation YFCategoryView

- (instancetype)init{
    if (self = [super init]) {
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    __weak typeof(self)weakSelf = self;
    
    [self.special mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_equalTo(60);
    }];
    
    [self.gif mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.special.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    [self.timeSpecial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.gif.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
}

- (YFFuncView *)special{
    if (!_special) {
        _special = [[YFFuncView alloc] initWithIconNomal:@"water1" andSelected:@"water1" andTheme:@"特效"];
        __weak typeof(self)weakSelf = self;
        _special.callBack = ^(UIButton *icon,UIButton *title){
            if (weakSelf.specialCallBack) {
                weakSelf.specialCallBack();
            }
        };
        
        [self addSubview:_special];
    }
    return _special;
}

- (YFFuncView *)gif{
    if (!_gif) {
        _gif = [[YFFuncView alloc] initWithIconNomal:@"gif1" andSelected:@"gif2" andTheme:@"Gif"];
        __weak typeof(self)weakSelf = self;
        _gif.callBack = ^(UIButton *icon,UIButton *title){
            if (weakSelf.gifCallBack) {
                weakSelf.gifCallBack();
            }
        };
        [self addSubview:_gif];
    }
    return _gif;
}

- (YFFuncView *)timeSpecial{
    if (!_timeSpecial) {
        _timeSpecial = [[YFFuncView alloc] initWithIconNomal:@"timeSpecial2" andSelected:@"timeSpecial1" andTheme:@"时光"];
        __weak typeof(self)weakSelf = self;
        _timeSpecial.callBack = ^(UIButton *icon,UIButton *title){
            if (weakSelf.timeSpecialCallBack) {
                weakSelf.timeSpecialCallBack();
            }
        };
        [self addSubview:_timeSpecial];
    }
    return _timeSpecial;
}

@end
