//
//  YFEditViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 7/7/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFEditViewController.h"
#import "YFMusicShakeViewController.h"
#import "Masonry.h"
#import <YFMediaPlayer/YFMediaPlayer.h>
#import "YFButton.h"
#import "YFTouchView.h"
#import "YFFunModel.h"
#import "YFMoveView.h"
#import "YFDisplayView.h"
#import "NSObject+Time.h"
#import <YFMediaPlayerPushStreaming/YFMediaPlayerPushStreaming.h>
#import "YFProgressView.h"
#import "YFRange.h"
#import "AFNetworking.h"
#import "YFPaintView.h"
#import "YFCategoryView.h"
#import "MBProgressHUD.h"
#import "YFUploadProcessView.h"
#import <YFMediaPlayerPushStreaming/YfMediaEditor.h>
#import <sys/time.h>
#import "NSObject+Time.h"
#import "YFSpecialFilterView.h"
struct timeval record;

@interface YFEditViewController ()<YfFFMoviePlayerControllerDelegate,YfFileProcessManagerDelegate,YfsessionPreViewDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) UIButton *saveVideoConfig;

@property (nonatomic, strong) UIButton *exitBtn;
//缩略图
@property (nonatomic, strong) UIView *thumView;

@property (nonatomic, strong) YfFFMoviePlayerController *mediaPlayer;

@property (nonatomic, strong) YFDisplayView *displayView;

@property (nonatomic, strong) YFPaintView *paintView;

@property (nonatomic, strong) YFMoveView *animationView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) CADisplayLink *displayLink;
//后期特效
@property (nonatomic, strong) YfFileProcessManager *fileProcess;

//相当于数据处理中心
@property (nonatomic, strong)  YfsessionPreView *editPreview;

//@property (nonatomic, strong) YfFileVideoReverseTool *reverse;
//用户配置
@property (nonatomic, strong) NSMutableArray *operateArr;

@property (nonatomic, assign) CGFloat startRecord;

@property (nonatomic, assign) CGFloat endRecord;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSString *saveTextTure;

//用于记录用户操作
@property (nonatomic, strong) NSMutableArray <YFRange*>*ranges;
//所有的节点
@property (nonatomic, strong) NSArray <NSNumber*>*nodes;

@property (nonatomic, assign) Type funcType;

@property (nonatomic, assign) YFINSTCameraFilterType insType;
@property (nonatomic, assign) YfSessionCameraBeautifulFilter beautyType;
@property (nonatomic, assign) YfSessionCameraFilter specialType;
@property (nonatomic, assign) YfAmazingFilter soulType;

@property (nonatomic, strong) NSString *texTureName;

@property (nonatomic, strong) YfConfigureManager *configManager;

@property (nonatomic, strong) UIButton *ActionConfig;

@property (nonatomic, assign) BOOL isWriting;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSMutableArray *registeredNotifications;

@property (nonatomic, assign) BOOL isNORecycle;

@property (nonatomic, strong) UIButton *uploadBtn;

@property (nonatomic, strong) YFUploadProcessView *uploadProcess;

@property (nonatomic, strong) YFCategoryView *categoryView;

@property (nonatomic, strong) UIView *interverView;

@property (nonatomic, strong) NSString *format;

@property (nonatomic, assign) BOOL isApplyConfig;

@property (nonatomic, assign) BOOL isuploadComplete;

@property (nonatomic, assign) BOOL isTureUpload;

@property (nonatomic, assign) float recordProcess;

@property (nonatomic, strong) UITextField *playtext;

@property (nonatomic, strong) UIButton *startPlay;

@property (nonatomic, assign) int uploadCount;

@property (nonatomic, strong) UIButton *editBtn;
//撤消
@property (nonatomic, strong) UIButton *revoke;

@property (nonatomic, strong) UILabel *editTitle;

@property (nonatomic, strong) YFSpecialFilterView *waterMarkView;
@property (nonatomic, strong) NSArray *watermarkArr;

@property (nonatomic, strong) YFSpecialFilterView *gifView;
@property (nonatomic, strong) NSArray *gifArr;

@property (nonatomic, strong) YFSpecialFilterView *timeSpecialView;
@property (nonatomic, strong) NSArray *timeSpecialArr;

@property (nonatomic, assign) BOOL isPlayEnd;
@property (nonatomic, strong) UIImageView *uploadImg;
@property (nonatomic, strong) UILabel *tips;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) BOOL isExit;
@property (nonatomic, assign) BOOL isSaveConfigVideo;
@property (nonatomic, assign) BOOL isReverse;
@property (nonatomic, strong) NSString *playURL;
@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, assign) BOOL isSlow;
@property (nonatomic, assign) CGFloat operationTime;

@end

@implementation YFEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YfMFaceUSession sharedManager].open = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.configManager.UseAble = NO;
    self.uploadCount = 5;
    [self.view addSubview:self.editPreview];
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.editPreview.frame = CGRectMake(size.width*1/4, 0, size.width*1/2, (size.width*1/2)*16/9);
    
    [self addThumbnail];
    [self setUpSubView];
    [self getDisplayLink];
    [self setPlayerAndCamera];
    
}

//文件到文件
- (void)setFileToFile{
    
    [self removeDispalyLink];
    [self.mediaPlayer shutdown];
    self.mediaPlayer = nil;
    self.isApplyConfig = YES;
    self.isWriting = YES;
    [YfConfigureManager defaultConfigure].UseAble = YES;
    NSString *path = [self getDocumentsPath];
    NSString *input = [path stringByAppendingPathComponent:@"splitVideo.mp4"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reverseVideo"] intValue]) {
        input = [path stringByAppendingPathComponent:@"reverse.mp4"];
    }
    NSString *output = [path stringByAppendingPathComponent:@"final.mp4"];
//    NSString *detailIn = [[NSBundle mainBundle] pathForResource:@"360-640(1).mp4" ofType:nil];
//    NSString *endFile = [path stringByAppendingPathComponent:@"detailFinal.mp4"];
//    NSString *changecodeOutput = [path stringByAppendingPathComponent:@"changeCodeFinal.mp4"];
    NSLog(@"%@",self.fileProcess);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"repeatVideo"] intValue]) {
        [self.fileProcess repeat_video:self.operationTime];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"slowVideo"] intValue]){
        [self.fileProcess slow_video:self.operationTime];
    }
    
    [self.fileProcess read:input outPutFile:output];
}

- (void)editVideo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存到相册成功");
        [self popMessageView:@"保存到相册成功"];
    }
}

- (void)setPlayerAndCamera{
    //播放
    [self.mediaPlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCodeVideoComplete:) name:@"changeCodeFinalVideoComplete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseVideoComplete:) name:@"reverseVideoSucess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseVideoFail:) name:@"reverseVideoFail" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseVideo:) name:YfFileVideoReverseToolLoadStatusSuccess object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTap:)];
    tap.numberOfTouchesRequired = 1;
    [self.editPreview addGestureRecognizer:tap];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"reverseVideo"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"repeatVideo"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"slowVideo"];
}

