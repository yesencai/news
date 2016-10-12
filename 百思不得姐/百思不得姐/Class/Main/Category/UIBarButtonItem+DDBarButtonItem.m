//
//  UIBarButtonItem+DDBarButtonItem.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "UIBarButtonItem+DDBarButtonItem.h"

@implementation UIBarButtonItem (DDBarButtonItem)
/**
 *  自定义barButtonItem
 *
 *  @param image       图片
 *  @param heightImage 高亮图片
 *  @param action      action
 *  @param target      target
 *
 */
+(instancetype)itemWithImage:(NSString *)image heighImage:(NSString *)heightImage action:(SEL)action target:(id)target{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage  imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    return [[self alloc]initWithCustomView:btn];
}

@end
