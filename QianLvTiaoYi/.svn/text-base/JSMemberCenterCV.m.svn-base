//
//  JSMemberCenterCV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSMemberCenterCV.h"
#import "JSContact.h"



@implementation JSMemberCenterCV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
//        self.delegate = self;
        self.dataSource = self;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
            [self addGestureRecognizer:longPress];
        }

        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[JSMemberCenterCVCell class] forCellWithReuseIdentifier:@"item"];
    }
    return self;
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[gesture locationInView:self]];
            if (indexPath) {
                [self beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveMovementTargetPosition:[gesture locationInView: self]];
            break;
        case UIGestureRecognizerStateEnded:
            [self endInteractiveMovement];
            break;
        default:
            [self cancelInteractiveMovement];
            break;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tools.count;    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSMemberCenterCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = _tools[indexPath.row][@"title"];
    cell.imgView.image = [UIImage imageNamed:_tools[indexPath.row][@"image"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSNumber *temp = _tools[sourceIndexPath.item];
    [_tools removeObjectAtIndex:sourceIndexPath.item];
    [_tools insertObject:temp atIndex:destinationIndexPath.item];
    NSString *key = @"";
    if (collectionView.tag == 100) {
        key = [NSString stringWithFormat:@"%@1", TOOLSKEY];
    }else{
        key = [NSString stringWithFormat:@"%@2", TOOLSKEY];
    }
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:_tools forKey:key];
}



/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


@end
