//
//  JSFootprintTVCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@interface JSFootprintTVCell : UITableViewCell

// 浏览记录


//酒图片
@property (weak, nonatomic) IBOutlet UIImageView *footprintBigImage;
//酒名称
@property (weak, nonatomic) IBOutlet UILabel *footprintNameLab;
//子标题
@property (weak, nonatomic) IBOutlet UILabel *footprintSubTitleLab;
//批发价
@property (weak, nonatomic) IBOutlet UILabel *footprintPiFaLab;
//零售价
@property (weak, nonatomic) IBOutlet UILabel *footprintRetailLab;
//销量
@property (weak, nonatomic) IBOutlet UILabel *footprintSalesLab;



@property (weak, nonatomic) IBOutlet UIButton *addShopCartBtn;


@end
