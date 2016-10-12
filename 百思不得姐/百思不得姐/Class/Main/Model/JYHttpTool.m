//
//  JYHttpTool.m
//  Joyce的新浪微博
//
//  Created by Joyce on 15/6/2.
//  Copyright (c) 2015年 Joyce. All rights reserved.
//

#import "JYHttpTool.h"
@implementation JYHttpTool
+(instancetype)httpTool{
    static JYHttpTool *tool=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        tool=[[JYHttpTool alloc] init];
    });
    return tool;
}
+(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(void)getNoBasePath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
+(void)postPath:(NSString *)path parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL parame:(id)pp success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:urlStr parameters:pp constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:fileURL name:@"file" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail();
    }];
}
/**
 *  结束所有请求
 */
+(void)cancelAllOperation{
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
}

@end
