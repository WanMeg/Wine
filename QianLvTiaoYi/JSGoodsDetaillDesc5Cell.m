//
//  JSGoodsDetaillDesc5Cell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsDetaillDesc5Cell.h"

@implementation JSGoodsDetaillDesc5Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.text = @"产品规格";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
