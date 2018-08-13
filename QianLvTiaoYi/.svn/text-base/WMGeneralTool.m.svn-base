//
//  WMGeneralTool.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "WMGeneralTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@implementation WMGeneralTool
/**
 *  判断登录后是否认证
 */
+ (BOOL)judgeLoginAuthentication
{
    if ([M_USERDEFAULTS boolForKey:@"UserIsAuthentication"]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  分享方法
 */
+ (void)shareMethodWithImg:(id)imgStr withUrlStr:(NSString *)urlStr withTitle:(NSString *)title
{
    //1、创建分享参数
    NSArray* imageArray = @[imgStr];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"中国酒类批发网" images:imageArray url:[NSURL URLWithString:urlStr] title:title type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
             switch (state) {
                 case SSDKResponseStateSuccess:{
                     
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:{
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                     
                 default:
                     break;
             }
         }];
    }
}


/**
 *  设置验证码按钮的点击状态
 */
+ (void)setCodeBtnStatusClickWith:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    button.backgroundColor = [UIColor grayColor];
    
    [PRUitls countDownWithTimeOut:60 CallBack:^(BOOL isFinished, int curTime)
     {
         if (isFinished)
         {
             button.userInteractionEnabled = YES;
             button.backgroundColor = QLTY_MAIN_COLOR;
             [button setTitle:@"获取验证码" forState:UIControlStateNormal];
         } else {
             [button setTitle:[NSString stringWithFormat:@"%d秒重新获取", curTime] forState:UIControlStateNormal];
         }
     }];
}

/**
 *  加入购物车按钮点击事件
 */
+ (void)addShopCarBtnClickwith:(NSString *)goodsID
{
    //获取产品id
    [XLDataService getWithUrl:RMRequestStatusGetGoodsProduct param:@{@"goodsId": goodsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             NSArray *proArray = dataObj[@"product"];
             NSString *productID = proArray[0];
             //加入购物车
             [PRUitls delay:0.5 finished:^{
                 [XLDataService postWithUrl:RMRequestStatusAddCart param:@{@"productId": productID,@"number":@"1"} modelClass:nil responseBlock:^(id dataObj, NSError *error)
                  {
                      if (error.code == 100) {
                          [SVProgressHUD showSuccessWithStatus:error.domain];
                      } else {
                          [SVProgressHUD showErrorWithStatus:error.domain];
                      }
                  }];
             }];
         }
     }];
}

/**
 *  时间戳转化为现在的时间
 */
+ (NSString *)getNowReallyTimeWith:(NSNumber *)dateString
{
    //时间戳 13位时间戳 截取10位
    NSInteger timeStamp = dateString.integerValue;
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeStamp];
    if (timeStr.length == 13) timeStamp = timeStamp / 1000;
    
    NSTimeInterval time = timeStamp + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:detaildate];
    
    return dateStr;
}

/**
 *  开始上传评论图片
 */
+ (void)beginToUploadImagesWithImgArray:(NSMutableArray *)selectImgs withUpdateHandler:(void (^)(BOOL success, NSMutableArray *imgURLs))updateHandler
{
    NSMutableArray *images = [NSMutableArray array];
    for (id obj in selectImgs) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [images addObject: obj];
        }
    }
    
    __block int count  = 0;
    NSMutableArray *uploadedURLs = [NSMutableArray arrayWithObjects:@"", @"", @"", nil];
    for (int i = 0; i < images.count; i++) {
        UIImage *img = images[i];
        [self uploadImages:img name:@"file" fileName:[NSString stringWithFormat:@"business%d.png", i] mimeType:@"image/png" callBack:^(BOOL success, NSString *url) {
            if (success) {
                uploadedURLs[i] = url;
                count++;
                if (count == images.count) {
                    //                    [SVProgressHUD showSuccessWithStatus:@"图片上传完成"];
                    if (updateHandler) updateHandler(YES, uploadedURLs);
                }
            }else {
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                if (updateHandler) updateHandler(NO, uploadedURLs);
            }
        }];
    }
    //如果没有上传图片 就直接发表评论
    if (images.count == 0) {
        if (updateHandler) updateHandler(NO, uploadedURLs);
    }
}

/**
 *  请求上传图片
 */
+ (void) uploadImages:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType callBack:(void (^)(BOOL success, NSString *url))callBack
{
    XLFileConfig *fileConfig = [[XLFileConfig alloc] init];
    fileConfig.fileData = UIImageJPEGRepresentation(image, 0.5);
    fileConfig.name = name;
    fileConfig.fileName = fileName;
    fileConfig.mimeType = mimeType;
    
    [XLDataService updateWithUrl:RMRequestStatusUploadImage param:nil fileConfig:fileConfig responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"C:%@ ===", fileName);
        if (error.code == 100) {
            if (callBack) callBack(YES, dataObj[@"object"]);
        }else {
            if (callBack) callBack(NO, @"");
        }
    }];
}

