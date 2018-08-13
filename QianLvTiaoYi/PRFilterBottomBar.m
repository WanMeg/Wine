//
//  PRFilterBottomBar.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterBottomBar.h"

@implementation PRFilterBottomBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        [self createButtons];
    }
    return self;
}

- (void)createButtons
{
    _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _configBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _resetBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
    _configBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)/2, 0, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
    
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [_configBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [_resetBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_configBtn setBackgroundColor:[UIColor colorWithRed:0xf1/255.0 green:0x31/255.0 blue:0x2f/255.0 alpha:1.0]];
    [_resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:_resetBtn];
    [self addSubview:_configBtn];
        
}
@end
