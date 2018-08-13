//
//  PRAddressSliderVC.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/6.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PRASCCallBackBlock)(NSInteger selectedIndex);
typedef NSString *(^PRAGetDataBlock)(NSUInteger currentIndex);

@interface PRAddressSliderVC : UIViewController
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSUInteger totals;

- (instancetype)initWithTotals:(NSUInteger)totals header:(UIView *)header getData:(PRAGetDataBlock)getData callBack:(PRASCCallBackBlock)callBack;

@end