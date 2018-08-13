//
//  JSGuessLikeCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSGuessLikeCell.h"
#import "JSGuessLikeCollectionCell.h"
#import "JSContact.h"

@implementation JSGuessLikeCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,CGRectGetHeight(self.frame))collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[JSGuessLikeCollectionCell class] forCellWithReuseIdentifier:@"goodsItem"];
        [self addSubview:self.collectionView];
        self.collectionView.pagingEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Collection view delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度：减去间隔 除以4个Item，高度：缩放比例 减去底部view高度 减去边距间隔 除以2个Item
    return CGSizeMake((WIDTH - 4.5) / 3, CELL_HEIGHT_(100));
}


#pragma mark - collection View Data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _goodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSGuessLikeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsItem" forIndexPath:indexPath];
    Goods *goods = _goodsList[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    return cell;
}

@end
