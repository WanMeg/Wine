//
//  JSCommitTotalCell.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/25.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCommitTotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *finallyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPrice;

@end
