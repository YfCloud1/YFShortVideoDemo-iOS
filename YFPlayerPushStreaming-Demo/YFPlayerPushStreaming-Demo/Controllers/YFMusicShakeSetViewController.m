//
//  YFMusicShakeSetViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 5/18/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFMusicShakeSetViewController.h"
#import "YFMusicShakeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface YFMusicShakeSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;

@end

@implementation YFMusicShakeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"short-bg2"]];
    [self.tableView  setSeparatorColor:[UIColor colorWithRed:17/255.0 green:83/255.0 blue:118/255.0 alpha:1]];
    
    self.tableView.dataSource=self;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];

    NSArray *array = [NSArray arrayWithObjects:@"creep.mp3",@"dongdongdong.mp3",@"lalala.mp3",@"zalebaba.mp3",@"xiaoxingyun.mp3",@"Can'tComplain.mp3",@"ChooseYoursSeeds.mp3",@"DeepDownLow.mp3",@"EyesClosed.mp3",@"Holiday.mp3",@"HulaHoop.mp3",@"In2.mp3",@"KeepMeFromYou.mp3",@"MakeMeFeel.mp3",@"Mimimi.mp3",@"OntheFloor.mp3",@"reallywant.mp3",@"RockThatBody.mp3",@"Sway.mp3",@"TALKINGSHITFREESTYLE.mp3",@"YoulostMe.mp3",@"不服来抖.mp3",@"当你打开膨胀的薯片袋子.mp3",@"魔性笑声.mp3",@"小青蛙.mp3",nil];
    self.listData = array;
    [self authCameraLicence];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)authCameraLicence{
    
    [self setPhotoConfig];
    
    //    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            //许可对话没有出现，发起授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    //许可完成
                    NSLog(@"第一次开启授权。。");
                }
                
            }];
            break;
        case AVAuthorizationStatusAuthorized:{
            //已经开启过授权了
            NSLog(@"开启过授权了");
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioStatus) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                NSLog(@"第一次开启麦克风");
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            NSLog(@"开启过麦克风");
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
    
    
    
}

- (void)setPhotoConfig{
    
    //相册权限
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied)
    {
        // 无权限
        // do something...
        [self popMessageView:@"请开启相册权限"];
    }

    //用户未做选择
    if (status == ALAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    
                }else{
                    [self popMessageView:@"请打开相册权限"];
                }
            });
        }];
    }
}

- (void)popMessageView:(NSString *)meg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:meg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listData[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YFMusicShakeViewController *vc = [[YFMusicShakeViewController alloc] init];
    
    vc.musicName = self.listData[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

//- (void)exitMusicSetShake:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (UIButton *)exitBtn{
//    if (!_exitBtn) {
//        _exitBtn = [[UIButton alloc] init];
//        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
//        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
//        [_exitBtn addTarget:self action:@selector(exitMusicSetShake:) forControlEvents:UIControlEventTouchUpInside];
//        CGSize size = [UIScreen mainScreen].bounds.size;
//        _exitBtn.frame = CGRectMake(size.width - 57, 20, 47, 47);
//    }
//    return _exitBtn;
//}

@end
