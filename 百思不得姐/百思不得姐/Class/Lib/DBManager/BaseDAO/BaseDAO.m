//
//  BaseDAO.m
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "BaseDAO.h"
#import "LKDBHelper.h"

@interface BaseDAO ()
@property (nonatomic, weak) LKDBHelper *globalHelper;
@end

@implementation BaseDAO

+ (instancetype)daoWithEntityClass:(Class)aClass
{
    if (aClass == nil)
        return nil;
    
    BaseDAO *dao = [[[self class] alloc] initWithEntityClass:aClass];
    
    return dao;
}

+ (instancetype)daoWithEntityClassName:(NSString *)name
{
    return [self daoWithEntityClass:NSClassFromString(name)];
}

- (instancetype)initWithEntityClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _entityClass  = aClass;
        _globalHelper = [aClass getUsingLKDBHelper];
    }
    return self;
}


#pragma mark BaseDAOProtocol
- (NSError *)saveEntity:(id)entity
{
    if ([[NSThread currentThread] isMainThread]) {
        DDLog(@"=======存数据在主线程调用%@========",entity);
    }
    
    if (entity == nil)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", entity] code:XYBaseDao_error_code userInfo:nil];
    
    LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
    
    if (![globalHelper insertToDB:entity])
    {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", entity] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (void)saveEntity:(id)entity callback:(void (^)(BOOL))callback
{
    if (entity == nil)
        return;
    
    LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
    
    return [globalHelper insertToDB:entity callback:callback];
}

- (void)saveEntityWithArray:(NSArray *)array callback:(void (^)(NSError *error))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = [self saveEntityWithArray:array];
        if (callback) {
            if (!error) {
                callback(nil);
            } else {
                callback(error);
            }
        }
    });
}

- (NSError *)saveEntityWithArray:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", array] code:XYBaseDao_error_code userInfo:nil];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"[save error] :"];
    NSInteger length = str.length;
    
    __weak __typeof(BaseDAO *) weakSelf = self;
    
    // 事务 transaction
    [_globalHelper executeDB:^(FMDatabase *db) {
        [db beginTransaction];
        for (NSObject *entity in array)
        {
            if (![weakSelf.globalHelper insertToDB:entity])
            {
                [str stringByAppendingFormat:@"%@ ", entity];
            }
        }
        [db commit];
    }];
    
    if (str.length > length)
    {
        return [NSError errorWithDomain:str code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (id)loadEntityWithKey:(NSString *)key
{
    if (key.length == 0)
        return nil;
    
    id object = [[_entityClass alloc] init];
    
    NSString *where = nil;
    
    if ([key isKindOfClass:[NSString class]])
    {
        where = [NSString stringWithFormat:@"%@ = '%@'", [_entityClass getPrimaryKey], key];
    }
    else if ([key isKindOfClass:[NSNumber class]])
    {
        where = [NSString stringWithFormat:@"%@ = %@", [_entityClass getPrimaryKey], key];
    }
    else if (1)
    {
        where = @"";
    }
    
    object = [_entityClass searchSingleWithWhere:where orderBy:nil];
    
    return object;
}

- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order;
{
    return [self loadEntityWithWhere:where order:order offset:0 count:XYBaseDao_load_maxCount];
}

- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count
{
    NSArray *array = [_entityClass searchWithWhere:where orderBy:order offset:offset count:count];
    
    return array;
}

- (void)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count callback:(void (^)(NSMutableArray *))block
{
    return [_entityClass searchWithWhere:where orderBy:order offset:offset count:count callback:block];
}

- (void)loadEntityWithSQL:(NSString *)sql callback:(void (^)(NSMutableArray *array))block {
    return [_entityClass searchWithSQL:sql callback:block];
}


- (NSInteger)countWithWhere:(NSString *)where
{
    return [_entityClass rowCountWithWhere:where];
}

- (NSError *)deleteEntity:(id)entity
{
    if (![entity deleteToDB])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, entity] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (NSError *)deleteEntityWithKey:(NSString *)key
{
    id object = [[_entityClass alloc] init];
    [object setValue:key forKey:[_entityClass getPrimaryKey]];
    
    if (![object deleteToDB])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, key] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (NSError *)deleteEntityWithWhere:(NSString *)where
{
    if (![_entityClass deleteWithWhere:where])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, where] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (void)deleteAllEntity
{
    [LKDBHelper clearTableData:[_entityClass class]];
}

- (BOOL)isExistEntity:(id)entity
{
    return [entity isExistsFromDB];
}

@end
