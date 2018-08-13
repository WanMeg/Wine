//
//  JSSCShopCell.h
//  QianLvTiaoYi
//
//  Created by Gollum on 16/4/3.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSSCShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stroeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, getter=isPicked) BOOL picked;
@end