//播放结束
- (void)playerStatusCallBackPlayerPlayEnd:(YfFFMoviePlayerController *)player{
    if (self.funcType != 0) {
        //保存用户配置
        [self addEndConfig];
        [self saveConfigVideo:nil];
    }
    
    [YfMFaceUSession sharedManager].isOnlyBeauty = YES;
    self.isPlayEnd = YES;
//    self.mediaPlayer.currentPlaybackTime = 0;
//    [self.mediaPlayer play];
    [self.editPreview resetConfigure];
//    self.configManager.UseAble = NO;
    
    if (self.isNORecycle) {
        return;
    }
}

- (void)changeCodeVideoComplete:(NSNotification *)notifi{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
    });

    self.isTureUpload = YES;
    [self tureUploadVideo];
    
}

//反转成功
- (void)reverseVideoComplete:(NSNotification *)notifi{
    self.isReverse = YES;
    [self.mediaPlayer clean];
    NSString *path = [[self getDocumentsPath] stringByAppendingPathComponent:@"reverse.mp4"];
    
    [self.mediaPlayer play:[NSURL fileURLWithPath:path] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
    self.playURL = path;
}

//反转失败
- (void)reverseVideoFail:(NSNotification *)notifi{
    [self popMessageView:@"反转失败"];
}

- (void)setUpSubView{
    
    __weak typeof(self)weakSelf = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-160);
        make.height.mas_equalTo((size.width/15)*16/9);
    }];
    
    [self.interverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-160);
        make.height.mas_equalTo((size.width/15)*16/9);
    }];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.displayView).offset(10);
        make.top.equalTo(weakSelf.displayView);
        make.bottom.equalTo(weakSelf.displayView);
        make.width.mas_equalTo(20);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.editPreview);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.saveVideoConfig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(127);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [self.ActionConfig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(177);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.paintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.displayView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(90);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.revoke mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(260);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.editTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.editBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(40, 280));
    }];
    
    [self.waterMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    
    [self.timeSpecialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    
    [self.uploadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.equalTo(weakSelf.view);
    }];
    
    [self.uploadProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.equalTo(weakSelf.view);
    }];
}

//添加缩略图
- (void)addThumbnail{

    self.registeredNotifications = [[NSMutableArray alloc] init];
    [self registerApplicationObservers];

    
    NSString *path = [self getJpgDocumentsPath];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat viewW = size.width/15;
    CGFloat interval = self.pictureCount/15;
    
    for (int i = 0; i < 15; ++i) {
        NSString *str = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(i*interval)+1];
        UIImageView *imagView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:str]];
        imagView.frame = CGRectMake(viewW*i, 0, viewW, viewW*16/9);
        [self.interverView addSubview:imagView];
    }
}

- (void)unregisterApplicationObservers
{
    for (NSString *name in self.registeredNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                                           name:@"YfPlayerStatusReadyToPlayNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                                           name:@"YfPlayerStatusLoadingNotification"
                                                  object:nil];
    
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

- (void)getDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayProgress)];
    self.displayLink.frameInterval = 3;
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeDispalyLink{
    
    if (_displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

//获取document路径
- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

//弹窗
- (void)popMessageView:(NSString *)meg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:meg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)applicationDidBecomeActive{}

- (void)applicationWillResignActive{}

- (void)applicationWillEnterForeground
{
    NSLog(@"======>>>>>>前台");
    if(!self.isWriting){
        [self.hud hide:YES];
    }
    
    NSString *path = [self getDocumentsPath];
    NSString *input = [path stringByAppendingPathComponent:@"splitVideo.mp4"];
    NSString *output = [path stringByAppendingPathComponent:@"final.mp4"];
    if (self.isWriting) {
        self.configManager.UseAble = YES;
        [self.fileProcess read:input outPutFile:output];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)applicationDidEnterBackground{
    
    if (_mediaPlayer) {
        [_mediaPlayer pause];
    }
    
    if (self.isWriting) {
        //正在写文件
        [self.fileProcess clean];
        [self.editPreview resetConfigure];
//        [_editPreview releassePreview];
//        _editPreview = nil;
    }
}

- (void)applicationWillTerminate{}

//清除资源
- (void)exitVC:(UIButton *)sender{
    
    [self.hud hide:YES];
    
    if (_mediaPlayer) {
        [self removeDispalyLink];
        [_mediaPlayer shutdown];
        _mediaPlayer = nil;
    }
    
    if (sender) {
        self.isExit = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(observerCurrentPlayBackTime) object:nil];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[YFMusicShakeViewController class]]) {
                
                YFMusicShakeViewController *vc = (YFMusicShakeViewController *)controller;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
    self.configManager.UseAble = NO;
    [self.configManager clean];

    [self.fileProcess clean];
    self.fileProcess = nil;
    
    [YfMFaceUSession sharedManager].open = NO;
    
    if (_editPreview) {
        [_editPreview resetConfigure];
        [_editPreview switchFilter:YFINSTCameraPreview_NORMAL_FILTER];
        
        [_editPreview releassePreview];
        _editPreview = nil;
    }
}

//单击手势
- (void)didClickTap:(UITapGestureRecognizer *)tap{
    if (self.imgView.hidden) {
        [self pauseVideo];
    }else{
        [self playVideo];
        self.isPlayEnd = NO;
    }
}

- (void)playVideo{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imgView.hidden = YES;
        [self.mediaPlayer play];
        [self getDisplayLink];
    });
}

- (void)pauseVideo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imgView.hidden = NO;
        [self.mediaPlayer pause];
        [self removeDispalyLink];
    });
}

//显示进度
- (void)displayProgress{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.animationView.pointX = (self.mediaPlayer.currentPlaybackTime*width)/self.mediaPlayer.duration;
    if (self.isShow) {
        double pts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoPtsCallBack"] doubleValue];
        
        self.paintView.progress = pts * width / self.mediaPlayer.duration;
    }
}

//开始回调
- (void)addStartConfig{
    
    //底层播放器视频的pts数据回调
    double startPts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoPtsCallBack"] doubleValue];
    
    NSLog(@"startVideoPts==%f",startPts);
    
    self.startRecord = startPts;
}

//结束回调
- (void)addEndConfig{
    
    double endPts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoPtsCallBack"] doubleValue];
    
    self.endRecord = endPts;
    YFRange *range = [YFRange rangeWithLoc:self.startRecord end:endPts type:self.funcType];
    range.specialType = self.specialType;
    range.insType = self.insType;
    range.beautyType = self.beautyType;
    range.amazingFilter = self.soulType;
    if (self.texTureName) {
        range.texTureName = self.texTureName;
    }
    
    [self.ranges addObject:range];
    
    NSLog(@"self.ranges== %f=====%f===%d",range.loc,range.end,(int)range.specialType);

}

