//
//  BaseDAOProtocol.h
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseDAOProtocol <NSObject>

@optional

- (NSError *)saveEntity:(id)entity;
- (void)saveEntity:(id)entity callback:(void (^)(BOOL))callback;

/**
 *  保存单个entity
 *
 *  @param entity        希望保存的entity
 *  @param callbackQueue 回调queue，传nil默认回调到mainQueue
 *  @param callback      回调block
 */
- (void)saveEntity:(id)entity callbackQueue:(dispatch_queue_t)callbackQueue callback:(void (^)(BOOL))callback;



- (NSError *)saveEntityWithArray:(NSArray *)array;
- (void)saveEntityWithArray:(NSArray *)array callback:(void (^)(NSError *error))callback;

/**
 *  批量保存多个entity
 *
 *  @param array         entity数组
 *  @param callbackQueue 回调queue，nil默认回调到mainQueue
 *  @param callback      回调block
 */
- (void)saveEntityWithArray:(NSArray *)array callbackQueue:(dispatch_queue_t)callbackQueue callback:(void (^)(NSError *error))callback;



- (id)loadEntityWithKey:(NSString *)key;
- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order;
- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count;
- (void)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count callback:(void (^)(NSMutableArray *))block ;


/**
 *  查询数据
 *
 *  @param where         where语句
 *  @param order         order
 *  @param offset        offset
 *  @param count         count
 *  @param callbackQueue 回调queue，传nil默认回调到mainQueue
 *  @param block         回调block
 */
- (void)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count callbackQueue:(dispatch_queue_t)callbackQueue callback:(void (^)(NSMutableArray *))block;


//复杂查询可以用这个方法,自己写SQL
- (void)loadEntityWithSQL:(NSString *)sql callback:(void (^)(NSMutableArray *array))block;

/**
 *  使用sql语句查询数据库
 *
 *  @param sql           sql语句
 *  @param callbackQueue 回调queue，传nil默认回调到mainQueue
 *  @param block         回调block
 */
- (void)loadEntityWithSQL:(NSString *)sql callbackQueue:(dispatch_queue_t)callbackQueue callback:(void (^)(NSMutableArray *array))block;



- (NSInteger)countWithWhere:(NSString *)where;

- (NSError *)deleteEntity:(id)entity;
- (NSError *)deleteEntityWithKey:(NSString *)key;
- (NSError *)deleteEntityWithWhere:(NSString *)where;

- (void)deleteAllEntity;

- (BOOL)isExistEntity:(id)entity;

@end
