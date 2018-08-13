//
//  NSSring+MD5.h
//  TianCaiXiaoshou
//
//  Created by Gollum on 15/11/30.
//  Copyright © 2015年 Gollum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonDigest.h> 

@interface NSString (MD5)
- (NSString *) md5;
@end
