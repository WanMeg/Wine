//
//  JSCommentBaskCell2.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCommentBaskCell2 : UITableViewCell

//晒单界面

//textview
@property (weak, nonatomic) IBOutlet UITextView *baskCell2TextView;

//添加图片按钮
@property (weak, nonatomic) IBOutlet UIButton *baskCell2AddBtn;

//字数lab
@property (weak, nonatomic) IBOutlet UILabel *baskCell2NumberLab;

//提示lab
@property (weak, nonatomic) IBOutlet UILabel *baskCell2TipsLab;

//晒单图片
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *baskImageView;

@end
