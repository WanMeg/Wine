//
//  JSAdressListCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSAdressListCell.h"
#import "JSContact.h"

@implementation JSAdressListCell

- (void)awakeFromNib {
    // Initialization code
    _adressLabel.preferredMaxLayoutWidth = WIDTH - 48;
    _editButton.layer.borderColor = [UIColor grayColor].CGColor;
    _editButton.layer.borderWidth = 0.5f;
    _editButton.layer.cornerRadius = 4;
    _editButton.clipsToBounds = YES;
    
    _deleteButton.layer.borderColor = [UIColor grayColor].CGColor;
    _deleteButton.layer.borderWidth = 0.5f;
    _deleteButton.layer.borderWidth = 0.5f;
    _deleteButton.layer.cornerRadius = 4;
    
    _lindeHeight.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
