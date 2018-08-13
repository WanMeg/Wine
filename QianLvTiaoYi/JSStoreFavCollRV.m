//
//  JSStoreFavCollRV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSStoreFavCollRV.h"
#import "JSContact.h"

@implementation JSStoreFavCollRV

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.frame = CGRectMake(0, 0, WIDTH, 65);
    
    self.enterStoreBtn.layer.cornerRadius = 4;
    self.enterStoreBtn.clipsToBounds = YES;
}

@end
