//
//  DDRemTag.h
//  Dylan_01
//
//  Created by Dylan on 16/3/9.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLRemTag : NSObject
/** id **/
@property (nonatomic, copy) NSString *theme_id;
/** 名字 **/
@property (nonatomic, copy) NSString *theme_name;
/** 头像 **/
@property (nonatomic, copy) NSString *image_list;
/** 关注数 **/
@property (nonatomic, copy) NSString *sub_number;


@end
