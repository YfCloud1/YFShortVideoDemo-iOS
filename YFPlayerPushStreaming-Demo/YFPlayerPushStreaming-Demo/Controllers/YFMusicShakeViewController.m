//
//  YFMusicShakeViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 5/16/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFMusicShakeViewController.h"
#import <YFMediaPlayerPushStreaming/YFMediaPlayerPushStreaming.h>
#import "Masonry.h"
#import "YFProgressView.h"
#import "YFButton.h"
#import "YFBeautyView.h"
#import "YFARView.h"
#import "NSObject+Time.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <AVFoundation/AVFoundation.h>
#import <YfMediaPlayer/YfMediaPlayer.h>
#import "YFSplitViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YFSplitMusicView.h"
#import "YFDrawButton.h"
#import "YFRecordSettingView.h"
#import "YFInsFilterView.h"
static int Time = 15;
#define BOX_BOUNDS CGRectMake(0.0f, 0.0f, 150, 150.0f)
static const NSString *THCameraAdjustingExposureContext;
@interface YFMusicShakeViewController ()<YfSessionDelegate,YfFFMoviePlayerControllerDelegate>

@property (nonatomic, strong) UIButton *exitShake;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) YFProgressView *progressView;

//Func
@property(nonatomic,strong) YfSession *yfSession;
@property(nonatomic,assign) YfSessionState rtmpSessionState;
@property (nonatomic,strong) CTCallCenter *callCenter;
@property (nonatomic, strong) NSMutableArray *registeredNotifications;
@property (nonatomic, strong) NSMutableArray *pathData;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat index;
@property (nonatomic, strong) YFDrawButton *play;
@property (nonatomic, strong) UIView *selectView;
//保存路径名
@property (nonatomic, strong) NSString *saveName;

@property (nonatomic, strong) YfFFMoviePlayerController *mediaPlayer;
@property (nonatomic, assign) CGFloat drawRate;
@property (nonatomic, strong) NSMutableArray *layerArr;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) CGFloat screenWidth;

//裁剪UI视图
@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UIView *showView;
//展示的大图
@property (nonatomic, strong) UIImageView *showImgView1;
@property (nonatomic, strong) UIImageView *showImgView2;

//裁剪左值
@property (nonatomic, assign) int leftValue;
//裁剪右值
@property (nonatomic, assign) int rightValue;

//seek UI
@property (nonatomic, assign) float seekIndex;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) NSMutableArray *recordTimeArr;

@property (nonatomic, assign) int saveInterval;

@property (nonatomic, strong) NSMutableArray *thumPathArr;

@property (nonatomic, strong) UILabel *clickLeft;
@property (nonatomic, strong) UILabel *clickRight;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, strong) NSMutableArray *seekArr;

@property (nonatomic, strong) UILabel *sucessLabel;

@property (nonatomic, assign) BOOL  isLoadSuccess;

@property (nonatomic, assign) CGFloat savePts;

@property (nonatomic, assign) int pauseInterval;

@property (nonatomic, strong) UIButton *testBtn;

@property (nonatomic, strong) NSMutableArray *ptsArray;

@property (nonatomic, assign) int pictureCount;

//faceU接口
@property (nonatomic, strong) YFARView *arView;

@property (nonatomic, strong) YFInsFilterView *filterView;

@property (nonatomic, strong) NSArray *bundleArr;

@property (nonatomic, assign) CGFloat  firstAudioPts;

@property (nonatomic, strong) UIButton *switchCamera;

@property (nonatomic, strong) UIButton*splitBtn;

@property (nonatomic, strong) YFSplitMusicView *splitMusic;

@property (strong, nonatomic) UIView *focusBox;

@property (nonatomic, assign) CGFloat recordPlayTime;

@property (nonatomic, strong) UIButton *insBtn;

@property (nonatomic, strong) UIButton *arBtn;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (strong, nonatomic) UIView *exposureBox;
@end

@implementation YFMusicShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //直屏
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isVertical"];
    [self setUpSubView];
    [self setParameter];
    
    self.yfSession.delegate = self;
}

- (void)setParameter{
    self.drawRate = 1.0;
    self.isFirst = YES;
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.registeredNotifications = [[NSMutableArray alloc] init];
    [self registerApplicationObservers];
    _focusBox = [self viewWithColor:[UIColor colorWithRed:0.102 green:0.636 blue:1.000 alpha:1.000]];
    [self.view addSubview:_focusBox];
    _exposureBox = [self viewWithColor:[UIColor colorWithRed:1.000 green:0.421 blue:0.054 alpha:1.000]];
    [self.view addSubview:_exposureBox];
    [self detectCall];
    
    [self.mediaPlayer prepareToPlay];
//    _doubleTapRecognizer =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    _doubleTapRecognizer.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:_doubleTapRecognizer];
    
//    UIPinchGestureRecognizer *ping = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
//    [self.view addGestureRecognizer:ping];
}

//- (void)zoom:(UIPinchGestureRecognizer *)ping{
//    if (self.yfSession) {
//        [self.yfSession.videoCamera SetVideoZoom:ping.scale];
//    }
//}

- (void)detectCall{
    
    __weak typeof(self)weakSelf = self;
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall *call){
        
        if (call.callState == CTCallStateDisconnected) {
            NSLog(@"挂掉电话了");
            if (weakSelf.yfSession) {
                //显示保存动画
//                [weakSelf popSaveView];
            }
        }else if (call.callState == CTCallStateConnected){
            NSLog(@"接电话了");
        }else if (call.callState == CTCallStateIncoming){
            NSLog(@"来电话了");
            if (weakSelf.yfSession) {
                [weakSelf.yfSession endRtmpSession];
            }
        }
        else if (call.callState == CTCallStateDialing){
            
            NSLog(@"call is dialling");
        }
    };
}

