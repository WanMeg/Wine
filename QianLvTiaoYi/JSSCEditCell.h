//
//  JSSCEditCell.h
//  QianLvTiaoYi
//
//  Created by Gollum on 16/4/4.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditCellChangeNumberBlock)(NSInteger num);


@interface JSSCEditCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (copy, nonatomic) EditCellChangeNumberBlock didChangeNumBlock;

- (void)setEditItemsUserInteractionEnabled:(BOOL)enabled ;

@end
