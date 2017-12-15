//
//  YFSplitVideoView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/30/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFSplitVideoView.h"
#import "Masonry.h"
#import "YFImageView.h"
@interface YFSplitVideoView ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *theme;
@property (nonatomic, strong) YFImageView *leftImg;
@property (nonatomic, strong) YFImageView *rightImg;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *grayViewOne;
@property (nonatomic, strong) UIView *grayViewTwo;

@end

@implementation YFSplitVideoView

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
        make.bottom.equalTo(weakSelf).offset(-60);
        make.height.mas_equalTo(1);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf).offset(-20);
        make.bottom.equalTo(weakSelf).offset(-15);
        make.size.mas_equalTo(CGSizeMake(36, 26));
    }];
    
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf).offset(40);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(5);
        make.top.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-5);
        make.top.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.grayViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(30);
        make.size.mas_equalTo(CGSizeMake(0, 45));
    }];
    
    [self.grayViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(30);
        make.size.mas_equalTo(CGSizeMake(0, 45));
    }];
}

- (void)setPictureCount:(int)pictureCount{
    
    _pictureCount = pictureCount;
    
    NSString *path = [self getJpgDocumentsPath];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat viewW = size.width/15;
    CGFloat interval = self.pictureCount/15;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 15; ++i) {
            NSString *str = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(i*interval)+1];
            UIImageView *imagView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:str]];
            imagView.frame = CGRectMake(viewW*i, 30, viewW, viewW*16/9);
            [self addSubview:imagView];
        }
        self.leftImg.frame = CGRectMake(0, 30, 40, 54);
        self.rightImg.frame = CGRectMake(self.bounds.size.width-40, 30, 40, 54);
        [self bringSubviewToFront:self.grayViewOne];
        [self bringSubviewToFront:self.grayViewTwo];
        [self bringSubviewToFront:self.leftImg];
        [self bringSubviewToFront:self.rightImg];
    });
    
}

- (void)setRightText:(NSString *)rightText{
    _rightText = rightText;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rightLabel.text = rightText;
    });
}

//创建文件目录
- (NSString *)getJpgDocumentsPath{
    
    NSString *path = [self getDocumentsPath];
    path = [path stringByAppendingPathComponent:@"jpg"];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!res) {
            NSLog(@"创建目录失败");
        }
    }
    
    return path;
    
}

//获取document路径
- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
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

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split"]];
        
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)theme{
    if (!_theme) {
        _theme = [[UILabel alloc] init];
        _theme.text = @"裁剪视频";
        _theme.font = [UIFont systemFontOfSize:18];
        [_theme setTextColor:[UIColor whiteColor]];
        [self addSubview:_theme];
    }
    return _theme;
}

- (YFImageView *)leftImg{
    if (!_leftImg) {
        _leftImg = [[YFImageView alloc] initWithImage:[UIImage imageNamed:@"left"]];
        _leftImg.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        _leftImg.touchValue = ^(CGFloat value){
            
            float text = weakSelf.duration*value/weakSelf.bounds.size.width;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.leftLabel.text = [NSString stringWithFormat:@"00:%.2d",(int)text];
                
                [weakSelf.grayViewOne mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(value);
                }];
                
            });
            
            weakSelf.rightImg.leftLimitValue = value;
            
            if (weakSelf.leftCallBack) {
                weakSelf.leftCallBack(text);
            }
        };
        [self addSubview:_leftImg];
    }
    return _leftImg;
}

- (UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[YFImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
        _rightImg.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        _rightImg.touchValue = ^(CGFloat value){
            
            float text = weakSelf.duration*value/weakSelf.bounds.size.width;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.rightLabel.text = [NSString stringWithFormat:@"00:%.2d",(int)text];
                
                [weakSelf.grayViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(weakSelf.bounds.size.width-value);
                }];
            });
            
            weakSelf.leftImg.rightLimitValue = value;
            
            if (weakSelf.rightCallBack) {
                weakSelf.rightCallBack(text);
            }
        };
        [self addSubview:_rightImg];
    }
    return _rightImg;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text =  @"00:00";
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"00:00";
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

- (UIView *)grayViewOne{
    if (!_grayViewOne) {
        _grayViewOne = [[UIView alloc] init];
        _grayViewOne.backgroundColor = [UIColor blackColor];
        _grayViewOne.alpha = 0.8;
        [self addSubview:_grayViewOne];
    }
    return _grayViewOne;
}

- (UIView *)grayViewTwo{
    if (!_grayViewTwo) {
        _grayViewTwo = [[UIView alloc] init];
        _grayViewTwo.backgroundColor = [UIColor blackColor];
        _grayViewTwo.alpha = 0.8;
        [self addSubview:_grayViewTwo];
    }
    return _grayViewTwo;
}

@end
