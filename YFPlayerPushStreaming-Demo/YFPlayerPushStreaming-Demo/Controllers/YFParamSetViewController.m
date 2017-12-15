//
//  YFParamSetViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/25/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFParamSetViewController.h"
#import "Masonry.h"
#import "UIImage+Gif.h"
#import "YFMusicShakeSetViewController.h"
@interface YFParamSetViewController ()

@property (nonatomic, strong) UIView *grayView;

@property (nonatomic, strong) UILabel *resolution;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *grayView2;
@property (nonatomic, strong) UILabel *outputBitrate;
@property (nonatomic, strong) UILabel *outputRate;
@property (nonatomic, strong) UITextField *textFieldBitrate;
@property (nonatomic, strong) UITextField *textFieldRate;
@property (nonatomic, strong) UIView *grayView3;
@property (nonatomic, strong) UIButton *start;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YFParamSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    UIButton *title = [[UIButton alloc] init];
    [title setTitle:@"设置参数" forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = title;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.equalTo(weakSelf.view);
    }];
    
    [self.grayView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64);
        make.height.mas_equalTo(1);
    }];
    
    [self.resolution mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.top.equalTo(weakSelf.grayView).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(120);
        make.centerY.equalTo(weakSelf.resolution);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.leftLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftBtn).offset(25);
        make.centerY.equalTo(weakSelf.leftBtn);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab).offset(100);
        make.centerY.equalTo(weakSelf.resolution);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.rightLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rightBtn).offset(25);
        make.centerY.equalTo(weakSelf.leftBtn);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    [self.grayView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64+50);
        make.height.mas_equalTo(1);
    }];
    
    [self.outputBitrate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.top.equalTo(weakSelf.grayView2).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.textFieldBitrate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(120);
        make.centerY.equalTo(weakSelf.outputBitrate);
        make.size.mas_equalTo(CGSizeMake(200, 35));
    }];
    
    [self.grayView3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64+100);
        make.height.mas_equalTo(1);
    }];
    
    [self.outputRate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.top.equalTo(weakSelf.grayView3).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];

    [self.textFieldRate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(120);
        make.centerY.equalTo(weakSelf.outputRate);
        make.size.mas_equalTo(CGSizeMake(200, 35));
    }];
    
    [self.start mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    
    [super updateViewConstraints];
}

- (void)didClickLeftBtn:(UIButton *)sender{
    self.selectBtn.backgroundColor = [UIColor grayColor];
    self.selectBtn = sender;
    sender.backgroundColor = [UIColor redColor];
}

- (void)didClickRightBtn:(UIButton *)sender{
    self.selectBtn.backgroundColor = [UIColor grayColor];
    self.selectBtn = sender;
    sender.backgroundColor = [UIColor redColor];
}

- (void)didClickStart:(UIButton *)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.textFieldBitrate.text.intValue) forKey:@"textFieldBitrate"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.textFieldRate.text.intValue) forKey:@"textFieldRate"];
    if (self.selectBtn == self.leftBtn) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"resolution"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"resolution"];
    }
    
    YFMusicShakeSetViewController *setVC = [[YFMusicShakeSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - 懒加载

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = [UIColor colorWithRed:14/255.0 green:78/255.0 blue:101/255.0 alpha:1];
        
        [self.view addSubview:_grayView];
    }
    return _grayView;
}

