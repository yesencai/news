//
//  DDReccmmend.h
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLReccmmend : NSObject
/** #type# **/
@property (nonatomic, assign) NSInteger id;
/** #type# **/
@property (nonatomic, copy) NSString *name;
/** #type# **/
@property (nonatomic, copy) NSString *count;
//总数
@property (nonatomic,assign)NSInteger total;

@property(nonatomic,assign)NSInteger currenPage;

@property (nonatomic,strong)NSMutableArray *reccmmendUserArray;

@end
