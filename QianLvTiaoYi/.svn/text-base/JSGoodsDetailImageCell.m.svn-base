//
//  JSGoodsDetailImageCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSGoodsDetailImageCell.h"
#import "JSContact.h"


@implementation JSGoodsDetailImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =   [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _scrollView.autoScroll = NO;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//        cycleScrollView2.delegate = self;
        //            cycleScrollView2.titlesGroup = titles;
        _scrollView.pageDotColor = [UIColor grayColor];
        _scrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
