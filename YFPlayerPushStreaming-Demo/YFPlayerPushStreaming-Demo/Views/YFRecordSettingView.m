//
//  YFRecordSettingView.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 4/2/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFRecordSettingView.h"
#import "Masonry.h"
#import "YFFuncView.h"
#import "YFFunModel.h"
#define NewSubViewCount 3
@interface YFRecordSettingView ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation YFRecordSettingView

- (instancetype)initWithCallBack:(void(^)(UIButton *icon,UIButton *btn))callBack{
    if (self = [super init]) {
        __weak typeof(self)weakSelf = self;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat marginX = 0;
        CGFloat marginY = 30;
        NSInteger isVertical = [[NSUserDefaults standardUserDefaults] integerForKey:@"isVertical"];
        if (isVertical) {
            marginX = 30;
        }else{
            marginX = (screenSize.height - 4*47)/5;
        }
        
        CGFloat viewW = (screenSize.width - 5 * 30)/4;
        CGFloat viewH = viewW + 20;
        
        int colCount = 4;
        for (int i = 0; i < NewSubViewCount; i++) {
            
            int col_count = i%colCount;
            int row_count = i/colCount;
            
            YFFunModel *model = self.dataArr[i];
            YFFuncView *funcView = [[YFFuncView alloc] initWithIconNomal:model.iconNomal andSelected:model.iconSelected andTheme:model.title];
            if (callBack) {
                funcView.callBack = callBack;
            }
            [self addSubview:funcView];
            [funcView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf).offset(marginX + col_count*(marginX + viewW));
                make.top.equalTo(weakSelf).offset(marginY + row_count*(marginY + viewH));
                make.size.mas_equalTo(CGSizeMake(viewW, viewH));
            }];
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:87/255.0 green:128/255.0 blue:127/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(20);
            make.right.equalTo(weakSelf).offset(-20);
            make.bottom.mas_equalTo(-67);
            make.height.mas_equalTo(2);
        }];
        
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [cancel addTarget:self action:@selector(didClickRecordSetCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
        
    }
    return self;
}

- (void)didClickRecordSetCancel:(UIButton *)sender{
    
    if (self.cancel) {
        self.cancel();
    }
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"iconNomal":@"beauty",@"iconSelected":@"beauty22",@"title":@"美颜"},@{@"iconNomal":@"ar1",@"iconSelected":@"ar2",@"title":@"AR直播"},@{@"iconNomal":@"ar1",@"iconSelected":@"ar2",@"title":@"滤镜"}];
        
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