//计算所有的节点
- (NSArray *)calculateTimeNoods:(NSArray *)rangeArray {
    
    NSMutableArray *nodes = [NSMutableArray array];
    
    NSMutableSet *set = [NSMutableSet set];
    
    [rangeArray enumerateObjectsUsingBlock:^(YFRange *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:@(obj.loc)];
        [set addObject:@(obj.end)];
    }];
    
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [nodes addObject:obj];
    }];
    
    return [nodes sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        CGFloat v1 = obj1.floatValue;
        CGFloat v2 = obj2.floatValue;
        if (v1 < v2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

- (void)saveConfigVideo:(UIButton *)sender{
    
    if (self.ranges.count < 1) {
        return;
    }
    self.imgView.hidden = YES;
    self.isNORecycle = YES;
    self.isApplyConfig = YES;
    
    //获取所有排好序的节点
    self.nodes = [self calculateTimeNoods:self.ranges];
    //反转数组
    NSArray *reversedRange = [[self.ranges reverseObjectEnumerator] allObjects];
    
    NSMutableArray *types = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    for (int i = 0; i < self.nodes.count - 1; ++i) {
        CGFloat mid = (self.nodes[i].floatValue + self.nodes[i+1].floatValue)/2;
        
        [reversedRange enumerateObjectsUsingBlock:^(YFRange *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            *stop = [weakSelf isInRange:obj time:mid];
            if (*stop) {
                YFRange *range = [YFRange rangeWithLoc:self.nodes[i].floatValue end:self.nodes[i+1].floatValue type:obj.type];
                if (obj.texTureName) {
                    range.texTureName = obj.texTureName;
                }
                range.specialType = obj.specialType;
                range.insType = obj.insType;
                range.beautyType = obj.beautyType;
                range.amazingFilter = obj.amazingFilter;
                NSDictionary *dict = [self objectToString:range];
                [types addObject:dict];
            }
        }];
    }
    
    self.operateArr = types;
    
    NSDictionary *dict = @{@"configKey":self.operateArr};
    
    const char *config = [[self convertToJsonData:dict] cStringUsingEncoding:NSUTF8StringEncoding];
    BOOL yes = [self.configManager ConfigureWithConfigureChar:config];
    
//    [self removeDispalyLink];
    
    if (yes) {
//        self.configManager.UseAble = NO;
        [self.editPreview resetConfigure];
        self.configManager.UseAble = YES;
//        self.mediaPlayer.currentPlaybackTime = 0;
//        [self.mediaPlayer play];
        
//        [_mediaPlayer shutdown];
//        _mediaPlayer = nil;
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mediaPlayer play];
//            if (!_displayLink) {
//                [self getDisplayLink];
//            }
//        });
    }
    
    NSLog(@"字典=%@",dict);
}

- (BOOL)isInRange:(YFRange *)range time:(CGFloat)time {
    return time >= range.loc && time <= range.end;
}

- (void)didClickConfigBtn:(UIButton *)sender{
    
    self.editPreview.hidden = YES;
    if (!self.isApplyConfig) {
        [self.mediaPlayer pause];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reverseVideo"] intValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"repeatVideo"] intValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"slowVideo"] intValue]) {
            [self.hud show:YES];
            [self setFileToFile];
        }else{
            [self popMessageView:@"保存成功,可以上传了"];
        }
        
    }else{
        [self.hud show:YES];
        self.isSaveConfigVideo = YES;
        //应用配置
        [self setFileToFile];
    }
}

//转码
- (void)ClickChangeCodeBtn:(NSString *)output andInputFile:(NSString *)input bitrate:(int)bitrate{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"textFieldBitrate"] intValue]) {
        bitrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"textFieldBitrate"] intValue];
        NSLog(@"bitrate == %d",bitrate);
    }
    int rate = 25;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"textFieldRate"] intValue]) {
        rate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"textFieldRate"] intValue];
    }
    
    [self.yfSession MediaChangeCode:input outputFile:output BitRate:bitrate Rate:rate taskId:44];
}

//字典转json
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

- (NSDictionary *)objectToString:(YFRange *)range{
    NSString *path = range.texTureName;
    NSDictionary *dict = nil;
    if (path) {
        dict = @{@"Loc":@(range.loc),@"end":@(range.end),@"Type":@(range.type),@"textTure":range.texTureName,@"insFilter":@(range.insType),@"beautyType":@(range.beautyType),@"specialFilter":@(range.specialType),@"amazingFilter":@(range.amazingFilter)};
    }else{
        dict = @{@"Loc":@(range.loc),@"end":@(range.end),@"Type":@(range.type),@"textTure":@(0),@"insFilter":@(range.insType),@"beautyType":@(range.beautyType),@"specialFilter":@(range.specialType),@"amazingFilter":@(range.amazingFilter)};
    }
    
    return dict;
}

//真正的上传视频
- (void)tureUploadVideo{
    
    gettimeofday(&record, NULL);
//    http://upload.fileinject.yunfancdn.com/file/create?user=yunfanlive&token=413adcb0059f071ba03d967ac158fbae&key=/images/dashboard.jpg
    //上传地址
    NSString *format = [NSString stringWithFormat:@"http://upload.fileinject.yunfancdn.com/file/create?user=yunfanlive&token=413adcb0059f071ba03d967ac158fbae&key=yflive/2017/Video%ld.mp4",record.tv_sec];
    //播放地址
    self.format = [NSString stringWithFormat:@"http://hls.yfzk-test.yflive.net/yflive/2017/Video%ld.mp4",record.tv_sec];
    NSURL *url = [NSURL URLWithString:format];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    NSURL *fileURL = [NSURL URLWithString:[[self getDocumentsPath] stringByAppendingPathComponent:@"changeCodeFinal.mp4"]];
    
    __weak typeof(self)weakSelf = self;
    //设置代理
    [[[AFHTTPSessionManager manager]uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float progress = (float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        
        if (progress < weakSelf.recordProcess) {
            progress = weakSelf.recordProcess;
        }
        
        if (progress > 0.95) {
            progress = 0.95;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.uploadProcess.progress = progress;
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSDictionary *  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",responseObject);
        
        if (error) {
            return ;
        }
        
        if (![responseObject[@"result"] isEqualToString:@"success"]) {
            weakSelf.uploadProcess.hidden = YES;
            weakSelf.uploadImg.hidden = YES;
            [weakSelf popMessageView:@"上传失败"];
            return;
        }
        
        weakSelf.isuploadComplete = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.editPreview resetConfigure];
            weakSelf.configManager.UseAble = NO;
            
            [weakSelf.mediaPlayer clean];
            NSLog(@"%@",weakSelf.format);
            [weakSelf.mediaPlayer play:[NSURL URLWithString:weakSelf.format] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
            weakSelf.playURL = weakSelf.format;
        });
        
    }] resume];

}

//上传视频
- (void)uploadVideo:(UIButton *)sender{
    
    [self removeDispalyLink];
    
    if (!self.isApplyConfig) {
        self.uploadProcess.hidden = NO;
        self.uploadImg.hidden = NO;
        [self updateProcess];
        NSString *input = [[self getDocumentsPath] stringByAppendingPathComponent:@"splitVideo.mp4"];
        NSString *changecodeVideo = [[self getDocumentsPath] stringByAppendingPathComponent:@"changeCodeFinal.mp4"];
        [self ClickChangeCodeBtn:changecodeVideo andInputFile:input bitrate:2000];
//        [self tureUploadVideo];
    }else{
        //转码
        NSString *path = [self getDocumentsPath];
        NSString *output = [path stringByAppendingPathComponent:@"final.mp4"];
        NSString *changecodeOutput = [path stringByAppendingPathComponent:@"changeCodeFinal.mp4"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:output]) {
            [self popMessageView:@"请先保存文件"];
            return;
        }
        self.uploadProcess.hidden = NO;
        self.uploadImg.hidden = NO;
        [self updateProcess];
        
        [self ClickChangeCodeBtn:changecodeOutput andInputFile:output bitrate:1500];
    }
}

