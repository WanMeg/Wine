//
//  JSAddressPickerView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/11.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSAddressPickerView.h"
#import "Area.h"
#import "JSContact.h"

@implementation JSAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.dataSource = self;
        self.delegate = self;
        self.currentAreaList = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void)setAreaList:(NSArray *)areaList {
    _areaList = areaList;
    [self updateAreaDatasComponent:0 row:0];
    if (self.selectCallBack) {
        self.selectCallBack(_currentAreaList);
    }
}

#pragma mark - Private functions
//更新当前component后面的数据
- (void)updateAreaDatasComponent:(NSInteger)component row:(NSInteger)row{
  
    for (NSInteger i = component; i < 3; i++) {
        NSInteger componentRow = [self selectedRowInComponent:i];
    
//        NSLog(@"%ld++++++", _currentAreaList.count);
        //更新component1的数组
        if(i == 0) {
            if (_areaList && _areaList.count > 0) {
                Area *area = _areaList[componentRow];
                SubModel *sm = [[SubModel alloc] init];
                sm.name = area.name;
                sm.code = area.code;
                _currentAreaList[0] = sm;
                self.secondList = area.subAreaList;
            }else{
                _currentAreaList[0] = [[SubModel alloc] init];
                self.secondList = nil;
            }
        }
        
        //更新component2的数组
        if (i == 1) {
            if ( _secondList && _secondList.count > 0) {
                Area *area = _secondList[componentRow];
                SubModel *sm = [[SubModel alloc] init];
                sm.name = area.name;
                sm.code = area.code;
                _currentAreaList[1] = sm;
                self.thirdList = area.subAreaList;
            }else {
                _currentAreaList[1] = [[SubModel alloc] init];
                self.thirdList = nil;
            }
        }
        
        if (i != 2) {
            //让滑动的component后面的所有component的row回复到0的位置
            [self selectRow:0 inComponent:i+1 animated:NO];
            [self reloadComponent:i+1];
        }else {
            if (_thirdList && _thirdList.count > 0) {
                Area *area = _thirdList[componentRow];
                SubModel *sm = [[SubModel alloc] init];
                sm.name = area.name;
                sm.code = area.code;
                _currentAreaList[2] = sm;
            }else {
                _currentAreaList[2] = [[SubModel alloc] init];
            }
        }
    }
}

#pragma mark - Picker View Datasource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateAreaDatasComponent:component row:row];
    if (self.selectCallBack) {
        self.selectCallBack(_currentAreaList);
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return WIDTH / 3;
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return _areaList.count;
            break;
        case 1:
            return _secondList.count;
            break;
        case 2:
            return _thirdList.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSArray *list;
    switch (component) {
        case 0:
            list = _areaList;
            break;
        case 1:
            list = _secondList;
            break;
        case 2:
            list = _thirdList;
            break;
        default:
            break;
    }
    
    if (list) {
        Area *area = list[row];
        UILabel *textLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH/3, 30.0f)];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        textLabel.text = area.name;
        return textLabel;
    }else{
        return nil;
    }
}

@end
