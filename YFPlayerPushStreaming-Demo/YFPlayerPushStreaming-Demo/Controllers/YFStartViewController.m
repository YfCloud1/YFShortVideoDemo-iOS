//
//  YFStartViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/25/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFStartViewController.h"
#import "YFParamSetViewController.h"
#import "Masonry.h"
@interface YFStartViewController ()

@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *version;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YFStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSubView];
}

- (void)setUpSubView{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self.start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(68, 65));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.start.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [self.version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
}

- (void)didClickNext:(UIButton *)sender{
    
    YFParamSetViewController *setVC = [[YFParamSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIButton *)start{
    if (!_start) {
        _start = [[UIButton alloc] init];
        [_start setBackgroundImage:[UIImage imageNamed:@"startSortVideo"] forState:UIControlStateNormal];
        [_start setBackgroundImage:[UIImage imageNamed:@"startSortVideo2"] forState:UIControlStateHighlighted];
        
        [_start addTarget:self action:@selector(didClickNext:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_start];
    }
    return _start;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"音乐短视频";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)version{
    if (!_version) {
        _version = [[UILabel alloc] init];
        _version.textAlignment = NSTextAlignmentCenter;
        _version.textColor = [UIColor whiteColor];
        _version.text = @"v2.0.3";
        [self.view addSubview:_version];
    }
    return _version;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"short-bg"]];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

@end