- (void)updateProcess{
    
    if (self.isTureUpload || self.recordProcess >= 0.95) {
        return;
    }
    
    self.recordProcess += 0.01;
    
    self.uploadProcess.progress = self.recordProcess;
    [self performSelector:@selector(updateProcess) withObject:nil afterDelay:1];
}

- (void)sliderValueChanged:(UISlider *)sender{
    
    self.mediaPlayer.currentPlaybackTime = sender.value;
    [self.mediaPlayer play];
}

//开始网络播放
- (void)startOnlinePlay:(UIButton *)sender{
    
    [_editPreview releassePreview];
    _editPreview = nil;
    
    [self.playtext removeFromSuperview];
    [self.startPlay removeFromSuperview];
    [self.tips removeFromSuperview];
    //加载预览层
    self.mediaPlayer.view.frame = self.view.bounds;
    [self.view addSubview:self.mediaPlayer.view];
    __weak typeof(self)weakSelf = self;
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.bottom.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [self.mediaPlayer play];
    [self observerCurrentPlayBackTime];
    [self.view bringSubviewToFront:self.exitBtn];
}

- (void)observerCurrentPlayBackTime{
    if (self.isExit) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
       self.slider.value = self.mediaPlayer.currentPlaybackTime;
    });
    [self performSelector:@selector(observerCurrentPlayBackTime) withObject:self afterDelay:1];
}

//点击了编辑特效
- (void)didClickEditBtn:(UIButton *)sender{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (sender.selected) {
        sender.selected = NO;
        self.categoryView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.editPreview.frame = CGRectMake(size.width*1/4, 0, size.width*1/2, (size.width*1/2)*16/9);
        }];
    }else{
        sender.selected = YES;
        self.categoryView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.editPreview.frame = self.view.bounds;
        }];
    }
    
}

//撤销
- (void)didClickRevokeBtn:(UIButton *)sender{
    if (self.paintView.pathPoints.count > 0) {
        [self.paintView removeLast];
    }
    if (self.ranges.count > 0) {
        [self.ranges removeLastObject];
        if (self.ranges.count >= 1) {
            [self saveConfigVideo:nil];
        }
    }
}

#pragma mark ----  播放器代理及文件处理代理
//fileProcess ==>> Read ==>> 输出软解码视频数据 ==>>相机处理数据加faceU ==>> 代理输出
//相机美颜处理后的数据
- (void)willoutputpixelbuffer:(CVPixelBufferRef)PixelBuffer pts:(int64_t)pts{
    if (self.isWriting) {
        NSLog(@"%lld",pts);
        [self.fileProcess EnQueueBuffer:PixelBuffer pts:pts];
    }
}

//开始写入
- (void)processStatusCallBackStarted:(YfFileProcessManager *)manager{
    NSLog(@"开始写入");
}

//写入完成
- (void)processStatusCallBackEnded:(YfFileProcessManager *)manager{
    self.isWriting = NO;
    
    //添加片尾
    //                NSMutableArray * mutArr = [NSMutableArray array];
    //                [mutArr addObject:output];
    //                [mutArr addObject:detailIn];
    //                [weakSelf.yfSession MediaContactInputArr:mutArr outPutPath:endFile AndTaskId:33];
    
    //使用完记得关掉和复位
    [YfConfigureManager defaultConfigure].UseAble = NO;
    [self.editPreview resetConfigure];
    //异步执行
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
    });
    //                UISaveVideoAtPathToSavedPhotosAlbum(endFile, weakSelf, @selector(editVideo:didFinishSavingWithError:contextInfo:), nil);
    NSString *path = [self getDocumentsPath];
    NSString *output = [path stringByAppendingPathComponent:@"final.mp4"];
    //可能文件未写完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL yes = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(output);
        if (yes) {
            UISaveVideoAtPathToSavedPhotosAlbum(output, self, @selector(editVideo:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

//写入错误
- (void)processStatusCallBackError:(YfFileProcessManager *)manager{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
        [self popMessageView:@"文件写入错误,读取数据"];
        [self.fileProcess clean];
    });
}


- (void)willOutputPlayerRenderbuffer:(CVPixelBufferRef)renderbuffer player:(YfFFMoviePlayerController *)player{
    
    double pts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoPtsCallBack"] doubleValue];
    if (_editPreview) {
        [_editPreview receiveYUVTextureBuffer:renderbuffer pts:pts * 1000];
    }
}

//fileManager输出软解码视频数据 =>> 保存文件
- (void)willOutPutYUVTexture:(void*)yData U:(void*)uData V:(void*)vData Ysize:(size_t)Ysize Usize:(size_t)Usize Vsize:(size_t)Vsize  videoSize:(CGSize)videoSize pts:(int64_t)pts{
    //相机接收数据
    [self.editPreview receiveYUVTextureY:yData U:uData V:vData Ysize:CGSizeMake(Ysize, videoSize.height) Usize:CGSizeMake(Usize, videoSize.height/2.0) Vsize:CGSizeMake(Vsize, videoSize.height/2.0) videoSize:(CGSize)videoSize pts:pts];
}

//播放器加载资源成功
- (void)playerStatusCallBackLoadingSuccess:(YfFFMoviePlayerController *)player{
    
    NSLog(@"加载成功");
}

- (void)playerStatusCallBackLoadingCanReadyToPlay:(YfFFMoviePlayerController *)player
{
    NSLog(@"异步加载完成");
    //反转
    if (self.isReverse) {
        
        if (!self.displayLink) {
            [self getDisplayLink];
        }
        [player play];
        
        if (self.isSlow) {
            self.isShow = NO;
            self.mediaPlayer.currentPlaybackTime = self.mediaPlayer.duration/2;
            [self.mediaPlayer slow_video:self.mediaPlayer.duration/2+0.5];
            self.operationTime = self.mediaPlayer.duration/2+0.5;
        }
        if (self.isRepeat) {
            self.isRepeat = NO;
            self.mediaPlayer.currentPlaybackTime = self.mediaPlayer.duration/2;
            [self.mediaPlayer repeat_video:self.mediaPlayer.duration/2+0.5];
            self.operationTime = self.mediaPlayer.duration/2+0.5;
        }
    }
    
    if (self.isuploadComplete) {
        [player pause];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.uploadProcess.progress = 1;
            //            self.uploadProcess.hidden = YES;
        });
        self.tips.frame = CGRectMake(20, 40, [UIScreen mainScreen].bounds.size.width, 30);
        self.playtext.frame = CGRectMake(20, 80, 340, 40);
        self.playtext.text = self.format;
        self.startPlay.frame = CGRectMake(20, 140, 120, 40);
    }
}

- (void)playerStatusCallBackPlayerPlayErrorType:(YfPLAYER_MEDIA_ERROR)errorType httpErrorCode:(int)httpErrorCode player:(YfFFMoviePlayerController *)player{
    if (self.isuploadComplete) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.uploadCount < 0) {
                self.isTureUpload = YES;
                [self popMessageView:@"上传失败"];
                [self.view bringSubviewToFront:self.exitBtn];
                return;
            }
