//
//  PRSliderController.h
//  ELLife
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSpecifications.h"
#import "Product.h"


typedef void(^PRSCCallBackBlock)(NSArray *selectedItems, NSInteger quantity);
typedef id (^getDataBlock)(NSUInteger currentIndex);
typedef void(^SliderControllerAddCartCallBack)();

typedef Product *(^PRSCGetProduct)();
//typedef NSString *(^PRSCfetchImageUrl)();

@interface PRSliderController : UIViewController
@property(nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSUInteger currentQuantity;
@property(nonatomic, copy) SliderControllerAddCartCallBack addCartCallBack;
@property(nonatomic, copy) PRSCGetProduct fetchProduct;
@property(nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *pifaPrice;
@property (nonatomic, copy) NSString *lingsPrice;
@property (nonatomic, assign) BOOL isGroupActivity;


- (instancetype)initWithTotals:(NSUInteger)totals header:(UIView *)header getData:(getDataBlock)getData callBack:(PRSCCallBackBlock)callBack;
@end
