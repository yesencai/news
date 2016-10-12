//
//  NSString+Size.h
//  Joyce的新浪微博
//
//  Created by Joyce on 15/6/25.
//  Copyright (c) 2015年 Joyce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)
/**
 *  根据字体样式来确定字体的长度
 *
 *  @param text 字体
 *  @param font 样式
 *
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
/**
 *  根据字体样式最大宽度来定字体的长度
 *
 *  @param text 字体
 *  @param font 样式
 *  @param maxW 最大宽度
 *
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;
@end
