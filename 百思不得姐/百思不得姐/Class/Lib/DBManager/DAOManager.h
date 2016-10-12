//
//  DAOManager.h
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDAOProtocol.h"

@interface DAOManager : NSObject

+(DAOManager*)shareInstance;
-(id<BaseDAOProtocol>)getDAOByClass:(Class)modelClass;

@end
