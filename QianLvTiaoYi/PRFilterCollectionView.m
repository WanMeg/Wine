//
//  PRFilterCollectionView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterCollectionView.h"
#import "PRFilterButton1Item.h"
#import "PRFilterButton2Item.h"
#import "JSContact.h"

@interface PRFilterCollectionView()
@property (nonatomic, strong) NSMutableArray *Pickeditems;

@end

@implementation PRFilterCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    [self setupCollectionItems];
}

- (void)setupCollectionItems {
    UINib *nib1 = [UINib nibWithNibName:@"PRFilterButton1Item" bundle:[NSBundle mainBundle]];
    UINib *nib2 = [UINib nibWithNibName:@"PRFilterButton2Item" bundle:[NSBundle mainBundle]];
    [self registerNib:nib1 forCellWithReuseIdentifier:@"button1Item"];
    [self registerNib:nib2 forCellWithReuseIdentifier:@"button2Item"];
}

- (void)updateDatasWithCellStyle:(PRFilterCollectionViewCellStyle)style sectionCount:(NSInteger)sectionCount fetchText:(FetchTextBlcok)fetchTextBlock
{
    _sectionCount = sectionCount;
    _fetchTextBlock = fetchTextBlock;
    _style = style;
    [self reloadData];
}

#pragma mark CollectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"点击section:%ld,  item:%ld", collectionView.tag, indexPath.item);
    //item点击事件回调
    if (_selectedBlock) _selectedBlock([NSIndexPath indexPathForItem:indexPath.item inSection:collectionView.tag]);
        if (_style == PRFilterCollectionViewCellStroke)
     {
         PRFilterButton1Item *item = (PRFilterButton1Item *)[self cellForItemAtIndexPath:indexPath];
         [item updateButtonUI:!item.isPicked];
     }else {
         PRFilterButton2Item *item = (PRFilterButton2Item *)[self cellForItemAtIndexPath:indexPath];
         [item updateButtonUI:!item.isPicked];
     }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sectionCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH - 80) / 3, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_style == PRFilterCollectionViewCellStroke)
    {
        PRFilterButton1Item *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"button1Item" forIndexPath:indexPath];
        if (_fetchTextBlock)
        {
            NSDictionary *result = _fetchTextBlock(indexPath.item);
            NSString *title = result[@"text"];
            NSNumber *isSelected = result[@"isSelected"];
            [item updateButtonUI: isSelected.boolValue];
            item.button.titleLabel.text = title;
            [item.button setTitle:title forState:UIControlStateNormal];
        }else
        {
            item.button.titleLabel.text = @"";
            [item.button setTitle:@"" forState:UIControlStateNormal];
        }
        
        return item;
        
    }else
    {
         PRFilterButton2Item *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"button2Item" forIndexPath:indexPath];
        
        if (_fetchTextBlock)
        {
            NSDictionary *result = _fetchTextBlock(indexPath.item);
            NSString *title = result[@"text"];
            NSNumber *isSelected = result[@"isSelected"];
            [item updateButtonUI: isSelected.boolValue];
            item.button.titleLabel.text = title;
            [item.button setTitle:title forState:UIControlStateNormal];
        }else
        {
            item.button.titleLabel.text = @"";
            [item.button setTitle:@"" forState:UIControlStateNormal];
        }
        
        return item;
    }
}
@end