- (UIView *)viewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:BOX_BOUNDS];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 5.0f;
    view.hidden = YES;
    return view;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    [self runBoxAnimationOnView:self.exposureBox point:point];
    
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.view.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    [self exposeAtPoint:pointOfInterest];
}

- (void)exposeAtPoint:(CGPoint)point {
    /*
    AVCaptureDevice *device = self.yfSession.metalCamera.inputCamera;
    
    AVCaptureExposureMode exposureMode =
    AVCaptureExposureModeContinuousAutoExposure;
    
    if (device.isExposurePointOfInterestSupported &&                        // 2
        [device isExposureModeSupported:exposureMode]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {                         // 3
            
            device.exposurePointOfInterest = point;
            device.exposureMode = exposureMode;
            
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self                                    // 4
                         forKeyPath:@"adjustingExposure"
                            options:NSKeyValueObservingOptionNew
                            context:&THCameraAdjustingExposureContext];
            }
            
            [device unlockForConfiguration];
        } else {
            
        }
    }*/
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    /*
    if (context == &THCameraAdjustingExposureContext) {                     // 5
        
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        
        if (!device.isAdjustingExposure &&                                  // 6
            [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            
            [object removeObserver:self                                     // 7
                        forKeyPath:@"adjustingExposure"
                           context:&THCameraAdjustingExposureContext];
            
            dispatch_async(dispatch_get_main_queue(), ^{                    // 8
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                } else {
                    
                }
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }*/
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)applicationDidBecomeActive{}

- (void)applicationWillResignActive{}

- (void)applicationWillEnterForeground
{
    if ([self isCurrentViewControllerVisible:self]) {
        
        [self.yfSession.metalCamera resumeCamera];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)applicationDidEnterBackground{
    
    if (![self isCurrentViewControllerVisible:self]) {
        return;
    }
    
    if (!self.play.selected) {
        [self.yfSession.metalCamera pauseCamera];
        return;
    }
    
    if (self.yfSession) {
        
        self.play.selected = NO;
        //添加精准seek数值（即播放器暂停时的精准位置）
        double audioPts =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"aduioPTSCallBack"] doubleValue];
        NSLog(@"audioPts=%f",audioPts);
        [self.seekArr addObject:@(audioPts)];
        
        //保存该段录制的秒数
        [self.ptsArray addObject:@(self.yfSession.currentDts)];
        //self.savePts += self.yfSession.currentDts;
        
        [self removeDispalyLink];
        //    [self.mediaPlayer setMuted:YES];
        [self.mediaPlayer pause];
        [self.yfSession pauseRecord];
        
        //保存暂停时的秒数和当时的速率(添加缩略图时使用)
        [self.recordTimeArr addObject:@[@((int)self.index),@(self.drawRate)]];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        //添加进数组
        [self.pathData addObject:@(self.index*(width/Time))];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addLayerDisplay:self.index*(width/Time)];
            self.sucessLabel.text = @"暂停录制";
        });
    }
    [self.yfSession.metalCamera pauseCamera];
}

- (void)applicationWillTerminate{}

- (void)sliderChange:(UISlider *)slider{
    self.progressView.progress = slider.value;
}

- (void)unregisterApplicationObservers
{
    for (NSString *name in self.registeredNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }

}
//判断view是否正在显示
-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

- (void)exitMusicShake:(UIButton *)sender{
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    [self.mediaPlayer shutdown];
    self.mediaPlayer = nil;
    
    [self.yfSession.metalCamera removeLogo];
    
//    [self.yfSession endRecord];
    
    [self.yfSession releaseRtmpSession];
    
    [self removeJpg];
    [self removeMovie];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeMovie{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [self getDocumentsPath];
   
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename = nil;
    while ((filename = [enumerator nextObject])) {
        if ([[filename pathExtension] isEqualToString:@"mp4"]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
        }
    }
}

- (void)removeJpg{
    //移除jpg文件夹所有图片
    NSString *path = [self getJpgDocumentsPath];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
    }
}

//隐藏所有子控件
- (void)hiddenAllSubView{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.exitShake.hidden = YES;
        self.switchCamera.hidden = YES;
        self.selectView.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.saveBtn.hidden = YES;
    });
}

//显示所有子控件
- (void)displayAllSubView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.exitShake.hidden = NO;
        self.switchCamera.hidden = NO;
        self.selectView.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.saveBtn.hidden = NO;
    });
    
}

- (void)connectionStatusChanged:(YfSessionState) state{
    switch(state) {
        case YfSessionStateNone: {
            _rtmpSessionState = YfSessionStateNone;
            NSLog(@"YfSessionStateNone");
        }
            break;
        case YfSessionStatePreviewStarted: {
            _rtmpSessionState = YfSessionStatePreviewStarted;
            
            NSLog(@"初始化完成");
        }
            break;
        case YfSessionStateStarting: {
            _rtmpSessionState = YfSessionStateStarting;
            
            NSLog(@"马上开始...");
        }
            break;
        case YfSessionStateStarted: {
            _rtmpSessionState = YfSessionStateStarted;
            
            self.yfSession.isHeadPhonesPlay = NO;
            NSLog(@"连接成功，录制开始");
            //[self.fileNameArr addObject:@(self.saveIndex)];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sucessLabel.text = @"录制开始";
                
            });
            [self.mediaPlayer play];
            
        }
            break;
        case YfSessionStateEnded: {
            _rtmpSessionState = YfSessionStateEnded;
        }
            break;
            break;
        default:
            break;
    }
}

