//
//  JSStoreFavFliterBar.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StoreFavSelectBlock)(NSInteger idx);

@interface JSStoreFavFliterBar : UIView
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *storeFavBottomViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *storeFavLabels;

@property (copy, nonatomic) StoreFavSelectBlock storeFavSelectBlock;

- (void)setStoreFavSelectedIndex:(NSInteger)selectedIndex;

@end
