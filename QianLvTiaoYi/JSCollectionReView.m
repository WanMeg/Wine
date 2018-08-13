//
//  JSCollectionReView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCollectionReView.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

#import "GetBannersData.h"
@interface JSCollectionReView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *goodsScrollView;
@property (nonatomic, strong) NSMutableArray *goodsBannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImageArray;

@end
@implementation JSCollectionReView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.frame = CGRectMake(0, 0, WIDTH, 152);
    
    _goodsBannerArray = [NSMutableArray array];
    _bannerImageArray = [NSMutableArray array];
    
    [self configScrollView];
}

- (void)configScrollView
{
    CGRect rect = CGRectMake(5, 5, CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-10);
    
    _goodsScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusGoodsListBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj)
         {
             [weakSelf.goodsBannerArray
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _goodsBannerArray)
             {
                 NSString *imgStr = banner.imgUrl;
                 
                 [_bannerImageArray addObject:imgStr];
             }
             
             //设置网络图片数组
             _goodsScrollView.imageURLStringsGroup = self.bannerImageArray;
         }
     }];
    
    //设置图片视图显示类型
    _goodsScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //设置轮播视图的分页控件的显示
    _goodsScrollView.showPageControl = YES;
    
    //设置轮播视图分也控件的位置
    _goodsScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //当前选中小圆图标的颜色
    _goodsScrollView.currentPageDotColor = [UIColor blackColor];
    //未选中的颜色
    _goodsScrollView.pageDotColor = [UIColor grayColor];
    
    
    [self addSubview:_goodsScrollView];
}

@end
