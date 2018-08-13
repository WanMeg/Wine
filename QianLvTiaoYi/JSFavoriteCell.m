//
//  JSFavoriteCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSFavoriteCell.h"
#import "JSContact.h"

@implementation JSFavoriteCell

- (void)awakeFromNib {
    // Initialization code
    _goodsName.preferredMaxLayoutWidth = WIDTH-16;
    self.rightUtilityButtons = [self rightButtons];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor grayColor]};
    
//    NSMutableAttributedString * buttonStr = [[NSMutableAttributedString alloc] initWithString:@"加入购物车" attributes:attributes];
    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] attributedTitle: buttonStr];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"取消收藏"];
    return rightUtilityButtons;
}

@end