- (UILabel *)resolution{
    if (!_resolution) {
        _resolution = [[UILabel alloc] init];
        _resolution.text = @"分辨率";
        _resolution.textAlignment = NSTextAlignmentLeft;
        _resolution.textColor = [UIColor whiteColor];
        [self.view addSubview:_resolution];
    }
    return _resolution;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        
        [_leftBtn setBackgroundColor:[UIColor grayColor]];
        [_leftBtn addTarget:self action:@selector(didClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.cornerRadius = 10;
        _leftBtn.layer.masksToBounds = YES;
        [self.view addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UILabel *)leftLab{
    if (!_leftLab) {
        _leftLab = [[UILabel alloc] init];
        _leftLab.text = @"360P";
        _leftLab.textAlignment = NSTextAlignmentLeft;
        _leftLab.textColor = [UIColor whiteColor];
        _leftLab.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_leftLab];
    }
    return _leftLab;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setBackgroundColor:[UIColor redColor]];
        self.selectBtn = _rightBtn;
        [_rightBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.layer.cornerRadius = 10;
        _rightBtn.layer.masksToBounds = YES;
        [self.view addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] init];
        _rightLab.text = @"540P";
        _rightLab.textAlignment = NSTextAlignmentLeft;
        _rightLab.textColor = [UIColor whiteColor];
        _rightLab.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_rightLab];
    }
    return _rightLab;
}

- (UIView *)grayView2{
    if (!_grayView2) {
        _grayView2 = [[UIView alloc] init];
        _grayView2.backgroundColor = [UIColor colorWithRed:14/255.0 green:78/255.0 blue:101/255.0 alpha:1];
        [self.view addSubview:_grayView2];
    }
    return _grayView2;
}

- (UILabel *)outputBitrate{
    if (!_outputBitrate) {
        _outputBitrate = [[UILabel alloc] init];
        _outputBitrate.text = @"输出码率";
        _outputBitrate.textAlignment = NSTextAlignmentLeft;
        _outputBitrate.textColor = [UIColor whiteColor];
        [self.view addSubview:_outputBitrate];
    }
    return _outputBitrate;
}

- (UITextField *)textFieldBitrate{
    if (!_textFieldBitrate) {
        _textFieldBitrate = [[UITextField alloc] init];
        _textFieldBitrate.borderStyle = UITextBorderStyleRoundedRect;
        _textFieldBitrate.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldBitrate.textColor = [UIColor whiteColor];
        _textFieldBitrate.text = @"2000";
        _textFieldBitrate.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_textFieldBitrate];
    }
    return _textFieldBitrate;
}

- (UILabel *)outputRate{
    if (!_outputRate) {
        _outputRate = [[UILabel alloc] init];
        _outputRate.text = @"输出帧率";
        _outputRate.textAlignment = NSTextAlignmentLeft;
        _outputRate.textColor = [UIColor whiteColor];
        [self.view addSubview:_outputRate];
    }
    return _outputRate;
}

- (UITextField *)textFieldRate{
    if (!_textFieldRate) {
        _textFieldRate = [[UITextField alloc] init];
        _textFieldRate.borderStyle = UITextBorderStyleRoundedRect;
        _textFieldRate.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldRate.textColor = [UIColor whiteColor];
        _textFieldRate.text = @"25";
        _textFieldRate.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_textFieldRate];
    }
    return _textFieldRate;
}

- (UIView *)grayView3{
    if (!_grayView3) {
        _grayView3 = [[UIView alloc] init];
        _grayView3.backgroundColor = [UIColor colorWithRed:14/255.0 green:78/255.0 blue:101/255.0 alpha:1];
        [self.view addSubview:_grayView3];
    }
    return _grayView3;
}

- (UIButton *)start{
    if (!_start) {
        _start = [[UIButton alloc] init];
        [_start setBackgroundImage:[UIImage imageNamed:@"backBtn1"] forState:UIControlStateNormal];
        [_start setBackgroundImage:[UIImage imageNamed:@"backBtn2"] forState:UIControlStateHighlighted];
        [_start setTitle:@"开始体验" forState:UIControlStateNormal];
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_start addTarget:self action:@selector(didClickStart:) forControlEvents:UIControlEventTouchUpInside];
        _start.layer.cornerRadius = 10;
        _start.layer.masksToBounds = YES;
        [self.view addSubview:_start];
    }
    return _start;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"short-bg2"]];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

@end
