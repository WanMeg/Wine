//
//  JSHomePageADCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSHomePageADCell.h"
#import "JSContact.h"

@interface JSHomePageADCell()
@property (nonatomic, assign) NSInteger idx;
@end
@implementation JSHomePageADCell

- (void)awakeFromNib {
    // Initialization code
    [self createLabelView];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLabels:(NSArray *)labels {
    _labels = labels;
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    _idx = 0;
    TextAd *tAd = _labels[_idx];
    _LabelView1.titleLabel.text = tAd.appGeneralizeTitle;
    _LabelView1.descLabel.text = tAd.appGeneralizeExplain;
    _LabelView1.tagLabel.text = tAd.appGeneralizeLable;
}

- (void)timerAction {
    NSInteger limit = _labels.count;
    CGRect rect =CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, 53, WIDTH-73, 53);
    JSADLabelView *lv = CGRectGetMinY(_LabelView1.frame) ==0 ? _LabelView2 : _LabelView1;
    _idx = _idx + 1 < limit ? _idx + 1 : 0;
    TextAd *tAd = _labels[_idx];
    lv.titleLabel.text = tAd.appGeneralizeTitle;
    lv.descLabel.text = tAd.appGeneralizeExplain;
    lv.tagLabel.text = tAd.appGeneralizeLable;
    
    [UIView animateWithDuration:0.5 animations:^{
        if(CGRectGetMinY(_LabelView1.frame) ==0){
            _LabelView1.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, -53, WIDTH - 73, 53);
            _LabelView2.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, 0, WIDTH - 73, 53);
        }else {
            _LabelView1.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, 0, WIDTH - 73, 53);
            _LabelView2.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, -53, WIDTH - 73, 53);
        }
//        _LabelView1.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, CGRectGetMinY(_LabelView1.frame) - 53, WIDTH - 73, 53);
//        _LabelView2.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, CGRectGetMinY(_LabelView2.frame) - 53, WIDTH - 73, 53);
    } completion:^(BOOL finished) {
        if (_LabelView1.frame.origin.y < 0) {
            _LabelView1.frame = rect;
        }
        if (_LabelView2.frame.origin.y < 0) {
            _LabelView2.frame = rect;
        }
    }];
}

- (void)createLabelView {
    _LabelView1 = [[NSBundle mainBundle] loadNibNamed:@"JSADLabelView" owner:self options:nil].firstObject;
    _LabelView1.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, 0, WIDTH-73, 53);
    [self addSubview:_LabelView1];
    _LabelView2 = [[NSBundle mainBundle] loadNibNamed:@"JSADLabelView" owner:self options:nil].firstObject;
    _LabelView2.frame = CGRectMake(CGRectGetMaxX(_hornIV.frame)+8, 53, WIDTH-73, 53);
    [self addSubview:_LabelView2];
}

@end
