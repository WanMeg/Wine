//
//  JSCategoryCV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/13.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSCategoryCV.h"
#import "JSCollectionHeaderView.h"
#import "JSContact.h"
#import "JSCategoryCVCell.h"

@implementation JSCategoryCV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    
//    [self registerClass:[JSCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    
}

#pragma mark - <UICollectionViewDataSource>


//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        NSString *CellIdentifier = @"header";
        //从缓存中获取 Headercell
        JSCollectionHeaderView  *header = (JSCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //标题
        header.titleLabel.text = ((CategoryInfo *)_categoryList[indexPath.section]).categoryName;
        
        //banner图
        if (WIDTH == 320) {
            _bannerImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, -75, WIDTH - 88, 70)];

        } else {
            _bannerImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, -75, WIDTH - 88 - 10, 70)];
        }
        [_bannerImage sd_setImageWithURL:[NSURL URLWithString:_categoryBanner] placeholderImage:[UIImage imageNamed:@"noimage"]];
        [self addSubview:_bannerImage];
        
        return header;

    } else {
        return nil;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _categoryList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((CategoryInfo *)(_categoryList[section])).childrenCategorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSCategoryCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryItem" forIndexPath:indexPath];
    CategoryInfo *info = _categoryList[indexPath.section];
    CategoryInfo *info3 = info.childrenCategorys[indexPath.row];
    
    cell.titleLabel.text = info3.categoryName;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:info3.icon] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    return cell;
}
@end
