//
//  PRFilterExtensionCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterExtensionCell.h"

@implementation PRFilterExtensionCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)buttonAction:(UIButton *)sender
{
    self.expand = !self.isExpand;
    [self updateArrowImageViewWithIsSelected:self.isExpand];
    if (_expandActionBlock) {
        _expandActionBlock(self.isExpand);
    }
}

- (void)updateArrowImageViewWithIsSelected:(BOOL)isSelected{
    if (isSelected) {
        _arrowIV.image = [UIImage imageNamed:@"arrow_up"];
    }else {
        _arrowIV.image = [UIImage imageNamed:@"arrow_down"];
    }
}

- (void)updateDatasWithCount:(NSInteger)count fetchTextBlock:(FetchTextBlcok)fetchTextBlock {
    if (self.isExpand) {
         [_collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:count fetchText:fetchTextBlock];
    }else {
        [_collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:3 fetchText:fetchTextBlock];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
