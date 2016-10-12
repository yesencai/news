//
//  JYHttpTool.h
//  Joyce的新浪微博
//
//  Created by Joyce on 15/6/2.
//  Copyright (c) 2015年 Joyce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface JYHttpTool : NSObject

+(instancetype)httpTool;
/**
 *  GET请求
 *  @param path       url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;
/**
 *  get请求 没有baseUrl
 *
 *  @param path       url
 *  @param parameters 参数
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
+(void)getNoBasePath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
/**
 *  POST请求
 *  @param path       url
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)postPath:(NSString *)path parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 * 上传图片
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL parame:(id)pp success:(void (^)(id responseObject))success fail:(void (^)())fail;
/**
 *  结束所有请求
 */
+(void)cancelAllOperation;
@end
