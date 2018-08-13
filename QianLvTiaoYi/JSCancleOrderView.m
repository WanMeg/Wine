//
//  JSCancleOrderView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCancleOrderView.h"

@implementation JSCancleOrderView

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
    
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
    
    self.cancelReasonTV.delegate = self;
    self.cancelReasonTV.layer.cornerRadius = 4.0f;
    self.cancelReasonTV.clipsToBounds = YES;
    self.cancelReasonTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelReasonTV.layer.borderWidth = 1.0f;
}


@end