//            self.uploadProcess.hidden = YES;
//            self.uploadProcess.progress = 1;
//            [self popMessageView:@"播放错误"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.uploadCount --;
                [self.mediaPlayer clean];
                [self.mediaPlayer play:[NSURL URLWithString:self.format] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
                self.playURL = self.format;
            });
            
        });
    }
}

#pragma mark ----  懒加载

- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [_exitBtn addTarget:self action:@selector(exitVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitBtn];
    }
    return _exitBtn;
}

- (YFUploadProcessView *)uploadProcess{
    if (!_uploadProcess) {
        _uploadProcess = [[YFUploadProcessView alloc] init];
        _uploadProcess.backgroundColor = [UIColor clearColor];
        _uploadProcess.hidden = YES;
        [self.view addSubview:_uploadProcess];
    }
    return _uploadProcess;
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.labelText = @"正在保存";
        [_hud hide:YES];
        [self.view addSubview:_hud];
    }
    return _hud;
}

- (NSMutableArray *)operateArr{
    if (!_operateArr) {
        _operateArr = [NSMutableArray array];
    }
    return _operateArr;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"play"];
        _imgView.hidden = YES;
        [self.editPreview addSubview:_imgView];
    }
    return _imgView;

}

- (UIButton *)ActionConfig{
    if (!_ActionConfig) {
        _ActionConfig = [[UIButton alloc] init];
        _ActionConfig.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_ActionConfig setTitleColor:[UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1] forState:UIControlStateNormal];
        [_ActionConfig setTitle:@"保存" forState:UIControlStateNormal];
        [_ActionConfig setBackgroundImage:[UIImage imageNamed:@"startRecord2"] forState:UIControlStateNormal];
        [_ActionConfig addTarget:self action:@selector(didClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ActionConfig];
    }
    return _ActionConfig;
}

- (YFPaintView *)paintView{
    if (!_paintView) {
        _paintView = [[YFPaintView alloc] init];
        _paintView.backgroundColor = [UIColor brownColor];
        _paintView.clipsToBounds = YES;
        [self.view addSubview:_paintView];
    }
    return _paintView;
}

- (YFCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[YFCategoryView alloc] init];
        _categoryView.hidden = YES;
        __weak typeof(self)weakSelf = self;
        
        _categoryView.specialCallBack = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.waterMarkView.hidden = NO;
                weakSelf.gifView.hidden = YES;
                weakSelf.timeSpecialView.hidden = YES;
            });
        };
        _categoryView.gifCallBack = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.waterMarkView.hidden = YES;
                weakSelf.gifView.hidden = NO;
                weakSelf.timeSpecialView.hidden = YES;
            });
        };
        
        _categoryView.timeSpecialCallBack = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.waterMarkView.hidden = YES;
                weakSelf.gifView.hidden = YES;
                weakSelf.timeSpecialView.hidden = NO;
            });
        };
        
        [self.view addSubview:_categoryView];
    }
    return _categoryView;
}

- (YFSpecialFilterView *)waterMarkView{
    if (!_waterMarkView) {
        _waterMarkView = [[YFSpecialFilterView alloc] init];
        _waterMarkView.theme = @"特效";
        _waterMarkView.hidden = YES;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        __weak typeof(self)weakSelf = self;
        _waterMarkView.touchDownCallBack = ^(UIButton *icon,UIButton *title){
            NSLog(@"按下去了");
            weakSelf.configManager.UseAble = NO;
            if (weakSelf.isPlayEnd) {
                return ;
            }
            
            if (![weakSelf.mediaPlayer isPlaying]) {
                [weakSelf playVideo];
            }
            
            weakSelf.isShow = 1;
            NSString *theme = title.titleLabel.text;
            
            //添加起始用户操作配置
            [weakSelf addStartConfig];
            
            if ([theme isEqualToString:@"黑魔法"]){
                
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterSobelLine];
                weakSelf.funcType = ActionSpecialFilter;
                weakSelf.specialType = YfSessionCameraFilterSobelLine;
                weakSelf.paintView.myColor = [UIColor orangeColor];
                
            }else if ([theme isEqualToString:@"抖动"]){
                
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterSeparateRGB];
                weakSelf.funcType = ActionSpecialFilter;
                weakSelf.specialType = YfSessionCameraFilterSeparateRGB;
                
                weakSelf.paintView.myColor = [UIColor cyanColor];
            }else if ([theme isEqualToString:@"old TV"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterBlackColorTV];
                weakSelf.funcType = ActionSpecialFilter;
                weakSelf.specialType = YfSessionCameraFilterBlackColorTV;
                
                weakSelf.paintView.myColor = [UIColor purpleColor];
            }else if ([theme isEqualToString:@"灵魂抖动"]){
                [weakSelf.editPreview useSoul:YES];
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = SoulShake;
                
                weakSelf.paintView.myColor = [UIColor greenColor];
            }else if ([theme isEqualToString:@"九宫格"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterNineBoxFilterNormal];
                weakSelf.funcType = ActionSpecialFilter;
                weakSelf.specialType = YfSessionCameraFilterNineBoxFilterNormal;
                
                weakSelf.paintView.myColor = [UIColor magentaColor];
            }else if ([theme isEqualToString:@"左右镜像"]){
                [weakSelf.editPreview switchMirrorFilter:YfPreViewMirrorFilterRightLeft];
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = MirrorLeftRight;
                weakSelf.paintView.myColor = [UIColor yellowColor];
            }
            
            NSLog(@"self.startRecord = %f",weakSelf.startRecord);
            weakSelf.paintView.myLineWidth = 60;
            [weakSelf.paintView startWithProgress:(weakSelf.startRecord * width) / weakSelf.mediaPlayer.duration];
        };
        _waterMarkView.touchExitCallBack = ^(UIButton *icon,UIButton *title){
            NSLog(@"离开了");
            weakSelf.configManager.UseAble = YES;
            if (weakSelf.isPlayEnd) {
                if (weakSelf.isShow) {
                    weakSelf.isShow = 0;
                    [weakSelf.paintView endWithProgress:(weakSelf.endRecord * width) / weakSelf.mediaPlayer.duration];
                }
                return ;
            }
            
            NSString *theme = title.titleLabel.text;
            [weakSelf pauseVideo];
            weakSelf.isShow = 0;
            
            //添加配置
            [weakSelf addEndConfig];
            [weakSelf saveConfigVideo:nil];
            weakSelf.funcType = ActionNone;
            
            if ([theme isEqualToString:@"黑魔法"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterDefault];
                weakSelf.specialType = YfSessionCameraFilterNormal;
            }else if ([theme isEqualToString:@"抖动"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterDefault];
                weakSelf.specialType = YfSessionCameraFilterNormal;
            }else if ([theme isEqualToString:@"old TV"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterDefault];
                weakSelf.specialType = YfSessionCameraFilterNormal;
            }else if ([theme isEqualToString:@"灵魂抖动"]){
                [weakSelf.editPreview useSoul:NO];
                weakSelf.soulType = None;
            }else if ([theme isEqualToString:@"九宫格"]){
                [weakSelf.editPreview setupFilter:YfSessionPreViewFilterDefault];
                weakSelf.specialType = YfSessionCameraFilterNormal;
            }else if ([theme isEqualToString:@"左右镜像"]){
                [weakSelf.editPreview switchMirrorFilter:YfPreViewMirrorFilterNone];
                weakSelf.soulType = None;
            }
            
            NSLog(@"weakSelf.endRecord = %f",weakSelf.endRecord);
            [weakSelf.paintView endWithProgress:(weakSelf.endRecord * width) / weakSelf.mediaPlayer.duration];
        };
        _waterMarkView.titleArr = self.watermarkArr;
        [self.view addSubview:_waterMarkView];
        
    }
    return _waterMarkView;
}

