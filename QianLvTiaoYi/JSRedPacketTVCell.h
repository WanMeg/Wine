//
//  JSRedPacketTVCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/27.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NowGetViewBlock)(NSInteger);

@interface JSRedPacketTVCell : UITableViewCell

@property (nonatomic, copy)NowGetViewBlock nowGetBlock;

/*底部view*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *blueBottomView;
@property (weak, nonatomic) IBOutlet UIView *blue2View;

/*活动标题*/
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLab;
/*商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

/*商品描述*/
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLab;

/*红包大小*/
@property (weak, nonatomic) IBOutlet UILabel *redPacketNumberLab;

/*使用条件*/
@property (weak, nonatomic) IBOutlet UILabel *useConditionLab;

/*立即领取view*/
@property (weak, nonatomic) IBOutlet UIView *nowGetView;

/*使用期限*/
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLab;

@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;
@property (weak, nonatomic) IBOutlet UILabel *getNowLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@end
