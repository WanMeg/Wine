//
//  JSSearchNavigationBar.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchActionBlock)(NSInteger idx);
typedef void(^StartSearchBlock)(NSString *text);
@interface JSSearchNavigationBar : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic)  IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (copy, nonatomic) SearchActionBlock buttonActionBlock;
@property (copy, nonatomic) StartSearchBlock startSearchBlock;

@property (strong, nonatomic) NSMutableArray *keywords;

+ (id)getHistorySearchKeyword;
+ (void)cleanSearchHistory;
@end
