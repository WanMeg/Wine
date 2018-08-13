//
//  JSFootprintTVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFootprintTVCell.h"

#import "JSContact.h"

@implementation JSFootprintTVCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.footprintBigImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.footprintBigImage.layer.borderWidth = 0.5f;
}



@end
