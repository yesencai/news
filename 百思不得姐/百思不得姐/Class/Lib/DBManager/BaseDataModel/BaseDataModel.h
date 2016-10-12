//
//  BaseDataModel.h
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataModel : NSObject

//子类去实现，需要在里面调用mapProperty语句去告诉要存储哪些字段。
+(void)onMapProperties;

//子类去调用，告诉那些字段需要map映射起来
+(void)mapProperty:(NSString*)PP;

@end
