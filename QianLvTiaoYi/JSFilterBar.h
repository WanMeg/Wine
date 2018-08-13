//
//  JSFilterBar.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSContact.h"

typedef void(^SelectBlock)(NSInteger idx);
@interface JSFilterBar : UIView

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *backViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;

@property (copy, nonatomic) SelectBlock selectBlock;
- (void)setSelectedIndex:(NSInteger)selectedIndex;


@property (weak, nonatomic) IBOutlet UIImageView *categoryPriceImg;


@end
