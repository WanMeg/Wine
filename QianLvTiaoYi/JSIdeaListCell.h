//
//  JSIdeaListCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSIdeaListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ideaPeople;
@property (weak, nonatomic) IBOutlet UILabel *ideaTime;
@property (weak, nonatomic) IBOutlet UILabel *ideaContent;

@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@end
