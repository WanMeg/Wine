//
//  JSCommentCenterTVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCommentCenterTVCell.h"

@implementation JSCommentCenterTVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    _commentCBaskBtn.layer.cornerRadius = 2;
    _commentCBaskBtn.clipsToBounds = YES;
    _commentCBaskBtn.layer.borderWidth = 0.5f;
    _commentCBaskBtn.layer.borderColor = [UIColor redColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
