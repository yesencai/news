//
//  DAOManager.m
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "DAOManager.h"
#import "BaseDAO.h"

@interface DAOManager ()
{
    NSMutableDictionary* _daoInstancesDict;
}
@end

static DAOManager* gInstance = nil;
@implementation DAOManager

+(DAOManager*)shareInstance
{
    @synchronized(gInstance) {
        if (gInstance == nil) {
            gInstance = [DAOManager new];
        }
        return gInstance;
    }
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        _daoInstancesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id<BaseDAOProtocol>)getDAOByClass:(Class)modelClass
{
    id<BaseDAOProtocol> dao = [_daoInstancesDict objectForKey:[[modelClass class] description]];
    if (dao == nil)
    {
        dao = [BaseDAO daoWithEntityClass:[modelClass class]];
        [_daoInstancesDict setObject:dao forKey:[[modelClass class] description]];
    }
    return dao;
}

@end
