//
//  JSSelectCommentTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/5.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSSelectCommentTVC : UITableViewController

@property (nonatomic,copy) NSString *selectOrderId;
@property (nonatomic, strong) NSMutableArray *selectGoodsCommentArray;
@property (nonatomic,copy) NSString *selectGoodsImg;
@end
