//
//  JSUPAlertView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/24.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSUPAlertView.h"

@implementation JSUPAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.sendCodeLab.layer.borderColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5].CGColor;
    self.sendCodeLab.layer.borderWidth = 1.0f;
    
    self.messageCode.layer.borderColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5].CGColor;
    self.messageCode.layer.borderWidth = 1.0f;
    
    self.payPswTF.layer.borderColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5].CGColor;
    self.payPswTF.layer.borderWidth = 1.0f;
}


@end
