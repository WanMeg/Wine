//
//  PRSegmentControl.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PRSegmentControl;
@protocol PRSegmentControlDelegate <NSObject>
- (void)didBeginEditingWithSegmentControl: (PRSegmentControl *)segmentControl;
- (void)segmentControl: (PRSegmentControl *)segmentControl changedValue: (NSUInteger)value;
@end

IB_DESIGNABLE
@interface PRSegmentControl : UIControl

@property (nonatomic) IBInspectable NSUInteger maxValue;             /**<最大值*/
@property (nonatomic) IBInspectable NSUInteger minValue;     /**<最小值*/
@property (nonatomic) IBInspectable NSUInteger currentValue;         /**<当前值*/
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *tintColor;
@property (nonatomic, strong) IBInspectable UIColor *fontColor;
@property (nonatomic) IBInspectable NSUInteger fontSize;

@property(nonatomic, weak) id<PRSegmentControlDelegate> delegate;
@end
