//
//  DDPlaceHolderTextField.m
//  Dylan_01
//
//  Created by Dylan on 16/3/13.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLPlaceHolderTextField.h"
#import <objc/runtime.h>
@implementation MLPlaceHolderTextField

-(void)awakeFromNib{
    [super awakeFromNib];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITabBarController class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva = *(ivars + i);
        NSLog(@"iva=%s",ivar_getName(iva));
    }
    self.tintColor = self.textColor;
    self.backgroundColor = [UIColor clearColor];
}
-(BOOL)resignFirstResponder{
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];

    return [super resignFirstResponder];
}
-(BOOL)becomeFirstResponder{
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    return [super becomeFirstResponder];
}
@end
