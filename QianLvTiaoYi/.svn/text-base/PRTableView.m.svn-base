//
//  PRTableView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/25.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRTableView.h"

@implementation PRTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[PRTableView class]] && self.callBack) {
        self.callBack();
    }
    return view;
}

@end
