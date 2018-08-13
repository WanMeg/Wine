//
//  Goods.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "Goods.h"

@implementation Goods
+ (NSMutableArray *)creatTempGoodsListWithCount: (int)count
{
    NSMutableArray *list = [NSMutableArray array];
    NSArray * imgUrls = @[@"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151013162330688.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151014134208625.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151015162613203.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151014094113469.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151014142609344.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151020172432937.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151023144751710.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151023145109179.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151014133843407.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151023142844632.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151022172307843.png",
                          @"ttp://admin.qlnxw.com/uploadimg_thum/products/proimg/20151013170517750.png"];
    for (int i = 0; i<count;i++ )
    {
        Goods * goods = [[Goods alloc] init];
        goods.goodsId = [NSString stringWithFormat:@"a-%d",i];
        goods.name = [NSString stringWithFormat:@"15秋季新款真皮圆头擦色短靴复古磨砂牛皮平底单靴短筒裸靴女鞋潮【%d】",i];
        goods.imgUrl = imgUrls[i];
//        goods.goodsPrice = [NSString stringWithFormat:@"%d69.00",i+1];
        [list addObject:goods];
    }
    return list;
}
@end
