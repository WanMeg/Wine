//
//  NSSring+MD5.m
//  TianCaiXiaoshou
//
//  Created by Gollum on 15/11/30.
//  Copyright © 2015年 Gollum. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *) md5
{
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return [ret lowercaseString];
}

@end
