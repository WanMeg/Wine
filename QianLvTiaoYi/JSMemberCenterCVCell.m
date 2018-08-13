//
//  JSMemberCenterCVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSMemberCenterCVCell.h"

@implementation JSMemberCenterCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.textLabel];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
 
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(0, (CGRectGetHeight(self.frame) + 15) / 2, CGRectGetWidth(self.frame), 30);
    _imgView.frame = CGRectMake((CGRectGetWidth(self.frame) - 32) / 2, (CGRectGetHeight(self.frame) - 45) / 2, 32, 32);
}


@end
