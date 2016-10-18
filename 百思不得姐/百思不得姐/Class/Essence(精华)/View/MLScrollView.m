//
//  MLScrollView.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/18.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLScrollView.h"

@implementation MLScrollView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event] ;
    if ([view isKindOfClass:[UISlider class]]){
        self.scrollEnabled = NO ;
    }else{
        self.scrollEnabled = YES ;
    }
    return view;
}
@end
