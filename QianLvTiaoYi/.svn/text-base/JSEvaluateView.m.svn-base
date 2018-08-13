//
//  JSEvaluateView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSEvaluateView.h"
#import "JSEvaluateTitleCell.h"
#import "JSEvaluateNoImageCell.h"
#import "JSEvaluateCell.h"

@interface JSEvaluateView()

@end
@implementation JSEvaluateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.topBar = [[NSBundle mainBundle] loadNibNamed:@"JSEvaluateTopBar" owner:self options:nil].firstObject;
        [self addSubview:_topBar];
        self.topBar.selectedIndex = 0;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topBar.frame), WIDTH, CGRectGetHeight(self.frame) - CGRectGetHeight(_topBar.frame)) style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"JSEvaluateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"evaluateCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"JSEvaluateNoImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"evaluateNoImageCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"JSEvaluateTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"titleCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(0, 0, WIDTH, 40);
    self.tableView.frame = CGRectMake(0, CGRectGetHeight(_topBar.frame), WIDTH, CGRectGetHeight(self.frame) - CGRectGetHeight(_topBar.frame));
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *cm = _commentResults.commentList[indexPath.section];
//    + (CGFloat)getHeightWithString:(NSString *)aString withFontSize:(CGFloat)fontSize
    float hight = [WMGeneralTool getHeightWithString:cm.commentContent withFontSize:13];
    if (indexPath.row == 0) {
        return 44;
    } else {
        if (cm.imgUrl.count == 0) {
            return hight + 66;
        } else {
            return hight + 130;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return M_HEADER_HIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _commentResults.commentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *cm = _commentResults.commentList[indexPath.section];
    
    if (indexPath.row == 0) {
        
       JSEvaluateTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:cm.headPortrait] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        cell.titleLabel.text = cm.userName;
        cell.descLabel.text = cm.commentTime;
        
        if([cm.levelLogo rangeOfString:@"null"].location != NSNotFound) {
            cell.levelImgView.image = nil;
        }  else {
            [cell.levelImgView sd_setImageWithURL:[NSURL URLWithString:cm.levelLogo] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        }
        return cell;
    } else {
        
        //根据图片数量 确定使用哪种类型的cell
        if (cm.imgUrl.count == 0) {
            JSEvaluateNoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluateNoImageCell" forIndexPath:indexPath];
            cell.commentLab.text = cm.commentContent;
            cell.specLab.text = cm.goodsSpec;
            cell.payTimeLab.text = [NSString stringWithFormat:@"购买时间: %@", cm.orderConfirmTime];
            for (int i = 0; i < cm.commodityQuality; i ++) {
                UIImageView *img = cell.noStarImages[i];
                img.image = [UIImage imageNamed:@"pjhongxing.png"];
            }
            
            return cell;
        } else {
            JSEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluateCell" forIndexPath:indexPath];
            
            for (int i = 0; i < cm.commodityQuality; i ++) {
                UIImageView *img = cell.starImgViews[i];
                img.image = [UIImage imageNamed:@"pjhongxing.png"];
            }
            
            cell.titleLabel.text = cm.commentContent;
            cell.specLabel.text = cm.goodsSpec;
            
            UIImageView *img1 = cell.imgViews[0];
            UIImageView *img2 = cell.imgViews[1];
            UIImageView *img3 = cell.imgViews[2];
            switch (cm.imgUrl.count) {
                case 1:{
                    [img1 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[0]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                    img2.image = nil;
                    img3.image = nil;
                }
                    break;
                case 2:{
                    [img1 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[0]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                    [img2 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[1]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                    img3.image = nil;
                }
                    break;
                case 3:{
                    
                    [img1 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[0]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                    [img2 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[1]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                    [img3 sd_setImageWithURL:[NSURL URLWithString:cm.imgUrl[2]] placeholderImage:[UIImage imageNamed:@"noimage"]];
                }
                    break;
                    
                default:
                    break;
            }
            
            cell.buyTimeLabel.text = [NSString stringWithFormat:@"购买时间: %@", cm.orderConfirmTime];
            return cell;

        }
    }
}

- (void)setCommentResults:(CommentResultsModel *)commentResults {
    _commentResults = commentResults;
    [_tableView reloadData];
    
    [_topBar updateNumLabeWithIndex:0 num:commentResults.allCount];
    [_topBar updateNumLabeWithIndex:1 num:commentResults.goodsCount];
    [_topBar updateNumLabeWithIndex:2 num:commentResults.centreCount];
    [_topBar updateNumLabeWithIndex:3 num:commentResults.badCount];
    [_topBar updateNumLabeWithIndex:4 num:commentResults.printCount];
}

@end
