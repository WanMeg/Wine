//
//  JSGoodsFavoFliterBar.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GoodsFavSelectBlock)(NSInteger idx);

@interface JSGoodsFavoFliterBar : UIView
//底部view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *goodsFavBottomViews;

//view上的label
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *goodsFavLabels;

@property (copy, nonatomic) GoodsFavSelectBlock goodsFavSelectBlock;

- (void)setGoodsFavSelectedIndex:(NSInteger)selectedIndex;

@end
