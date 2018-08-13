//
//  JSContact.h
//  ELLife
//
//  Created by admin on 15/8/6.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#ifndef ELLife_JSContact_h
#define ELLife_JSContact_h
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#import "PRUitls.h"
#import "ModelHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
/**
    __weak __typeof(self) weakSelf = self; weakSelf的写法
 */
//APPDELEGATE 实例
#define APPDELEGATE [[UIApplication sharedApplication] delegate]

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  
#define CELL_HEIGHT_(designHeight) WIDTH / 375 * designHeight

#define QLTY_MAIN_COLOR [UIColor colorWithRed:0xFA/255.0f  green:0x40/255.0f  blue:0x3E/255.0f alpha:1.0]

#define QLTY_RED_COLOR [UIColor colorWithRed:0xd8/255.0f  green:0x00/255.0f  blue:0x00/255.0f alpha:1.0]

#define QLTY_BACKGROUND_COLOR [UIColor colorWithRed:0xee/255.0f  green:0xee/255.0f  blue:0xee/255.0f alpha:1.0]

#define ELLIFE_GRAY [UIColor colorWithRed:0x66/255.0f  green:0x66/255.0f  blue:0x66/255.0f alpha:1.0]

//Userdefaults context
#define TOOLSKEY @"ToolsKey"
#define SEARCH_KEYWORD @"SearchKeywords"

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//通知
#define M_NOTIFICATION [NSNotificationCenter defaultCenter]


#endif
