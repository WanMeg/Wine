//
//  JSEvaluateTopBar.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSContact.h"

typedef void(^EvaluateCallBackBlock)(NSUInteger selectedIndex);

@interface JSEvaluateTopBar : UIView
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *actionViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numLabels;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (copy, nonatomic) EvaluateCallBackBlock evaluateCallBack;

- (void)updateNumLabeWithIndex:(NSInteger)idx num:(NSInteger)num;
- (void)evaluateTopBarDidChangeSelectedIndex: (EvaluateCallBackBlock)callBackBlock;
@end
