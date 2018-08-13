//
//  CommentModel.m
//  QianLvTiaoYi
//
//  Created by 优hui on 16/5/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentResultsModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"commentList" : @"CommentModel"};
}

- (void)setCommentList:(NSMutableArray *)commentList {
    if (_commentList == nil || commentList == nil) {
        _commentList = commentList;
    }else {
        [_commentList addObjectsFromArray:commentList];
    }
}

@end

@implementation CommentModel

@end
