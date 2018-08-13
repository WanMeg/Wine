//
//  PRSliderSpecCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/16.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRSliderSpecCell.h"
#import "PRSliderCollectionCell.h"
#import "JSContact.h"

@implementation PRSliderSpecCell

- (void)awakeFromNib {
     self.listView = [[GBTagListView alloc] initWithFrame: CGRectMake(0, 0, TagListViewWidth, CGRectGetHeight(_tagListView.frame))];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValues:(NSArray *)values {
    _values = values;
    _listView.buttonTintColor = QLTY_MAIN_COLOR;
    [_listView setTagWithItemCount:values.count fetchString:^NSString *(int index) {
        ProductSpecificationsValue *value = values[index];
        return value.specificationsValue;
    }];
    [_tagListView addSubview:_listView];
}

@end
