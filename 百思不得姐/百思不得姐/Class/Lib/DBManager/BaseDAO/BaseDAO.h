//
//  BaseDAO.h
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDAOProtocol.h"

#define XYBaseDao_error_code 123123
#define XYBaseDao_load_maxCount 1000

@interface BaseDAO : NSObject
<BaseDAOProtocol>

@property (nonatomic, weak, readonly) Class entityClass;

//构造
+ (instancetype)daoWithEntityClass:(Class)aClass;
+ (instancetype)daoWithEntityClassName:(NSString *)name;

@end
