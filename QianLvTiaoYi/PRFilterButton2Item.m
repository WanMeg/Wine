//
//  PRFilterButton2Item.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterButton2Item.h"

@implementation PRFilterButton2Item
- (void)awakeFromNib {
    [super awakeFromNib];
    _button.layer.cornerRadius = 3.0f;
    _button.layer.masksToBounds = YES;
    [_button setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

}

- (void)updateButtonUI:(BOOL)isSelected {
    self.picked = isSelected;
    if (self.picked) {
        [_button setBackgroundColor:[UIColor redColor]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [_button setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}
@end