//播放
- (void)didClickPlay:(UIButton *)sender{
    [self hiddenAllSubView];
    if ((int)self.index == Time) {
        sender.backgroundColor = [UIColor redColor];
        return;
    }
    
    //播放
    if (self.isFirst) {
        self.splitBtn.enabled = NO;
        
        self.isFirst = NO;
        
        NSString *filePath = [self getDocumentsPath];
        filePath = [filePath stringByAppendingPathComponent:@"music.mp4"];
        
        [self getDisplayLink];
        //[self.mediaPlayer setPlayerRate:self.drawRate];
        self.mediaPlayer.playbackRate = self.drawRate;
        //[self.mediaPlayer play];
        if (self.recordPlayTime) {
            self.mediaPlayer.currentPlaybackTime = self.recordPlayTime;
        }
        
        [self.yfSession startRecordWithURL:filePath andStreamKey:@"mp4"];
        
        
    }else{

        if (!self.splitBtn.isEnabled) {
            self.splitBtn.enabled = NO;
        }
        
        if (self.isDelete) {
            self.isDelete = NO;
            if (self.seekArr.count < 1) {
                if (self.recordPlayTime) {
                    self.mediaPlayer.currentPlaybackTime = self.recordPlayTime;
                }else{
                    self.mediaPlayer.currentPlaybackTime = 0;
                }
            }else{
                self.mediaPlayer.currentPlaybackTime = [[self.seekArr lastObject] doubleValue];
            }
        }
        
        [self getDisplayLink];
        NSString *filePath = [self getDocumentsPath];
        filePath = [filePath stringByAppendingPathComponent:self.saveName];
//        [self.mediaPlayer setPlayerRate:self.drawRate];
        self.mediaPlayer.playbackRate = self.drawRate;
        //[self.mediaPlayer play];
        //[self.mediaPlayer setMuted:NO];
        [self.yfSession resumeRecord];
    }
}

//暂停
- (void)didClickStop:(UIButton *)sender{
    
    [self displayAllSubView];
    
    if ((int)self.index == Time) {
        sender.backgroundColor = [UIColor clearColor];
        return;
    }
    
    //暂停
    //添加精准seek数值（即播放器暂停时的精准位置）
    double audioPts =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"aduioPTSCallBack"] doubleValue];
    [self.seekArr addObject:@(audioPts)];
    
    //保存该段录制的秒数
    [self.ptsArray addObject:@(self.yfSession.currentDts)];
    //self.savePts += self.yfSession.currentDts;
    
    [self removeDispalyLink];
    //    [self.mediaPlayer setMuted:YES];
    [self.mediaPlayer pause];
    [self.yfSession pauseRecord];
    
    //保存暂停时的秒数和当时的速率(添加缩略图时使用)
    [self.recordTimeArr addObject:@[@((int)self.index),@(self.drawRate)]];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //添加进数组
    [self.pathData addObject:@(self.index*(width/Time))];
    [self addLayerDisplay:self.index*(width/Time)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sucessLabel.text = @"暂停录制";
    });
    
}

//定时器方法
- (void)musicDisplay{
    
    //秒数
    self.index = self.yfSession.currentDts;
    //NSLog(@"=====>>>>>>>>%f",self.yfSession.currentDts);
    self.progressView.progress = self.index*(self.screenWidth/(float)Time);
    
    if (self.index >= Time) {
        NSLog(@"@@@@@@@%f",self.index);
        self.play.selected = NO;
        //添加精准seek数值（即播放器暂停时的精准位置）
        double audioPts =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"aduioPTSCallBack"] doubleValue];
        [self.seekArr addObject:@(audioPts)];
        
        //保存该段录制的秒数
        [self.ptsArray addObject:@(self.yfSession.currentDts)];
        //self.savePts += self.yfSession.currentDts;
        
        [self removeDispalyLink];
        //    [self.mediaPlayer setMuted:YES];
        [self.mediaPlayer pause];
        [self.yfSession pauseRecord];
        
        //保存暂停时的秒数和当时的速率(添加缩略图时使用)
        [self.recordTimeArr addObject:@[@((int)self.index),@(self.drawRate)]];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        //添加进数组
        [self.pathData addObject:@(self.index*(width/Time))];
        [self addLayerDisplay:self.index*(width/Time)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sucessLabel.text = @"暂停录制";
        });
   
    }
}

- (void)getDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(musicDisplay)];
//    self.displayLink.preferredFramesPerSecond = 10.0;
//    self.displayLink.frameInterval = 0.1;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)removeDispalyLink{
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)playerStatusCallBackLoading:(YfFFMoviePlayerController *)player{
    NSLog(@"加载中");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rightLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",(int)self.mediaPlayer.duration/60,(int)self.mediaPlayer.duration%60];
    });
}

//- (void)playerStatusCallBackLoadingSuccess:(YfFFMoviePlayerController *)player{
//    NSLog(@"加载成功");
//    
//    if(self.seekIndex > 1){
//        if (!self.isLoadSuccess) {
//            self.isLoadSuccess = YES;
//            
//        }
//    }
//}

//失败回调
- (void)failCallBack{
    [self popMessageView:@"操作失败"];
}

//添加一个layer
- (void)addLayerDisplay:(CGFloat)index{
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(index, 0, 2, 10);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.progressView.layer addSublayer:layer];
    [self.layerArr addObject:layer];
}

//删除
- (void)deleteObject:(UIButton *)sender{
    
    if (self.play.selected) {
        return;
    }
    
    if (self.index == 0) {
        self.splitBtn.enabled = YES;
        [self popMessageView:@"没了,别删了"];
        return;
    }
    
    self.isDelete = YES;
    
    double value = [[self.ptsArray lastObject] doubleValue];
    //self.savePts -= value;
    if (value == 0) {
        //self.savePts = 0;
    }
    
    
    [self.ptsArray removeLastObject];
    
    [self.seekArr removeLastObject];
   
    //UI
    [self.pathData removeLastObject];
    CGFloat progress = [[self.pathData lastObject] floatValue];
    self.progressView.progress = progress;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.index = progress/(width/Time);
    
    [(CALayer *)[self.layerArr lastObject] removeFromSuperlayer];
    [self.layerArr removeLastObject];
    
    //删除视频
    [self.yfSession deleteLastMediaObject];
}

