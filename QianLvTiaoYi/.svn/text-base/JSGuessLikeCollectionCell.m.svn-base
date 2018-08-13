//
//  JSGuessLikeCollectionCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSGuessLikeCollectionCell.h"

@implementation JSGuessLikeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
