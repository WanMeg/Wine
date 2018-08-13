//
//  JSCrowdInfoCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/5.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCrowdInfoCell.h"

@implementation JSCrowdInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _specLab.layer.borderColor = [UIColor redColor].CGColor;
    _specLab.layer.cornerRadius = 2;
    _specLab.clipsToBounds = YES;
    _specLab.layer.borderWidth = 0.5f;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    _crowdProgress.transform = transform;
    _crowdProgress.layer.cornerRadius = 2.0;
    _crowdProgress.clipsToBounds = YES;
    _crowdProgress.layer.borderColor = [UIColor redColor].CGColor;
    _crowdProgress.layer.borderWidth = 0.2f;
    
    
    _numLab = [[UILabel alloc]init];
    _numLab.textColor = [UIColor redColor];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.backgroundColor = [UIColor whiteColor];
    _numLab.layer.borderWidth = 0.4f;
    _numLab.layer.borderColor = [UIColor redColor].CGColor;
    _numLab.layer.cornerRadius = 2.0f;
    _numLab.clipsToBounds = YES;
    _numLab.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:_numLab];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