//时光倒流
- (void)reverseVideo{
    //[self popMessageView:@"时光倒流成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reverseVideoSucess" object:nil];
//    NSString *path = [self getDocumentsPath];
//    path = [path stringByAppendingPathComponent:@"/reverse.mp4"];
//    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(splitVideo:didFinishSavingWithError:contextInfo:), nil);
}

//添加缩略图(该段弃用，仅供参考)
- (void)addThumbnail{
    NSString *path = [self getJpgDocumentsPath];
    self.clickLeft.hidden = NO;
    self.clickRight.hidden = NO;
    //录制时长
    int recordSecond = (int)self.index;
    
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width/recordSecond;
    CGFloat height = viewW * 16/9;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //暂停次数
        int pauseCount = (int)self.recordTimeArr.count;
        
        for (int i = 0; i < pauseCount; ++i) {
            
            NSArray *arr = (NSArray *)self.recordTimeArr[i];
            
            int temp = 0;
            if (i == 0) {
                temp = 0;
            }else{
                NSArray *tempArr = (NSArray *)self.recordTimeArr[i-1];
                temp = [tempArr[0] intValue];
            }
            float drawRate = 1/[arr[1] floatValue];
            int tempNum = 0;
            for (int j = temp; j < [arr[0] intValue]; ++j) {
                NSString *path2 = nil;
                if (drawRate > 1) {
                    //慢播快录
                    tempNum += 1;
                    if(j == 0){
                        path2 = [NSString stringWithFormat:@"%@/%d.jpg",path,1];
                    }else{
                        BOOL res = [self checkPictureExist:(int)(j+tempNum * (drawRate-1))];
                        if(!res){
                            continue ;
                        }
                        path2 = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(j+tempNum * (drawRate-1))];
                    }
                }else if(drawRate == 1){
                    //正常
                    BOOL res = [self checkPictureExist:(int)(j+drawRate)];
                    if(!res){
                        continue ;
                    }
                    path2 = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(j+drawRate)];
                }else{
                    //快播慢录
//                    float temp2 = [arr[1] floatValue];
                    if (j == 0) {
                        path2 = [NSString stringWithFormat:@"%@/%d.jpg",path,1];
                    }else{
                        BOOL res = [self checkPictureExist:j];
                        if(!res){
                            continue ;
                        }
                        path2 = [NSString stringWithFormat:@"%@/%d.jpg",path,j];
                    }
                }
                
                YFButton *btn = [[YFButton alloc] init];
                UIImage *img = [UIImage imageWithContentsOfFile:path2];
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didClickThumBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                btn.tag = j+1;
                [self.thumPathArr addObject:@[@(btn.tag),path2]];
                
                btn.frame = CGRectMake(j*viewW, 0, viewW, height);
                [self.displayView addSubview:btn];
            }
        }
    });
}

//检查图片是否存在
- (BOOL)checkPictureExist:(int)pictureId{
    if (pictureId <= self.pictureCount) {
        return YES;
    }
    return NO;
}

//裁剪成功通知回调
- (void)splitSuccess{
    
    //相册权限
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied)
    {
        // 无权限
        // do something...
        [self popMessageView:@"请开启相册权限"];
    }
    NSString *path = [self getDocumentsPath];
    path = [path stringByAppendingPathComponent:@"splitVideo.mp4"];
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(splitVideo:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)muxSuccess{
    NSString *path = [self getDocumentsPath];
    path = [path stringByAppendingPathComponent:@"musicMux.mp4"];
    //UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(mux:didFinishSavingWithError:contextInfo:), nil);
}

//回调
- (void)splitVideo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存到相册成功");
    }
}

- (void)changeCodeVideo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"转码保存到相册成功");
    }
}

- (void)mux:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"音视频到相册成功");
    }
}

- (void)didClickThumBtn:(YFButton *)sender{
    
    __block NSString *str = [self getJpgDocumentsPath];
    
    [self.thumPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[0] intValue] == sender.tag) {
            str = (NSString *)obj[1];
            * stop = YES;
        }
    }];
    
    //录制时长
    int recordSecond = (int)self.index;
    
    if (sender.tag <= recordSecond/2) {
        self.leftValue = (int)sender.tag-1;
        self.clickLeft.text = [NSString stringWithFormat:@"%lds",(long)sender.tag-1];
        self.showImgView1.image = [UIImage imageWithContentsOfFile:str];

    }else{
        self.rightValue = (int)sender.tag;
        self.clickRight.text = [NSString stringWithFormat:@"%lds",(long)sender.tag];
        self.showImgView2.image = [UIImage imageWithContentsOfFile:str];

    }
}

//保存
//合成视频
- (void)saveVideo:(UIButton *)sender{
    
    
    if (self.play.selected) {
        return;
    }
    
    if (self.index < 5) {
        [self popMessageView:@"录制太短了,继续录制"];
        return;
    }
    
    //合成视频
    [self.yfSession MediaConcatTaskId:20];
    sender.userInteractionEnabled = NO;
    //UI
    self.displayView.hidden = NO;
    self.showView.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self runBoxAnimationOnView:self.focusBox point:point];
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.view.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    AVCaptureDevice *device = self.yfSession.videoCamera.inputCamera;
    if (device.isFocusPointOfInterestSupported &&                           // 3
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {                         // 4
            device.focusPointOfInterest = pointOfInterest;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        } else {
            
            NSLog(@"不支持对焦");
        }
    }*/
}

- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
                     }
                     completion:^(BOOL complete) {
                         double delayInSeconds = 0.5f;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             view.hidden = YES;
                             view.transform = CGAffineTransformIdentity;
                         });
                     }];
}


- (void)didClickReversal:(UIButton *)sender{
    
}

//保存视频回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        [self popMessageView:@"保存到相册成功"];
    }
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

