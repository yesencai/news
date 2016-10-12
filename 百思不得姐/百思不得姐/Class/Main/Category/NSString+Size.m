//
//  NSString+Size.m
//  Joyce的新浪微博
//
//  Created by Joyce on 15/6/25.
//  Copyright (c) 2015年 Joyce. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    return [NSString sizeWithText:text font:font maxW:MAXFLOAT];
}
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    if (!font) {
        font = [UIFont systemFontOfSize:18];
    }
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
