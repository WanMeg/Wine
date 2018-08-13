//
//  JSSearchNavigationBar.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSearchNavigationBar.h"


#define SEA_KEYWORD @"SearchKeywords"
#define MAX_Record 10       //最大历史记录条数
#define MAX_LENGTH 20  //最大输入字符长度

@implementation JSSearchNavigationBar


- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.cornerRadius = 3.0f;
    _backView.layer.masksToBounds = YES;
    _searchTF.delegate = self;
    _rightButton.tag = 1;
}

- (IBAction)buttonActions:(UIButton *)sender {
    if (_buttonActionBlock) {
        _buttonActionBlock(sender.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //忽略退格键 搜索事件
    if ([string isEqualToString:@""] || [string isEqualToString:@"\n"]) {
        return YES;
    }
    //限制最大输入长度
    if ([textField.text stringByAppendingString:string].length < MAX_LENGTH) {
        return YES;
    }else {
        textField.text = [[textField.text stringByAppendingString:string] substringToIndex:MAX_LENGTH];
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    if (_startSearchBlock)
    {
        _startSearchBlock(textField.text);
    }
    [self saveSearchKeyWord];
    return YES;
}

+ (id)getHistorySearchKeyword {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:SEA_KEYWORD];
}

/**
 *  清除历史记录
 *
 */
+ (void)cleanSearchHistory{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:SEA_KEYWORD];
}

- (void)saveSearchKeyWord {
    _keywords = [NSMutableArray arrayWithArray:[JSSearchNavigationBar getHistorySearchKeyword]];
    if (_keywords == nil) {
        _keywords = [NSMutableArray arrayWithObject:_searchTF.text];
    } else {
        
        //过滤掉重复关键字
        [_keywords enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:_searchTF.text]) {
                [_keywords removeObjectAtIndex:idx];
            }
        }];
        
        //限定历史记录长度
        if (_keywords.count >= MAX_Record) {
            [_keywords removeLastObject];
        }
        
        //判断搜索框没有输入文字 或者 输入空格搜索时，搜索记录为空
        if ([WMGeneralTool isEmpty:_searchTF.text]) {
            _searchTF.text = @"";
            return;
        } else {
            [_keywords insertObject:_searchTF.text atIndex:0];
        }
    }
    //缓存历史记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSArray arrayWithArray:_keywords] forKey:SEA_KEYWORD];
    
    _searchTF.text = @"";
//    [_tableView reloadData];
    [self endEditing:YES];
}




@end
