//
//  JSCommentCenterTVCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCommentCenterTVCell : UITableViewCell

//评价中心

//图片
@property (weak, nonatomic) IBOutlet UIImageView *commentCenterHeadImg;

//标题
@property (weak, nonatomic) IBOutlet UILabel *commentCTitleLab;

//信息
@property (weak, nonatomic) IBOutlet UILabel *commentCInfoLab;

//晒单按钮
@property (weak, nonatomic) IBOutlet UIButton *commentCBaskBtn;

@end
