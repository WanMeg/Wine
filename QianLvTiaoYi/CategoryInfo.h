//
//  CategoryInfo.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/13.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Advert : NSObject

@property (copy, nonatomic) NSString *addrId;
@property (copy, nonatomic) NSString *imgLink;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *linkType;
@property (copy, nonatomic) NSString *mallAdvertId;
@property (copy, nonatomic) NSString *showAddress;
@property (copy, nonatomic) NSString *sort;
@property (copy, nonatomic) NSString *title;

@end



@interface CategoryInfo : NSObject

@property (strong, nonatomic) Advert *advert;
@property (copy, nonatomic) NSString *productCategoryId; /**<分类ID*/
@property (copy, nonatomic) NSString *parentId; /**<父级ID*/
@property (copy, nonatomic) NSString *categoryName; /**<分类名称*/
@property (copy, nonatomic) NSString *brandImg; //logo图片
@property (copy, nonatomic) NSString *codeNo; /**<编码*/
@property (copy, nonatomic) NSString *icon;
@property (strong, nonatomic) NSArray *childrenCategorys; /**<子类列表*/

@property (assign, nonatomic, getter=isPicked) BOOL picked;
+ (NSMutableArray *)createTempCategoryInofList;


@end


