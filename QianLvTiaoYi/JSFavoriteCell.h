//
//  JSFavoriteCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@interface JSFavoriteCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
//@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
