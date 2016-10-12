//
//  DDReccmmend.m
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDReccmmend.h"
#import <MJExtension.h>
@implementation DDReccmmend
- (NSMutableArray *)reccmmendUserArray
{
    if (!_reccmmendUserArray) {
        self.reccmmendUserArray = [[NSMutableArray alloc] init];
    }
    return _reccmmendUserArray;
}

@end
