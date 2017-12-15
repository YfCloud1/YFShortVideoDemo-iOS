//
//  YFDetailView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/1/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFDetailView.h"
#import "Masonry.h"
@interface YFDetailView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation YFDetailView

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    __weak typeof(self)weakSelf = self;
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"弱网直播可克服以下3大问题:";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(30);
        make.left.equalTo(weakSelf).offset(25);
        make.right.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"* 户外直播,网络不稳定";
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.textColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    lab1.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(25);
        make.top.equalTo(title.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.text = @"* 连接被重置、断线重连";
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.textColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    lab2.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(25);
        make.top.equalTo(lab1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.text = @"* GPRS/2G/3G/4G切换时,内容发送不出去";
    lab3.textAlignment = NSTextAlignmentLeft;
    lab3.textColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    lab3.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(25);
        make.top.equalTo(lab2.mas_bottom).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lab4 = [[UILabel alloc] init];
    lab4.text = @"  feu:延迟更低    udp:性能更好";
    lab4.textAlignment = NSTextAlignmentLeft;
    lab4.textColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    lab4.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab4];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(25);
        make.top.equalTo(lab3.mas_bottom).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView"]];
        [self addSubview:_bgImgView];
    }
    return _bgImgView;
}


@end
