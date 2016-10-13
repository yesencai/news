//
//  DDReccmmendUser.h
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLReccmmendUser : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 粉丝数量 */
@property (nonatomic, assign) NSInteger fans_count;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;


@end