//弹窗
- (void)popMessageView:(NSString *)meg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:meg preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    // Add the actions.
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//获取document路径
- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

//调节声音速度
- (void)didClickLever:(UIButton *)sender{
    
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectBtn = sender;
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (sender.tag == 0) {
        self.drawRate = 2.0;
    }else if (sender.tag == 1){
        self.drawRate = 1.86;
    }else if (sender.tag == 2){
        self.drawRate = 1;
    }else if (sender.tag == 3){
        self.drawRate = 0.5;
    }else if (sender.tag == 4){
        self.drawRate = 0.33;
    }
}

- (void)senderOutAudioData:(NSData*)audioData size:(size_t)audioDataSize player:(YfFFMoviePlayerController *)player{
    
    float rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"playerRate"];
    //接收音频数据（其实yfsession需要的只是播放速率，并没有使用这里的音频数据，后期可指定某段音频与视频合成）
    if (_yfSession) {
        [_yfSession recevieAudioData:audioData size:audioDataSize rate:rate];
    }
}

- (void)registerApplicationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self.registeredNotifications addObject:UIApplicationWillEnterForegroundNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [self.registeredNotifications addObject:UIApplicationDidBecomeActiveNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [self.registeredNotifications addObject:UIApplicationWillResignActiveNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [self.registeredNotifications addObject:UIApplicationDidEnterBackgroundNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [self.registeredNotifications addObject:UIApplicationWillTerminateNotification];
}

//布局
- (void)setUpSubView{
    __weak typeof(self)weakSelf = self;
    [self.exitShake mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(20);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.play);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.play);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(10);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.play.mas_top).offset(-35);
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/Time;
    CGFloat height = width * 16/9;
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(220);
        make.height.mas_equalTo(180);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.bottom.equalTo(weakSelf.view).offset(-185);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.bottom.equalTo(weakSelf.view).offset(-185);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.clickLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(130);
        make.bottom.equalTo(weakSelf.showView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.clickRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-130);
        make.bottom.equalTo(weakSelf.showView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.sucessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.bottom.equalTo(weakSelf.leftLabel.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.bottom.equalTo(weakSelf.sucessLabel.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.arView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.switchCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(145);
        make.size.mas_equalTo(CGSizeMake(36, 35));
    }];
    
    [self.splitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(200);
        make.size.mas_equalTo(CGSizeMake(36, 35));
    }];
    
    [self.insBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(255);
        make.size.mas_equalTo(CGSizeMake(36, 35));
    }];
    
    [self.arBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(310);
        make.size.mas_equalTo(CGSizeMake(36, 35));
    }];
    
    [self.splitMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(180);
    }];
    
}

//裁剪音乐
- (void)splitMusic:(UIButton *)sender{
    
    if (sender.selected) {
        sender.selected = NO;
        self.splitMusic.hidden = YES;
    }else{
        sender.selected = YES;
        self.splitMusic.hidden = NO;
    }
    
}

- (void)switchCameraState:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        self.yfSession.cameraState = YfCameraStateFront;
//        self.yfSession.beautyType = YfSessionCameraBeautifulFilterLocalSkinBeauty;
//        [self.yfSession.videoCamera adjustRuddiness:0.125];
//        [self.yfSession.videoCamera adjustBlurness:3.65];
    }else{
        sender.selected = YES;
        self.yfSession.cameraState = YfCameraStateBack;
//        self.yfSession.beautyType = YfSessionCameraBeautifulFilterGlobalBeauty;
//        [self.yfSession.videoCamera setRouGuangLevel:0];
//        [self.yfSession.videoCamera setBlurLevel:0.95];
//        [self.yfSession.videoCamera setSharpnessLevel:0.25];
    }
}

//聚焦
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    if (self.yfSession) {
//        UITouch *touch = [touches anyObject];
//        CGPoint point = [touch locationInView:self.view];
//        
//        CGPoint pointOfInterest = CGPointZero;
//        CGSize frameSize = self.view.bounds.size;
//        pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
//        
//        [self.yfSession focusAtPoint:pointOfInterest];
//    }
}

- (void)didClickInsBtn:(UIButton *)sender{
    
    self.filterView.hidden = NO;
    if (!self.arView.hidden) {
        self.arView.hidden = YES;
    }
}

- (void)didClickArBtn:(UIButton *)sender{
    self.arView.hidden = NO;
    if (!self.filterView.hidden) {
        self.filterView.hidden = YES;
    }
}

