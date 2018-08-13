//
//  JSPSTransferTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/26.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSPSTransferTVC : UITableViewController
@property (nonatomic, assign) BOOL isRecharge;//判断是否是充值
@property (nonatomic, copy) NSString *transferOrderId;
@property (nonatomic, copy) NSString *xxzfMergeNom;
@end
