//
//  JSPickerView.h
//  WineMembers
//
//  Created by JiaSheng on 16/5/28.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSString* (^PickerViewFetchContent)(NSInteger compment, NSInteger row);
typedef NSUInteger (^PickerViewFetchCount)(NSInteger compment);
typedef void (^PickerViewSelectCallBack)(NSArray *areaInfos);

@interface JSPickerView : UIView<NSCoding,UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pickerCancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickerConfirmBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *addressPickerView;

@property (nonatomic, strong) NSArray *areaList;
@property (nonatomic, strong) NSArray *secondList;
@property (nonatomic, strong) NSArray *thirdList;

@property (nonatomic, strong) NSMutableArray *currentAreaList;

@property (nonatomic, copy) PickerViewSelectCallBack selectCallBack;

@end
