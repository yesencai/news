//
//  UIBarButtonItem+DDBarButtonItem.h
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DDBarButtonItem)
+(instancetype)itemWithImage:(NSString *)image heighImage:(NSString *)heightImage action:(SEL)action target:(id)target;
@end
