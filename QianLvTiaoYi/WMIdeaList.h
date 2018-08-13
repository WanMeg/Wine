//
//  WMIdeaList.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMIdeaList : NSObject

@property (nonatomic, copy) NSString *content;//留言内容
//@property (nonatomic, copy) NSString *id;//留言id
@property (nonatomic, copy) NSString *messageDate;//留言时间
@property (nonatomic, copy) NSString *replyContent;//回复内容
@property (nonatomic, copy) NSString *replyDate;//回复时间
@property (nonatomic, copy) NSString *replyUserId;//回复人
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *userName;//用户名


@end
