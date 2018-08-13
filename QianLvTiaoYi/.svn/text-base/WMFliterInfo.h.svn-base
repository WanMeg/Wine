//
//  WMFliterInfo.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/20.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>


/************* 分类商品筛选信息 ***********/
@interface WMFliterInfo : NSObject

@property (nonatomic, strong) NSMutableArray *brands;//品牌
@property (nonatomic, strong) NSMutableArray *attributes;//属性
@property (nonatomic, getter=isExpand) BOOL expand;   //Brands 是否展开
@end

/***************** 品牌 ****************/
@interface WMBrands : NSObject

@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *mallBrandId;
@property (nonatomic) BOOL isSelected;    //是否选中

@end

/***************** 属性 ****************/
@interface WMAttributes : NSObject

@property (nonatomic, copy) NSString *attributeName;
@property (nonatomic, copy) NSString *codeNo;
@property (nonatomic, copy) NSString *productAttributeId;
@property (nonatomic, copy) NSString *productCategoryId;
@property (nonatomic, strong) NSMutableArray *productAttributeValues;
@property (nonatomic, getter=isExpand) BOOL expand;   //Attribute 是否展开

@end

/************* 产品属性   ***********/
@interface WMProductAttributeValues : NSObject

@property (nonatomic, copy) NSString *attributeId;
@property (nonatomic, copy) NSString *attributeValue;
@property (nonatomic, copy) NSString *codeNo;
@property (nonatomic, copy) NSString *productAttributeValueId;
@property (nonatomic) BOOL isSelected;    //是否选中

@end

/***************** 固定标签 ****************/
@interface PRTags : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic) BOOL isSelected;    //是否选中
@end