/**
 *  设置星星的图片状态
 */
+ (void)setStarImgWithArray:(NSArray *)array withTag:(NSInteger)tag
{    
    UIImageView *star1 = array[0];
    UIImageView *star2 = array[1];
    UIImageView *star3 = array[2];
    UIImageView *star4 = array[3];
    UIImageView *star5 = array[4];
    
    UIImage *whiteStar = [UIImage imageNamed:@"pjbaixing"];
    UIImage *yellowStar = [UIImage imageNamed:@"pjhuangxing-7"];
    
    switch (tag)
    {
        case 0:{
            
            star1.image = yellowStar;
            star2.image = whiteStar;
            star3.image = whiteStar;
            star4.image = whiteStar;
            star5.image = whiteStar;
        }
            break;
        case 1:{
            star1.image = yellowStar;
            star2.image = yellowStar;
            star3.image = whiteStar;
            star4.image = whiteStar;
            star5.image = whiteStar;
        }
            break;
        case 2:{
            star1.image = yellowStar;
            star2.image = yellowStar;
            star3.image = yellowStar;
            star4.image = whiteStar;
            star5.image = whiteStar;
        }
            break;
        case 3:{
            star1.image = yellowStar;
            star2.image = yellowStar;
            star3.image = yellowStar;
            star4.image = yellowStar;
            star5.image = whiteStar;
        }
            break;
        default:{
            star1.image = yellowStar;
            star2.image = yellowStar;
            star3.image = yellowStar;
            star4.image = yellowStar;
            star5.image = yellowStar;
        }
            break;
    }
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

/**
 *  判断textview的输入中是否含有表情
 */
+ (BOOL)judgeStringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            const unichar hs = [substring characterAtIndex:0];
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                    }
                }
             } else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                     returnValue = YES;
                }
             } else {
                 if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue = YES;
                 } else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue = YES;
                 } else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue = YES;
                 } else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue = YES;
                 } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                 {
                    returnValue = YES;
                 }
             }
    }];
    return returnValue;
}

/**
 *  获取一个指定字体大小字符串的高度
 */
+ (CGFloat)getHeightWithString:(NSString *)aString withFontSize:(CGFloat)fontSize
{
    //参数1:表示文字展示出的矩形的大小
    //参数2:NSStringDrawingUsesLineFragmentOrigin:以每一行为单位展示出整个内容的矩形
    //参数3:在多少号文字下计算文字的大小
    // CGRect messageRect = MESSAGERECT(message); 宏定义表达方式
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}

/** 获取倒计时时间*/
+ (NSString *)getCountTimeWithOneTime:(long long)oneTime withTwoTime:(long long)twoTime {
    
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:oneTime];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:twoTime];
    NSCalendar* chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:today  toDate: startDate options:0];
    NSInteger diffHour = [cps hour];
    NSInteger diffMin = [cps minute];
    NSInteger diffSec = [cps second];
    NSInteger diffDay = [cps day];
    NSInteger diffMon = [cps month];
//    NSInteger diffYear = [cps year];
//    NSLog(@" From Now to %@, diff: Years: %ld  Months: %ld, Days; %ld, Hours: %ld, Mins:%ld, sec:%ld",[today description], (long)diffYear, (long)diffMon, (long)diffDay, (long)diffHour, (long)diffMin,(long)diffSec );
    
    NSString *countdown = nil;
    if (diffMon > 0) {
        countdown = [NSString stringWithFormat:@"%ld月%ld天%ld:%ld:%ld", diffMon,diffDay,diffHour, diffMin, diffSec];
    } else {
        countdown = [NSString stringWithFormat:@"%ld天%ld:%ld:%ld",diffDay,diffHour, diffMin, diffSec];
    }
    
    if (diffSec < 0) {
        countdown = [NSString stringWithFormat:@"活动已结束"];
    }
    return countdown;
}



/** 判断与当前时间是否一致*/
+ (BOOL)judgeAssignTimeWith:(long long)time
{
    NSDate *today = [NSDate date];//得到当前时间
    //    NSDate*  startDate  = [ [ NSDate alloc] init ];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar* chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:today  toDate: startDate options:0];

    NSInteger diffSec = [cps second];

    if (diffSec < 0) {
        //表示给定的时间超过了当前时间  活动已启动
        return YES;
    } else {
        //表示给定的时间还没有超过当前时间  活动未启动
        return NO;
    }
}


@end
