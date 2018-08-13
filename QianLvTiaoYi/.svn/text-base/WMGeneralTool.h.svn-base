//
//  WMGeneralTool.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGeneralTool : NSObject


/**  判断用户登录后是否认证*/
+ (BOOL)judgeLoginAuthentication;

/** 分享方法*/
+ (void)shareMethodWithImg:(id)imgStr withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;

/** 按钮发送验证码方法*/
+ (void)setCodeBtnStatusClickWith:(UIButton *)button;

/** 加入购物车图标按钮点击方法*/
+ (void)addShopCarBtnClickwith:(NSString *)goodsID;

/** 时间戳转换*/
+ (NSString *)getNowReallyTimeWith:(NSNumber *)dateString;

/** 开始上传评论图片*/
+ (void)beginToUploadImagesWithImgArray:(NSMutableArray *)selectImgs withUpdateHandler:(void (^)(BOOL success, NSMutableArray *imgURLs))updateHandler;

/** 上传图片文件*/
+ (void) uploadImages:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType callBack:(void (^)(BOOL success, NSString *url))callBack;

/** 设置星星的图片状态 */
+ (void)setStarImgWithArray:(NSArray *)array withTag:(NSInteger)tag;

/** 判断内容是否全部为空格  yes 全部为空格  no 不是 */
+ (BOOL)isEmpty:(NSString *)str;

/** 判断textview中是否含有表情 */
+ (BOOL)judgeStringContainsEmoji:(NSString *)string;

/** 获取一个指定字体大小字符串的高度 */
+ (CGFloat)getHeightWithString:(NSString *)aString withFontSize:(CGFloat)fontSize;

/** 获取1到2时间的倒计时时间*/
+ (NSString *)getCountTimeWithOneTime:(long long)oneTime withTwoTime:(long long)twoTime;

/** 指定时间与当前时间判断 是未过期还是已过期*/
+ (BOOL)judgeAssignTimeWith:(long long)time;

@end
