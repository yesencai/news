//
//  Header.h
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import "UIBarButtonItem+DDBarButtonItem.h"
#import "UIView+Extension.h"
#import "MLConst.h"
#define DDColor(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.]

#ifdef DEBUG
#define DDLog(...) NSLog(__VA_ARGS__)
#else
#define DDLog(...)
#endif

#endif /* Header_h */