- (void)dealloc{

    [self.displayLink invalidate];
    
    [self unregisterApplicationObservers];
    
    [self.yfSession.previewView removeFromSuperview];
    [self.yfSession endRtmpSession];
    self.yfSession = nil;
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark  ---  懒加载

- (UIButton *)exitShake{
    if (!_exitShake) {
        _exitShake = [[UIButton alloc] init];
        [_exitShake setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
        [_exitShake setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateHighlighted];
        [_exitShake addTarget:self action:@selector(exitMusicShake:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitShake];
    }
    return _exitShake;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete1"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateHighlighted];
        
        [_deleteBtn addTarget:self action:@selector(deleteObject:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"next1"] forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"next2"] forState:UIControlStateHighlighted];
        
        [_saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_saveBtn addTarget:self action:@selector(saveVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveBtn];
    }
    return _saveBtn;
}

- (UIButton *)insBtn{
    if (!_insBtn) {
        _insBtn = [[UIButton alloc] init];
        [_insBtn setBackgroundImage:[UIImage imageNamed:@"insFilter1"] forState:UIControlStateNormal];
        [_insBtn setBackgroundImage:[UIImage imageNamed:@"insFilter2"] forState:UIControlStateHighlighted];
        [_insBtn addTarget:self action:@selector(didClickInsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_insBtn];
    }
    return _insBtn;
}

- (UIButton *)arBtn{
    if (!_arBtn) {
        _arBtn = [[UIButton alloc] init];
        [_arBtn setBackgroundImage:[UIImage imageNamed:@"ar1"] forState:UIControlStateNormal];
        [_arBtn setBackgroundImage:[UIImage imageNamed:@"ar2"] forState:UIControlStateHighlighted];
        [_arBtn addTarget:self action:@selector(didClickArBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_arBtn];
    }
    return _arBtn;
}

- (YFProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[YFProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (NSMutableArray *)pathData{
    if (!_pathData) {
        _pathData = [NSMutableArray array];
    }
    return _pathData;
}

- (UIButton *)play{
    if (!_play) {
        _play = [[YFDrawButton alloc] init];
//        [_play setTitle:@"长按" forState:UIControlStateNormal];
        [_play setBackgroundImage:[UIImage imageNamed:@"startRecord"] forState:UIControlStateNormal];
        [_play setBackgroundImage:[UIImage imageNamed:@"startRecord2"] forState:UIControlStateHighlighted];
        
        [_play addTarget:self action:@selector(didClickPlay:) forControlEvents:UIControlEventTouchDown];
        [_play addTarget:self action:@selector(didClickStop:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpInside];
        
        [self.view addSubview:_play];
    }
    return _play;
}

- (YfFFMoviePlayerController *)mediaPlayer{
    if (!_mediaPlayer) {

        NSURL *url = [[NSBundle mainBundle] URLForResource:self.musicName withExtension:nil];
        
        _mediaPlayer = [[YfFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0 display:NO isOpenSoundTouch:YES];
        _mediaPlayer.delegate = self;
        _mediaPlayer.shouldAutoplay = NO;
    }
    return _mediaPlayer;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //生成5个按钮
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat viewW = 50;
        CGFloat margin = ((size.width-40) - 5*viewW)/6;
//        CGFloat lever = 0.5;
        for (int i = 0; i < 5; ++i) {
            UIButton *btn = [[UIButton alloc] init];
            if (i == 2) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.selectBtn = btn;
            }else{
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [btn.layer setCornerRadius:5.0];
            [btn.layer setMasksToBounds:YES];
            btn.frame = CGRectMake(margin+i*(margin+viewW), 0, viewW, 30);
            if (i == 0) {
                [btn setTitle:@"极慢" forState:UIControlStateNormal];
            }else if (i == 1){
                [btn setTitle:@"慢" forState:UIControlStateNormal];
            }else if(i == 2){
                [btn setTitle:@"正常" forState:UIControlStateNormal];
            }else if (i == 3){
                [btn setTitle:@"快" forState:UIControlStateNormal];
            }else if (i == 4){
                [btn setTitle:@"极快" forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(didClickLever:) forControlEvents:UIControlEventTouchUpInside];
//            lever += 0.5;
            _selectView.layer.cornerRadius = 15;
            _selectView.layer.masksToBounds = YES;
            [_selectView addSubview:btn];
        }
        [self.view addSubview:_selectView];
    }
    return _selectView;
}

- (NSMutableArray *)layerArr{
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}


- (UIView *)displayView{
    if (!_displayView) {
        _displayView = [[UIView alloc] init];
        [self.view addSubview:_displayView];
    }
    
    return _displayView;
}

- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] init];
        [_showView addSubview:self.showImgView1];
        [_showView addSubview:self.showImgView2];
        [self.view insertSubview:_showView atIndex:0];
    }
    return _showView;
}

- (UIImageView *)showImgView1{
    if (!_showImgView1) {
        _showImgView1 = [[UIImageView alloc] init];
        _showImgView1.frame = CGRectMake(0, 0, 120, 120*16/9);
    }
    return _showImgView1;
}

- (UIImageView *)showImgView2{
    if (!_showImgView2) {
        _showImgView2 = [[UIImageView alloc] init];
        _showImgView2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, 120, 120*16/9);
    }
    return _showImgView2;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"00:00";
//        _leftLabel.hidden = YES;
        [self.splitMusic addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"00:00";
//        _rightLabel.hidden = YES;
        [self.splitMusic addSubview:_rightLabel];
    }
    return _rightLabel;
}

- (NSMutableArray *)recordTimeArr{
    if (!_recordTimeArr) {
        _recordTimeArr = [NSMutableArray array];
    }
    return _recordTimeArr;
}

- (NSMutableArray *)thumPathArr{
    if (!_thumPathArr) {
        _thumPathArr = [NSMutableArray array];
    }
    return _thumPathArr;
}

- (UILabel *)clickLeft{
    if (!_clickLeft) {
        _clickLeft = [[UILabel alloc] init];
        _clickLeft.text = @"0s";
        _clickLeft.hidden = YES;
        [self.view addSubview:_clickLeft];
    }
    return _clickLeft;
}

- (UILabel *)clickRight{
    if (!_clickRight) {
        _clickRight = [[UILabel alloc] init];
        _clickRight.textAlignment = NSTextAlignmentRight;
        _clickRight.text = @"0s";
        _clickRight.hidden = YES;
        [self.view addSubview:_clickRight];
    }
    return _clickRight;
}

- (YFSplitMusicView *)splitMusic{
    if (!_splitMusic) {
        _splitMusic = [[YFSplitMusicView alloc] init];
        _splitMusic.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        __weak typeof(self)weakSelf = self;
        _splitMusic.scrollViewCallback = ^(CGFloat offsetX){
            
            weakSelf.recordPlayTime = (int)(offsetX*weakSelf.mediaPlayer.duration/width)/2;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.leftLabel.text = [NSString stringWithFormat:@"00:%.2d",(int)(offsetX*weakSelf.mediaPlayer.duration/width)/2];
            });
        };
        _splitMusic.hidden = YES;
        [self.view addSubview:_splitMusic];
    }
    return _splitMusic;
}

- (NSMutableArray *)seekArr{
    if (!_seekArr) {
        _seekArr = [NSMutableArray array];
    }
    return _seekArr;
}

- (UILabel *)sucessLabel{
    if (!_sucessLabel) {
        _sucessLabel = [[UILabel alloc] init];
        _sucessLabel.text = @"等待录制";
        _sucessLabel.hidden = YES;
        _sucessLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_sucessLabel];
    }
    return _sucessLabel;
}

