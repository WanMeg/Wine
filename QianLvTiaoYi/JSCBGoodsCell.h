//
//  JSCBGoodsCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCBGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@end
