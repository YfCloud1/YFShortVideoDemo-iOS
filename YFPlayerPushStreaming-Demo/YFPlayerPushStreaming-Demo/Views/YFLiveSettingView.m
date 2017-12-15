//
//  YFLiveSettingView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/5/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFLiveSettingView.h"
#import "Masonry.h"
#import "YFFuncView.h"
#import "YFFunModel.h"
@interface YFLiveSettingView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
@implementation YFLiveSettingView

- (instancetype)initWithCallBack:(void(^)(UIButton *icon,UIButton *btn))callBack{
    if (self = [super init]) {
        
        __weak typeof(self)weakSelf = self;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat viewW = (screenSize.width - 5 *30)/4;
        CGFloat viewH = viewW + 20;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        
        NSInteger isVertical = [[NSUserDefaults standardUserDefaults] integerForKey:@"isVertical"];
        CGFloat marginX = 0;
        if (isVertical) {
            marginX = 30;
            scrollView.contentSize = CGSizeMake(2*screenSize.width, 300);
        }else{
            marginX = (screenSize.height - 4*47)/5;
            scrollView.contentSize = CGSizeMake(2*screenSize.height, 300);
        }
        
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
       
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
        
        for (int i = 0; i < self.dataArr.count; ++i) {
            int col_count = i%4;
            int row_count = i/4;
            
            YFFunModel * model = self.dataArr[i];
            YFFuncView * funcView = [[YFFuncView alloc] initWithIconNomal:model.iconNomal andSelected:model.iconSelected andTheme:model.title];
            if (callBack) {
                funcView.callBack = callBack;
            }
            [scrollView addSubview:funcView];
            if (i<8) {
                
                CGRect frame = CGRectMake(marginX + col_count*(marginX + viewW), 30 + row_count*(30 + viewW), viewW, viewH);
                funcView.frame = frame;
            }else{
                
                if (isVertical) {
                    CGRect frame = CGRectMake(marginX + col_count*(marginX + viewW) + screenSize.width, 20, viewW, viewH);
                    funcView.frame = frame;
                }else{
                    CGRect frame = CGRectMake(marginX + col_count*(marginX + viewW) + screenSize.height, 20, viewW, viewH);
                    funcView.frame = frame;
                }
            }
        }
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 2;
        pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-73);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:87/255.0 green:128/255.0 blue:127/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(marginX);
            make.right.equalTo(weakSelf).offset(-marginX);
            make.bottom.equalTo(weakSelf).offset(-67);
            make.height.mas_equalTo(2);
        }];
        
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [cancel addTarget:self action:@selector(cancelLiveSetEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
        
    }
    return self;
}

- (void)cancelLiveSetEvent:(UIButton *)sender{
    if (self.cancel) {
        self.cancel();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得x方向的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 计算✌️号
    NSInteger page = offsetX / scrollView.frame.size.width + 0.5;
    self.pageControl.currentPage = page;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"美颜"},@{@"iconNomal":@"ar1",@"iconSelected":@"ar2",@"title":@"AR直播"},@{@"iconNomal":@"shuiyin",@"iconSelected":@"shuiyin2",@"title":@"水印"},@{@"iconNomal":@"erfan3",@"iconSelected":@"erfan",@"title":@"耳返/关"},@{@"iconNomal":@"jiangzao",@"iconSelected":@"jiangzao3",@"title":@"降噪/开"},@{@"iconNomal":@"mirror",@"iconSelected":@"mirror3",@"title":@"镜像/开"},@{@"iconNomal":@"h.265",@"iconSelected":@"h.2652",@"title":@"H.265"},@{@"iconNomal":@"bitrate",@"iconSelected":@"bitrate2",@"title":@"自适应码率"},@{@"iconNomal":@"jingyin",@"iconSelected":@"jingyin3",@"title":@"静音/关"},@{@"iconNomal":@"rizhi3",@"iconSelected":@"rizhi",@"title":@"日志/关"}];
        
        NSMutableArray * arr2 = [NSMutableArray array];
        for (NSDictionary *dict in _dataArr) {
            YFFunModel *model = [YFFunModel funcModelWithDict:dict];
            [arr2 addObject:model];
        }
        _dataArr = arr2;
    }
    return _dataArr;
}

@end
