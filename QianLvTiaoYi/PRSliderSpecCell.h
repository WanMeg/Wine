//
//  PRSliderSpecCell.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/16.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSpecifications.h"
#import "GBTagListView.h"

#define TagListViewWidth 300.0f/375.0f*WIDTH - 71

@interface PRSliderSpecCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tagListView;
@property (nonatomic, strong) GBTagListView *listView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray *values;

@end