- (UIButton *)testBtn{
    if (!_testBtn) {
        _testBtn = [[UIButton alloc] init];
        [_testBtn setTitle:@"TEST" forState:UIControlStateNormal];
        _testBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _testBtn.hidden = YES;
        [_testBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_testBtn addTarget:self action:@selector(didClickReversal:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testBtn];
    }
    return _testBtn;
}

- (NSMutableArray *)ptsArray{
    if (!_ptsArray) {
        _ptsArray = [NSMutableArray array];
    }
    return _ptsArray;
}

- (NSArray *)bundleArr{
    if (!_bundleArr) {
        _bundleArr = @[@"PrincessCrown.bundle",@"BeagleDog.bundle",@"YellowEar.bundle",@"Deer.bundle",@"HappyRabbi.bundle",@"hartshorn.bundle",@"Mood.bundle",];
    }
    return _bundleArr;
}
#warning 滤镜
- (YFInsFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[YFInsFilterView alloc] init];
        __weak typeof(self)weakSelf = self;
        _filterView.cancel = ^{
            weakSelf.filterView.hidden = YES;
        };
        
        _filterView.callBack = ^(int i){
            //切换滤镜
//            [weakSelf.yfSession.metalCamera switchFilter:i];
        };
        
        _filterView.hidden = YES;
        _filterView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

- (YFARView *)arView{
    if (!_arView) {
        __weak typeof(self)weakSelf = self;
        _arView = [[YFARView alloc] init];
        _arView.callBack = ^(int i){
            if ([YfMFaceUSession sharedManager].open == NO) {
                [YfMFaceUSession sharedManager].open = YES;
            }
            //ar动画回调
            if (i == 0) {
                //标识没有ar动画
                [YfMFaceUSession sharedManager].isOnlyBeauty = YES;
            }else{
                //加载ar动画
                [YfMFaceUSession sharedManager].isOnlyBeauty = NO;
                NSString *path = [[NSBundle mainBundle] pathForResource:weakSelf.bundleArr[i-1] ofType:nil];
                [[YfMFaceUSession sharedManager] reLoadItem:path];
            }
        };
        _arView.cancel = ^(){
            weakSelf.arView.hidden = YES;
        };
        _arView.hidden = YES;
        _arView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_arView];
    }
    return _arView;
}

