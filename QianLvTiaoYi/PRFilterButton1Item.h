//
//  PRFilterButton1Item.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRFilterButton1Item : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, getter=isPicked) BOOL picked;

- (void)updateButtonUI:(BOOL)isSelected;
@end
