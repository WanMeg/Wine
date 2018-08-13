//
//  JSCAGoodsItem.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCAGoodsItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wholesalePrice;
@property (weak, nonatomic) IBOutlet UILabel *retailPrice;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;

@end