//裁剪按钮
- (UIButton *)splitBtn{
    if (!_splitBtn) {
        _splitBtn = [[UIButton alloc] init];
        
        [_splitBtn setBackgroundImage:[UIImage imageNamed:@"splitMusic"] forState:UIControlStateNormal];
        [_splitBtn setBackgroundImage:[UIImage imageNamed:@"splitMusic2"] forState:UIControlStateHighlighted];
        
        [_splitBtn addTarget:self action:@selector(splitMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_splitBtn];
    }
    return _splitBtn;
}

- (UIButton *)switchCamera{
    if (!_switchCamera) {
        _switchCamera = [[UIButton alloc] init];
        [_switchCamera setBackgroundImage:[UIImage imageNamed:@"camera1"] forState:UIControlStateNormal];
        [_switchCamera setBackgroundImage:[UIImage imageNamed:@"camera2"] forState:UIControlStateSelected];
        [_switchCamera addTarget:self action:@selector(switchCameraState:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchCamera];
    }
    return _switchCamera;
}

- (YfSession *)yfSession{
    if (!_yfSession) {
        CGSize size = CGSizeMake(540, 960);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"resolution"] intValue]) {
            size = CGSizeMake(360, 640);
        }
        
        _yfSession = [[YfSession alloc] initWithVideoSize:size sessionPreset:AVCaptureSessionPresetiFrame960x540 frameRate:25 bitrate:4000*1000 bufferTime:2 isUseUDP:YfTransportNone isDropFrame:NO YfOutPutImageOrientation:YfOutPutImageOrientationNormal isOnlyAudioPushBuffer:NO audioRecoderError:nil isOpenAdaptBitrate:NO];
        [self.view insertSubview:_yfSession.previewView atIndex:0];
        YfMFaceUSession *manager = [YfMFaceUSession sharedManager];
        
        manager.open = NO;
        manager.heartName = @"heart_iloveu.bundle";
        
        manager.is_facing_tracking = YES;
        
        manager.isOnlyBeauty = YES;
        manager.beautyLever = 0;
        manager.colorLever = 0;
  
//        NSString *file = [[NSBundle mainBundle] pathForResource:@"water" ofType:@"gif"];
//        [_yfSession.videoCamera decodeAndRenderWithFilePath:file];
        
        [_yfSession.metalCamera switchBeautyFilter:YfMCameraBeautifulFilterLocalSkinBeauty];
//        [_yfSession.videoCamera adjustRuddiness:0.0];
//        [_yfSession.videoCamera adjustBlurness:3.65];

        //        [_yfSession.videoCamera setSharpnessLevel:0];
//        [_yfSession.videoCamera setTorch:YES];
//        [_yfSession.videoCamera useSoul:NO];
//        [_yfSession.videoCamera switchMirrorFilter:YYfSessionCameraMirrorFilterRightLeft];
//        [_yfSession.videoCamera setupFilter:YfSessionCameraFilterConcaveMirror];
        
        //瘦脸
//        manager.cheekThinning = 0.3;
        //大眼
//        manager.eyeEnlarging = 0.4;
        __weak typeof(self)weakSelf = self;
        
        //录制操作根据taskId回调
        _yfSession.recordCallBack = ^(int taskId, int result, NSString * outputPath){
            
                if (result == 0) {
                    //result为0表示操作成功
                    if (taskId == 20) {
                        //合成成功
                        NSLog(@"视频合成成功");
                        NSString *path = [weakSelf getDocumentsPath];
                        NSString *videoPath = nil;
                        videoPath = [path stringByAppendingString:@"/music.mp4"];
                        NSString *audioPath = [[NSBundle mainBundle] pathForResource:weakSelf.musicName ofType:nil];
                        
                        if (weakSelf.recordPlayTime == 0) {
                            weakSelf.firstAudioPts = 0;
                        }else{
                            weakSelf.firstAudioPts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstCallBack"] doubleValue];
                        }
                        
                        NSLog(@"firstAudioPts === %f== %f",weakSelf.firstAudioPts,weakSelf.recordPlayTime);
                        [weakSelf.yfSession MeidaAddAudioDataAndVideoFileName:videoPath AndAudioFileName:audioPath AndOutPutName:[path stringByAppendingString:@"/musicMux.mp4"] AndSeekTime:weakSelf.firstAudioPts AndTaskId:11];

                    }
                    
                    if (taskId == 11) {
                        NSLog(@"音视频合成成功");
                        [weakSelf muxSuccess];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
//                            weakSelf.chooseSlider.hidden = NO;
//                            weakSelf.chooseSlider.maxNum = weakSelf.yfSession.currentDts;
//                            [weakSelf popMessageView:@"请点击裁剪按钮剪切视频"];
                            YFSplitViewController *split = [[YFSplitViewController alloc] init];
                            split.yfSession = weakSelf.yfSession;
//                            weakSelf.chooseSlider.hidden = YES;
//                            [weakSelf.yfSession.videoCamera closeAndCleanGif];
                            [weakSelf.yfSession.metalCamera removeLogo];
                            [weakSelf.yfSession.metalCamera pauseCamera];
                            
                            [weakSelf.navigationController pushViewController:split animated:YES];
                            
                            
                        });
                        
                    }
                    
                    if (taskId == 40) {
                        NSLog(@"裁剪成功");
                        [weakSelf splitSuccess];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"splitVideoSucess" object:nil];
                    }
                    
                    if (taskId == 50) {
                        NSLog(@"反复成功");
                        [weakSelf getStartTime];
                        [weakSelf reverseVideo];
                    }
                    
                    if (taskId == 12) {
                        NSLog(@"命令行转码音频成功");
                    }
                    
                    if (taskId == 44) {
                        NSLog(@"命令行转码最终文件成功");
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCodeFinalVideoComplete" object:nil];
                        
                        NSString *path = [weakSelf getDocumentsPath];
                        NSString *changecodeOutput = [path stringByAppendingPathComponent:@"changeCodeFinal.mp4"];
                        UISaveVideoAtPathToSavedPhotosAlbum(changecodeOutput, weakSelf, @selector(changeCodeVideo:didFinishSavingWithError:contextInfo:), nil);
                    }
                    if (taskId == 33) {
                        NSLog(@"合成片尾成功");
                    }
                    
                }else{
                    if (taskId == 20) {
                        //合成失败
                        NSLog(@"合成失败");
                        [weakSelf failCallBack];
                    }
                    
                    if (taskId == 40) {
                        NSLog(@"裁剪失败");
                        [weakSelf failCallBack];
                    }
                    
                    if (taskId == 50) {
                        NSLog(@"时光倒流失败");
                        [weakSelf popMessageView:@"时光倒流失败"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reverseVideoFail" object:nil];
                    }
                    
                    if (taskId == 11) {
                        [weakSelf popMessageView:@"音视频合成失败"];
                    }
                    
                    if (taskId == 44) {
                        NSLog(@"命令行转码最终文件失败");
                    }
                    if (taskId == 33) {
                        NSLog(@"合成片尾失败");
                    }
                    
                }
                if (taskId == 10) {
                    //只有在缩略tuzhong
                    if (result > 0) {
                        //在获取缩略图时，result表示图片张数
                        NSLog(@"获取缩略图成功");
                        weakSelf.pictureCount = result;
//                        [weakSelf addThumbnail];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetThumbnailSuccess" object:@(result)];
                        
                    }
                }
        };
        
        _yfSession.failCallBack = ^(){
            //处理UI
            [weakSelf popMessageView:@"该段录制失败"];
            //保存处理
            [weakSelf.recordTimeArr removeLastObject];
            weakSelf.isDelete = YES;
            
            [weakSelf.seekArr removeLastObject];
            NSLog(@"录制失败");
            //处理视频进度
            [weakSelf.ptsArray removeLastObject];
            
            //处理UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.pathData removeLastObject];
                CGFloat progress = [[weakSelf.pathData lastObject] floatValue];
                weakSelf.progressView.progress = progress;
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                weakSelf.index = progress/(width/Time);
                [(CALayer *)[weakSelf.layerArr lastObject] removeFromSuperlayer];
                [weakSelf.layerArr removeLastObject];
            });
            
        };

        NSString *png = [[NSBundle mainBundle] pathForResource:@"shuiyin5" ofType:@"png"];
//        [_yfSession.metalCamera drawImageTexture:png PointSize:YfSessionCameraLogoPostitionrightUp];
        [_yfSession.metalCamera drawImageTexture:png PointRect:CGRectMake(10, 10, 80, 80)];
    }
    return _yfSession;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.saveBtn.userInteractionEnabled = YES;

//    NSString *file = [[NSBundle mainBundle] pathForResource:@"water" ofType:@"gif"];
//    [self.yfSession.videoCamera decodeAndRenderWithFilePath:file];
    
    [self.yfSession.metalCamera resumeCamera];
//    [self.yfSession.metalCamera switchFilter:YFINSTCamera_NORMAL_FILTER];
}

@end
