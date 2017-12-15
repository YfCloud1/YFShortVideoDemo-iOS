//
//  YFSplitViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/29/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFSplitViewController.h"
#import "YFEditViewController.h"
#import <YfMediaPlayer/YfMediaPlayer.h>
#import "Masonry.h"
#import "YFSplitVideoView.h"
@interface YFSplitViewController ()<YfFFMoviePlayerControllerDelegate>

@property (nonatomic, strong) YfFFMoviePlayerController *mediaPlayer;
@property (nonatomic, strong) UIButton *exit;
@property (nonatomic, strong) UIButton *sure;
@property (nonatomic, assign) int pictureCount;
@property (nonatomic, strong) YFSplitVideoView *splitVideoView;

@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;
@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation YFSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getThumSuccess:) name:@"GetThumbnailSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsplitVideo:) name:@"splitVideoSucess" object:nil];
    
    [self.view addSubview:self.mediaPlayer.view];
    self.mediaPlayer.view.frame = self.view.bounds;
    [self.mediaPlayer play];
    
    [self performMethod];
    //获取缩略图
    [self displayThum];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)getThumSuccess:(NSNotification *)noti{
    self.pictureCount = [[noti object] intValue];
    NSLog(@"self.pictureCount = %d",self.pictureCount);
    self.splitVideoView.pictureCount = self.pictureCount;
    self.splitVideoView.rightText = [NSString stringWithFormat:@"%.2d:%.2d",(int)self.mediaPlayer.duration/60,(int)self.mediaPlayer.duration%60];
    self.splitVideoView.duration = self.mediaPlayer.duration;
    __weak typeof(self)weakSelf = self;
    self.splitVideoView.leftCallBack = ^(CGFloat value){
        weakSelf.leftValue = value;
        weakSelf.mediaPlayer.currentPlaybackTime = value;
    };
    
    self.splitVideoView.rightCallBack = ^(CGFloat value){
        //该值为播放结束的值
        weakSelf.rightValue = value;
    };
    
}

- (void)performMethod{
    
    if (self.rightValue != 0) {
        if (self.mediaPlayer.currentPlaybackTime >= self.rightValue) {
            if ([self.mediaPlayer isPlaying]) {
                [self.mediaPlayer pause];
            }
        }
    }

    [self performSelector:@selector(performMethod) withObject:nil afterDelay:1];
}

//获取缩略图
- (void)displayThum{
    
    NSString *input = [self getDocumentsPath];
    input = [input stringByAppendingPathComponent:@"musicMux.mp4"];
    NSString *dest = [self getJpgDocumentsPath];
    NSString *destPath = [dest stringByAppendingPathComponent:@"%d.jpg"];
    //获取缩略图
    [self.yfSession MediaGetThumnailOutPutFile:destPath AndInputFile:input interval:1 taskId:10];
}

- (void)updateViewConstraints{
    __weak typeof(self)weakSelf = self;
    
    [self.exit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.splitVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.sure mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.bottom.equalTo(weakSelf.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [super updateViewConstraints];
}

//退出
- (void)didClickExitBtn:(UIButton *)sender{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performMethod) object:nil];
    
    [self.mediaPlayer shutdown];
    self.mediaPlayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//裁剪
- (void)didClickSplitBtn:(UIButton *)sender{
    
    [self.mediaPlayer pause];
    [self splitVideo];
}

- (void)getsplitVideo:(NSNotification *)noti{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performMethod) object:nil];
        
        YFEditViewController *edit = [[YFEditViewController alloc] init];
        edit.yfSession = self.yfSession;
        edit.pictureCount = self.pictureCount;
        [self.mediaPlayer shutdown];
        self.mediaPlayer = nil;
        [self.navigationController pushViewController:edit animated:YES];
    });
}

//裁剪视频
- (void)splitVideo{
    
    NSString *path = [self getDocumentsPath];
    //裁剪
    NSString * input = [path stringByAppendingString:@"/musicMux.mp4"];
    
    [self.yfSession MediaSplitOutPutFile:[path stringByAppendingPathComponent:@"splitVideo.mp4"] AndInputFile:input startTime:self.leftValue endTime:self.rightValue taskId:40];
}

- (void)playAndStop:(UIButton *)sender{
    if ([self.mediaPlayer isPlaying]) {
        
        [self.mediaPlayer pause];
        self.playBtn.hidden = NO;
        
    }else{
        [self.mediaPlayer play];
        self.playBtn.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.mediaPlayer isPlaying]) {
        
        [self.mediaPlayer pause];
        self.playBtn.hidden = NO;
        
    }else{
        [self.mediaPlayer play];
        self.playBtn.hidden = YES;
    }
}

//获取document路径
- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
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

- (YfFFMoviePlayerController *)mediaPlayer{
    if (!_mediaPlayer) {
        NSString *path = [self getDocumentsPath];
        path = [path stringByAppendingPathComponent:@"musicMux.mp4"];
        NSURL *url = [NSURL URLWithString:path];
        
        _mediaPlayer = [[YfFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0 display:YES isOpenSoundTouch:YES];
        [_mediaPlayer prepareToPlay];
        _mediaPlayer.delegate = self;
        _mediaPlayer.shouldAutoplay = NO;
    }
    return _mediaPlayer;
}

- (UIButton *)exit{
    if (!_exit) {
        _exit = [[UIButton alloc] init];
        [_exit setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
        [_exit setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateHighlighted];
        [_exit addTarget:self action:@selector(didClickExitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exit];
    }
    return _exit;
}

- (UIButton *)sure{
    if (!_sure) {
        _sure = [[UIButton alloc] init];
        
        [_sure setBackgroundImage:[UIImage imageNamed:@"ok1"] forState:UIControlStateNormal];
        [_sure setBackgroundImage:[UIImage imageNamed:@"ok2"] forState:UIControlStateHighlighted];
        [_sure addTarget:self action:@selector(didClickSplitBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_sure];
    }
    return _sure;
}

- (YFSplitVideoView *)splitVideoView{
    if (!_splitVideoView) {
        _splitVideoView = [[YFSplitVideoView alloc] init];
        _splitVideoView.backgroundColor = [UIColor grayColor];
        _splitVideoView.alpha = 0.8;
        [self.view addSubview:_splitVideoView];
    }
    return _splitVideoView;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _playBtn.hidden = YES;
        [_playBtn addTarget:self action:@selector(playAndStop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_playBtn];
    }
    return _playBtn;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetThumbnailSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"splitVideoSucess" object:nil];
    NSLog(@"%s", __FUNCTION__);
    
}

@end
