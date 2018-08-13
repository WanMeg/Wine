//
//  JSStoreReusableView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/21.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSStoreReusableView.h"
#import "GetBannersData.h"

@interface JSStoreReusableView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *shopScrollView;
@property (nonatomic, strong) NSMutableArray *shopBannerArr;
@property (nonatomic, strong) NSMutableArray *bannerImgArr;

@end
@implementation JSStoreReusableView


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.frame = CGRectMake(0, 0, WIDTH, 160);
    
    
    _shopBannerArr = [NSMutableArray array];
    _bannerImgArr = [NSMutableArray array];
    
    [self configScrollView];
    
}


- (void)configScrollView
{
    CGRect rect = CGRectMake(5, 5, CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-10);
    
    _shopScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusGoodsListBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj)
         {
             [weakSelf.shopBannerArr
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _shopBannerArr)
             {
                 NSString *imgStr = banner.imgUrl;
                 
                 [_bannerImgArr addObject:imgStr];
             }
             
            NSLog(@"----%lu",(unsigned long)self.bannerImgArr.count);
             
             //设置网络图片数组
             _shopScrollView.imageURLStringsGroup = self.bannerImgArr;
         }
     }];
    
    //设置图片视图显示类型
    _shopScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //设置轮播视图的分页控件的显示
    _shopScrollView.showPageControl = YES;
    
    //设置轮播视图分也控件的位置
    _shopScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //当前选中小圆图标的颜色
    _shopScrollView.currentPageDotColor = [UIColor blackColor];
    //未选中的颜色
    _shopScrollView.pageDotColor = [UIColor grayColor];
    
    
    [self addSubview:_shopScrollView];
    
}
@end