- (YFSpecialFilterView *)gifView{
    if (!_gifView) {
        _gifView = [[YFSpecialFilterView alloc] init];
        _gifView.theme = @"Gif";
        _gifView.hidden = YES;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        __weak typeof(self)weakSelf = self;
        _gifView.touchDownCallBack = ^(UIButton *icon,UIButton *title){
            NSLog(@"按下去了");
            weakSelf.configManager.UseAble = NO;
            if (weakSelf.isPlayEnd) {
                return ;
            }
            if (![weakSelf.mediaPlayer isPlaying]) {
                [weakSelf playVideo];
            }
            weakSelf.isShow = 1;
            NSString *theme = title.titleLabel.text;
            
            //添加起始用户操作配置
            [weakSelf addStartConfig];
            if([theme isEqualToString:@"🐔"]){
                NSString *file = [[NSBundle mainBundle] pathForResource:@"0001" ofType:@"gif"];
                [weakSelf.editPreview decodeAndRenderWithFilePath:file PointRect:CGRectMake(10, 10, 80, 80)];
                
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = Gif;
                weakSelf.texTureName = file;
                weakSelf.paintView.myColor = [UIColor redColor];
            }else if([theme isEqualToString:@"🐿"]){
                NSString *file = [[NSBundle mainBundle] pathForResource:@"0002" ofType:@"gif"];
                [weakSelf.editPreview decodeAndRenderWithFilePath:file PointRect:CGRectMake(10, 10, 80, 80)];
                
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = Gif;
                weakSelf.texTureName = file;
                weakSelf.paintView.myColor = [UIColor blueColor];
            }else if([theme isEqualToString:@"🐶"]){
                NSString *file = [[NSBundle mainBundle] pathForResource:@"0003" ofType:@"gif"];
                [weakSelf.editPreview decodeAndRenderWithFilePath:file PointRect:CGRectMake(10, 10, 80, 80)];
                
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = Gif;
                weakSelf.texTureName = file;
                weakSelf.paintView.myColor = [UIColor whiteColor];
            }else if([theme isEqualToString:@"🍉"]){
                NSString *file = [[NSBundle mainBundle] pathForResource:@"0004" ofType:@"gif"];
                [weakSelf.editPreview decodeAndRenderWithFilePath:file PointRect:CGRectMake(10, 10, 80, 80)];
                
                weakSelf.funcType = ActionAmazingFilter;
                weakSelf.soulType = Gif;
                weakSelf.texTureName = file;
                weakSelf.paintView.myColor = [UIColor blackColor];
            }
            
            NSLog(@"self.startRecord = %f",weakSelf.startRecord);
            weakSelf.paintView.myLineWidth = 60;
            [weakSelf.paintView startWithProgress:(weakSelf.startRecord * width) / weakSelf.mediaPlayer.duration];
        };
        _gifView.touchExitCallBack = ^(UIButton *icon,UIButton *title){
            NSLog(@"离开了");
            weakSelf.configManager.UseAble = YES;
            if (weakSelf.isPlayEnd) {
                if (weakSelf.isShow) {
                    weakSelf.isShow = 0;
                    [weakSelf.paintView endWithProgress:(weakSelf.endRecord * width) / weakSelf.mediaPlayer.duration];
                }
                return ;
            }
            NSString *theme = title.titleLabel.text;
            [weakSelf pauseVideo];
            weakSelf.isShow = 0;
            
            //添加配置
            [weakSelf addEndConfig];
            [weakSelf saveConfigVideo:nil];
            weakSelf.funcType = ActionNone;
            
            if([theme isEqualToString:@"🐔"]){
                
                [weakSelf.editPreview closeAndCleanGif];
                weakSelf.texTureName = nil;
                weakSelf.soulType = None;
            }else if([theme isEqualToString:@"🐿"]){
                [weakSelf.editPreview closeAndCleanGif];
                weakSelf.texTureName = nil;
                weakSelf.soulType = None;
            }else if([theme isEqualToString:@"🐶"]){
                [weakSelf.editPreview closeAndCleanGif];
                weakSelf.texTureName = nil;
                weakSelf.soulType = None;
            }else if([theme isEqualToString:@"🍉"]){
                [weakSelf.editPreview closeAndCleanGif];
                weakSelf.texTureName = nil;
                weakSelf.soulType = None;
            };
            NSLog(@"weakSelf.endRecord = %f",weakSelf.endRecord);
            [weakSelf.paintView endWithProgress:(weakSelf.endRecord * width) / weakSelf.mediaPlayer.duration];
        };
        _gifView.titleArr = self.gifArr;
        [self.view addSubview:_gifView];
    }
    return _gifView;
}

