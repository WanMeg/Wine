//
//  JSShoppingCartCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRSegmentControl.h"

@interface JSShoppingCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet PRSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *pickButton;
@property (weak, nonatomic) IBOutlet UILabel *specLab;

@property (nonatomic, getter=isPicked) BOOL picked;
@end
