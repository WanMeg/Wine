//
//  JSAddressPickerView.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/11.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSString* (^PickerViewFetchContent)(NSInteger compment, NSInteger row);
typedef NSUInteger (^PickerViewFetchCount)(NSInteger compment);
typedef void (^PickerViewSelectCallBack)(NSArray *areaInfos);

@interface JSAddressPickerView : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *areaList;
@property (nonatomic, strong) NSArray *secondList;
@property (nonatomic, strong) NSArray *thirdList;

@property (nonatomic, strong) NSMutableArray *currentAreaList;

@property (nonatomic, copy) PickerViewSelectCallBack selectCallBack;
@end
