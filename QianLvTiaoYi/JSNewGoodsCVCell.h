//
//  JSNewGoodsCVCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSNewGoodsCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *upNewGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodsPFLab;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodsLSLab;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodsXLLab;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodsPLlab;

@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;

@end
