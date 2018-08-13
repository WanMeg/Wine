//
//  JSGoodsFavCollRV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsFavCollRV.h"
#import "GetBannersData.h"

@interface JSGoodsFavCollRV ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *goodsFavScrollView;
@property (nonatomic, strong) NSMutableArray *goodsFavBannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImageArray;

@end

@implementation JSGoodsFavCollRV

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.frame = CGRectMake(0, 0, WIDTH, 160);
    
    
    _goodsFavBannerArray = [NSMutableArray array];
    _bannerImageArray = [NSMutableArray array];
    
    [self configScrollView];
    
}


- (void)configScrollView
{
    CGRect rect = CGRectMake(5, 5, CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-10);
    
    _goodsFavScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusGoodsCollectBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj)
         {
             [weakSelf.goodsFavBannerArray
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _goodsFavBannerArray)
             {
                 NSString *imgStr = banner.imgUrl;
                 
                 [_bannerImageArray addObject:imgStr];
             }
             
//             NSLog(@"----%lu",(unsigned long)self.bannerImageArray.count);
             
             //设置网络图片数组
             _goodsFavScrollView.imageURLStringsGroup = self.bannerImageArray;
         }
     }];
    
    //设置图片视图显示类型
    _goodsFavScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //设置轮播视图的分页控件的显示
    _goodsFavScrollView.showPageControl = YES;
    
    //设置轮播视图分也控件的位置
    _goodsFavScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //当前选中小圆图标的颜色
    _goodsFavScrollView.currentPageDotColor = [UIColor blackColor];
    //未选中的颜色
    _goodsFavScrollView.pageDotColor = [UIColor grayColor];
    
    
    [self addSubview:_goodsFavScrollView];
    
//    _goodsFavScrollView = [[SDCycleScrollView alloc] initWithFrame:rect];
//    [self addSubview:_goodsFavScrollView];
//
//    //是否循环轮播
//    //_goodsFavScrollView.infiniteLoop = NO;
//    
//    //图片轮播时间
//    _goodsFavScrollView.autoScrollTimeInterval = 2.0;
//    
//    //当前选中小圆图标的颜色
//    _goodsFavScrollView.currentPageDotColor = [UIColor orangeColor];
//    //未选中的颜色
//    _goodsFavScrollView.pageDotColor = [UIColor grayColor];
//    
//    //设置请求网络图片
//    [_goodsFavScrollView setImageURLStringsGroup:@[@"http://pic2.ooopic.com/10/60/39/20b1OOOPIC18.jpg",@"http://pic2.ooopic.com/10/78/82/94b1OOOPIC84.jpg",@"http://img.68design.net/art/20091203/zm0AFosvugACrSd.jpg",@"http://img.68design.net/art/20091203/zm0AFosvugACrSd.jpg"]];
}


#pragma mark - 代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //NSLog(@"%ld",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    //NSLog(@"%ld",index);
}

@end