- (YFSpecialFilterView *)timeSpecialView{
    if (!_timeSpecialView) {
        _timeSpecialView = [[YFSpecialFilterView alloc] init];
        _timeSpecialView.theme = @"时光";
        _timeSpecialView.hidden = YES;
        __weak typeof(self)weakSelf = self;

        _timeSpecialView.touchExitCallBack = ^(UIButton *icon,UIButton *title){
            
            NSString *theme = title.titleLabel.text;
            if([theme isEqualToString:@"无"]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UIView *view in weakSelf.interverView.subviews) {
                        [view removeFromSuperview];
                    }
                    
                    NSString *path = [weakSelf getJpgDocumentsPath];
                    CGSize size = [UIScreen mainScreen].bounds.size;
                    CGFloat viewW = size.width/15;
                    CGFloat interval = weakSelf.pictureCount/15;
                    
                    for (int i = 0; i < 15; ++i) {
                        NSString *str = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(i*interval)+1];
                        UIImageView *imagView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:str]];
                        imagView.frame = CGRectMake(viewW*i, 0, viewW, viewW*16/9);
                        [weakSelf.interverView addSubview:imagView];
                    }
                });
                if ([weakSelf.playURL containsString:@"splitVideo.mp4"]) {
                    return ;
                }
                
                weakSelf.playURL = [[weakSelf getDocumentsPath] stringByAppendingString:@"/splitVideo.mp4"];
                [weakSelf.mediaPlayer clean];
                [weakSelf.mediaPlayer play:[NSURL URLWithString:weakSelf.playURL] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
                
            }else if([theme isEqualToString:@"时光倒流"]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UIView *view in weakSelf.interverView.subviews) {
                        [view removeFromSuperview];
                    }
                    
                    NSString *path = [weakSelf getJpgDocumentsPath];
                    CGSize size = [UIScreen mainScreen].bounds.size;
                    CGFloat viewW = size.width/15;
                    CGFloat interval = weakSelf.pictureCount/15;
                    
                    for (int i = 14; i >= 0; i--) {
                        NSString *str = [NSString stringWithFormat:@"%@/%d.jpg",path,(int)(i*interval)+1];
                        NSLog(@"%@",str);
                        UIImageView *imagView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:str]];
                        imagView.frame = CGRectMake(viewW*(14-i), 0, viewW, viewW*16/9);
                        [weakSelf.interverView addSubview:imagView];
                    }
                });
                
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"reverseVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"repeatVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"slowVideo"];
                if (weakSelf.isReverse && [[NSFileManager defaultManager] fileExistsAtPath:[[weakSelf getDocumentsPath] stringByAppendingPathComponent:@"reverse.mp4"]]) {
                    //文件存在
                    if ([weakSelf.playURL containsString:@"reverse.mp4"]) {
                        return;
                    }else{
                        weakSelf.playURL = [[weakSelf getDocumentsPath] stringByAppendingPathComponent:@"reverse.mp4"];
                        [weakSelf.mediaPlayer clean];
                        [weakSelf.mediaPlayer play:[NSURL URLWithString:weakSelf.playURL] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
                        return;
                    }
                }
                //文件不存在
                NSLog(@"时光倒流");
                //反转
                [weakSelf.mediaPlayer pause];
                NSString *path = [weakSelf getDocumentsPath];
                //splitVideo.mp4   -- final.mp4
                NSString *path1 = [path stringByAppendingPathComponent:@"splitVideo.mp4"];
                NSString *path2 = [path stringByAppendingPathComponent:@"final.mp4"];
                NSString *path3 = [path stringByAppendingPathComponent:@"reverse.mp4"];
                if (weakSelf.isSaveConfigVideo) {
                    path = path2;
                }else{
                    path = path1;
                }
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    
                    [weakSelf popMessageView:@"未生成最终文件"];
                }else{
                    [weakSelf getStartTime];
                    [weakSelf.yfSession MediaReverseVideo:path outPutFile:path3 taskId:50];
                }
            }else if([theme isEqualToString:@"慢动作"]){
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"reverseVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"repeatVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"slowVideo"];
                
                if ([weakSelf.playURL containsString:@"splitVideo.mp4"]) {
                    
                    weakSelf.mediaPlayer.currentPlaybackTime = weakSelf.mediaPlayer.duration/2;
                    [weakSelf.mediaPlayer slow_video:weakSelf.mediaPlayer.duration/2+0.5];
                     weakSelf.operationTime = weakSelf.mediaPlayer.duration/2+0.5;
                }else{
                    weakSelf.isSlow = YES;
                    weakSelf.playURL = [[weakSelf getDocumentsPath] stringByAppendingPathComponent:@"splitVideo.mp4"];
                    [weakSelf.mediaPlayer clean];
                    [weakSelf.mediaPlayer play:[NSURL fileURLWithPath:weakSelf.playURL] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
                }
                
            }else if([theme isEqualToString:@"重复"]){
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"reverseVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"repeatVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"slowVideo"];
                if ([weakSelf.playURL containsString:@"splitVideo.mp4"]) {
                    
                    weakSelf.mediaPlayer.currentPlaybackTime = weakSelf.mediaPlayer.duration/2;
                    [weakSelf.mediaPlayer repeat_video:weakSelf.mediaPlayer.duration/2+0.5];
                    weakSelf.operationTime = weakSelf.mediaPlayer.duration/2+0.5;
                }else{
                    weakSelf.isRepeat = YES;
                    weakSelf.playURL = [[weakSelf getDocumentsPath] stringByAppendingPathComponent:@"splitVideo.mp4"];
                    [weakSelf.mediaPlayer clean];
                    [weakSelf.mediaPlayer play:[NSURL fileURLWithPath:weakSelf.playURL] useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0];
                    weakSelf.operationTime = weakSelf.mediaPlayer.duration/2+0.5;
                }
            }
            
        };
        _timeSpecialView.titleArr = self.timeSpecialArr;
        [self.view addSubview:_timeSpecialView];
    }
    return _timeSpecialView;
}

- (NSArray *)watermarkArr{
    if (!_watermarkArr) {
        _watermarkArr = [NSArray arrayWithObjects:@{@"iconNomal":@"specialBlackWhite",@"iconSelected":@"specialBlackWhite",@"title":@"黑魔法"},@{@"iconNomal":@"specialShake",@"iconSelected":@"specialShake",@"title":@"抖动"},@{@"iconNomal":@"specialOld",@"iconSelected":@"specialOld",@"title":@"old TV"},@{@"iconNomal":@"specialSoul",@"iconSelected":@"specialSoul",@"title":@"灵魂抖动"},@{@"iconNomal":@"specialNine",@"iconSelected":@"specialNine",@"title":@"九宫格"},@{@"iconNomal":@"specialMirror",@"iconSelected":@"specialMirror",@"title":@"左右镜像"},   nil];
        NSMutableArray * arr2 = [NSMutableArray array];
        for (NSDictionary *dict in _watermarkArr) {
            YFFunModel *model = [YFFunModel funcModelWithDict:dict];
            [arr2 addObject:model];
        }
        _watermarkArr = arr2;
        
    }
    return _watermarkArr;
}

- (NSArray *)gifArr{
    if (!_gifArr) {
        _gifArr = [NSArray arrayWithObjects:@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"🐔"},@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"🐿"},@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"🐶"},@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"🍉"},   nil];
        NSMutableArray * arr2 = [NSMutableArray array];
        for (NSDictionary *dict in _gifArr) {
            YFFunModel *model = [YFFunModel funcModelWithDict:dict];
            [arr2 addObject:model];
        }
        _gifArr = arr2;
        
    }
    return _gifArr;
}

- (NSArray *)timeSpecialArr{
    if (!_timeSpecialArr) {
        _timeSpecialArr = [NSArray arrayWithObjects:@{@"iconNomal":@"specialNone",@"iconSelected":@"specialNone",@"title":@"无"},@{@"iconNomal":@"specialTimeback",@"iconSelected":@"specialTimeback",@"title":@"时光倒流"},@{@"iconNomal":@"specialSlow",@"iconSelected":@"specialSlow",@"title":@"慢动作"},@{@"iconNomal":@"specialReuse",@"iconSelected":@"specialReuse",@"title":@"重复"},    nil];
        NSMutableArray * arr2 = [NSMutableArray array];
        for (NSDictionary *dict in _timeSpecialArr) {
            YFFunModel *model = [YFFunModel funcModelWithDict:dict];
            [arr2 addObject:model];
        }
        _timeSpecialArr = arr2;
    }
    return _timeSpecialArr;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"adjust1"] forState:UIControlStateNormal];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"adjust2"] forState:UIControlStateHighlighted];
        [_editBtn addTarget:self action:@selector(didClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_editBtn];
    }
    return _editBtn;
}

- (UIButton *)revoke{
    if (!_revoke) {
        _revoke = [[UIButton alloc] init];
        [_revoke setTitle:@"撤销" forState:UIControlStateNormal];
        [_revoke setTitleColor:[UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1] forState:UIControlStateNormal];
        [_revoke setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_revoke setBackgroundImage:[UIImage imageNamed:@"startRecord2"] forState:UIControlStateNormal];
        [_revoke addTarget:self action:@selector(didClickRevokeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_revoke];
    }
    return _revoke;
}

- (UILabel *)editTitle{
    if (!_editTitle) {
        _editTitle = [[UILabel alloc] init];
        _editTitle.text = @"编辑";
        _editTitle.textColor = [UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1];
        _editTitle.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_editTitle];
    }
    return _editTitle;
}

