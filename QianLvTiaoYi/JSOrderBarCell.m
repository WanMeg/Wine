//
//  JSOrderBarCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSOrderBarCell.h"
#import "JSContact.h"

@implementation JSOrderBarCell

- (void)awakeFromNib {
    // Initialization code
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.borderColor = [UIColor redColor].CGColor;
    self.rightButton.layer.cornerRadius = 4;
    self.rightButton.clipsToBounds = YES;
    
    self.cancelButton.layer.borderWidth = 0.5f;
    self.cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setupButtonsWithStatus:(NSArray *)statusTitles{
   NSUInteger count = statusTitles.count;
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (count > idx) {
//            obj.layer.cornerRadius = 5;
//            obj.layer.masksToBounds = YES;
            obj.layer.borderColor = [QLTY_MAIN_COLOR CGColor];
            obj.layer.borderWidth = 0.5f;
            obj.hidden = NO;
            [obj setTitle:statusTitles[idx] forState:UIControlStateNormal];
        }else{
            obj.hidden = YES;
        }
    }];
}

@end
