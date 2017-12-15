//
//  YFSpecialFilterView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/31/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFSpecialFilterView.h"
#import "Masonry.h"
#import "YFTouchView.h"
#import "YFFunModel.h"
@interface YFSpecialFilterView ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *bottomTitle;


@end


@implementation YFSpecialFilterView

- (instancetype)init{
    if (self = [super init]) {
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    __weak typeof(self)weakSelf = self;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-40);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
}

- (void)setTheme:(NSString *)theme{
    _bottomTitle.text = theme;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bottomTitle.text = theme;
    });
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    CGFloat viewW = 60;
    CGFloat viewH = 80;
    __weak typeof(self)weakSelf = self;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - titleArr.count*viewW)/(titleArr.count+1);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < titleArr.count; ++i) {
            YFFunModel * model = titleArr[i];
            YFTouchView *touchView = [[YFTouchView alloc] initWithIconNomal:model.iconNomal andSelected:model.iconSelected andTheme:model.title];
            touchView.touchDownCallBack = ^(UIButton *icon,UIButton *title){
                
                if (weakSelf.touchDownCallBack) {
                    weakSelf.touchDownCallBack(icon,title);
                }
            };
            
            touchView.touchExitCallBack = ^(UIButton *icon,UIButton *title){
                
                if (weakSelf.touchExitCallBack) {
                    weakSelf.touchExitCallBack(icon,title);
                }
            };
            
            touchView.frame = CGRectMake(margin+i*(viewW+margin), 0, 60, viewH);
            [self addSubview:touchView];
        }
    });
}

#pragma mark - 懒加载
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1];
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel *)bottomTitle{
    if (!_bottomTitle) {
        _bottomTitle = [[UILabel alloc] init];
        _bottomTitle.text = @"无";
        _bottomTitle.textAlignment = NSTextAlignmentCenter;
        _bottomTitle.textColor = [UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1];
        [self addSubview:_bottomTitle];
    }
    return _bottomTitle;
}

@end