- (UIButton *)saveVideoConfig{
    if (!_saveVideoConfig) {
        _saveVideoConfig = [[UIButton alloc] init];
        [_saveVideoConfig setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveVideoConfig setTitle:@"应用配置" forState:UIControlStateNormal];
        _saveVideoConfig.hidden = YES;
        [_saveVideoConfig setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        _saveVideoConfig.selected = NO;
        _saveVideoConfig.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_saveVideoConfig addTarget:self action:@selector(saveConfigVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveVideoConfig];
    }
    return _saveVideoConfig;
}

- (UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc] init];
        [_uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1] forState:UIControlStateNormal];
        _uploadBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_uploadBtn setBackgroundImage:[UIImage imageNamed:@"startRecord2"] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(uploadVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_uploadBtn];
    }
    return _uploadBtn;
}

- (NSMutableArray<YFRange *> *)ranges{
    if (!_ranges) {
        _ranges = [NSMutableArray array];
    }
    return _ranges;
}

-(YfConfigureManager *)configManager{
    if (!_configManager) {
        _configManager = [YfConfigureManager defaultConfigure];
    }
    return _configManager;
}

//- (YfFileVideoReverseTool *)reverse{
//    
//    if (!_reverse) {
//        NSString *path = [self getDocumentsPath];
//        //splitVideo.mp4   -- final.mp4
//        NSString *path1 = [path stringByAppendingPathComponent:@"splitVideo.mp4"];
//        NSString *path2 = [path stringByAppendingPathComponent:@"final.mp4"];
//        if (self.isSaveConfigVideo) {
//            path = path2;
//        }else{
//            path = path1;
//        }
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//            
//            [self popMessageView:@"未生成最终文件"];
//            return nil;
//        }
//        NSLog(@"path == %@",path);
//        _reverse = [[YfFileVideoReverseTool alloc] initWithInputURL:[NSURL fileURLWithPath:path]];
//    }
//    return _reverse;
//}

- (UILabel *)tips{
    if (!_tips) {
        _tips = [[UILabel alloc] init];
        _tips.textColor = [UIColor whiteColor];
        _tips.text = @"Tips:上传成功后地址可分享给小伙伴";
        [self.view addSubview:_tips];
    }
    return _tips;
}

- (UITextField *)playtext{
    if (!_playtext) {
        _playtext = [[UITextField alloc] init];
        _playtext.borderStyle = UITextBorderStyleRoundedRect;
        [self.uploadProcess addSubview:_playtext];
    }
    return _playtext;
}

- (UIButton *)startPlay{
    if (!_startPlay) {
        _startPlay = [[UIButton alloc] init];
        [_startPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startPlay setTitle:@"开始播放" forState:UIControlStateNormal];
        [_startPlay addTarget:self action:@selector(startOnlinePlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startPlay];
    }
    return _startPlay;
}

- (YfsessionPreView *)editPreview{
    if (!_editPreview) {
        CGSize size = CGSizeMake(540, 960);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"resolution"] intValue]) {
            size = CGSizeMake(360, 640);
        }
        
        _editPreview = [[YfsessionPreView alloc] initWithFrame:self.view.bounds outputbufferSize:size YfImageOrientation:YfImageOrientationNormal];
        _editPreview.delegate = self;
        [_editPreview switchBeautyFilter:YfPreViewBeautifulFilterNone];
        [_editPreview setSharpnessLevel:0.3];
        [_editPreview setBrightNessLevel:-0.2];
        [self.view insertSubview:_editPreview atIndex:0];
    }
    return _editPreview;
}

- (UIImageView *)uploadImg{
    if (!_uploadImg) {
        _uploadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"short-bg"]];
        _uploadImg.hidden = YES;
        [self.view addSubview:_uploadImg];
    }
    return _uploadImg;
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = self.mediaPlayer.duration;
        _slider.value = 0;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.mediaPlayer.view addSubview:_slider];
    }
    return _slider;
}

- (YfFileProcessManager *)fileProcess{
    if (!_fileProcess) {
        _fileProcess = [[YfFileProcessManager alloc] init];
        _fileProcess.delegate = self;
    }
    return _fileProcess;
}

- (YfFFMoviePlayerController *)mediaPlayer{
    if (!_mediaPlayer) {
        
        //播放剪切后的视频
        NSURL *url = [NSURL fileURLWithPath:[[self getDocumentsPath] stringByAppendingString:@"/splitVideo.mp4"]];
        
        _mediaPlayer = [[YfFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil useDns:YES useSoftDecode:YES DNSIpCallBack:nil appID:"" refer:"" bufferTime:0 display:YES isOpenSoundTouch:YES];
        
        self.playURL = [[self getDocumentsPath] stringByAppendingString:@"/splitVideo.mp4"];
        _mediaPlayer.delegate = self;
        [_mediaPlayer prepareToPlay];
        _mediaPlayer.shouldAutoplay = NO;
        
//        [_mediaPlayer pause];
        [self.editPreview resetConfigure];
    }
    return _mediaPlayer;
}

- (YFDisplayView *)displayView{
    if (!_displayView) {
        _displayView = [[YFDisplayView alloc] init];
        __weak typeof(self)weakSelf = self;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _displayView.touchValue = ^(CGPoint point){
//            weakSelf.point = point;
            weakSelf.animationView.pointX = point.x;
            weakSelf.isPlayEnd = NO;
            if ([weakSelf.mediaPlayer isPlaying]) {
                [weakSelf pauseVideo];
            }
            //seek
            weakSelf.mediaPlayer.currentPlaybackTime = weakSelf.mediaPlayer.duration*(point.x/width);
        };
        [self.view addSubview:_displayView];
    }
    return _displayView;
}

- (UIView *)interverView{
    if (!_interverView) {
        _interverView = [[UIView alloc] init];
        [self.displayView addSubview:_interverView];
    }
    return _interverView;
}

- (YFMoveView *)animationView{
    if (!_animationView) {
        _animationView = [[YFMoveView alloc] init];
        _animationView.backgroundColor = [UIColor yellowColor];
        _animationView.layer.cornerRadius = 5;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _animationView.width = width;
        __weak typeof(self)weakSelf = self;
        
        _animationView.moveCallBack = ^(CGFloat pointX){
            weakSelf.isPlayEnd = NO;
            //seek
            if ([weakSelf.mediaPlayer isPlaying]) {
                [weakSelf pauseVideo];
            }
            weakSelf.mediaPlayer.currentPlaybackTime = weakSelf.mediaPlayer.duration*(pointX/width);
//            NSLog(@"pointx = %f",pointX);
            //NSLog(@"seek=%f",weakSelf.mediaPlayer.duration*(weakSelf.point.x/width));
        };
        [self.displayView addSubview:_animationView];
    }
    return _animationView;
}

- (void)dealloc{
    
    [self unregisterApplicationObservers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCodeFinalVideoComplete" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:YfFileVideoReverseToolLoadStatusSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reverseVideoSucess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reverseVideoFail" object:nil];
    NSLog(@"%s", __FUNCTION__);
}

@end
