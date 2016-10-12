//
//  BaseDataModel.m
//  LSWearable
//
//  Created by rolandxu on 16/1/1.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "BaseDataModel.h"
#import "LKDBHelper.h"


static NSMutableDictionary* gClassRemovedPropertiesMapDict = nil;

@implementation BaseDataModel
+(void)initialize
{
    //记录当前所有的Properties,没有映射的就remove掉
    if (gClassRemovedPropertiesMapDict == nil)
    {
        gClassRemovedPropertiesMapDict = [NSMutableDictionary dictionary];
    }
    LKModelInfos* info = [[self class] getModelInfos];
    NSMutableArray* pptArray = [NSMutableArray array];
    for (int i = 0; i < info.count; ++i)
    {
        LKDBProperty* ppt = [info objectWithIndex:i];
        NSString* pptName = ppt.propertyName;
        [pptArray addObject:pptName];
    }
    [gClassRemovedPropertiesMapDict setObject:pptArray forKey:[[self class] description]];
    
    [self mapRelation];

}

+ (void)mapRelation
{
    [self onMapProperties];
    
    //清掉没有map的properties
    NSMutableArray* pptArray = [gClassRemovedPropertiesMapDict objectForKey:[[self class] description]];
    for (int i = 0; i < pptArray.count; ++i)
    {
        [self removePropertyWithColumnName:[pptArray objectAtIndex:i]];
    }
}

+(void)mapProperty:(NSString*)PP
{
    NSMutableArray* pptArray = [gClassRemovedPropertiesMapDict objectForKey:[[self class] description]];
    for (int i = ((int)[pptArray count]) - 1; i >= 0; --i)
    {
        NSString* pptName = [pptArray objectAtIndex:i];
        if ([PP isEqualToString:pptName])
        {
            [pptArray removeObjectAtIndex:i];
        }
    }
}

+(void)onMapProperties
{
    
}

- (NSString *)debugDescription
{
    //提取properties
    unsigned int count;
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        if ([key isEqualToString:@"description"] || [key isEqualToString:@"debugDescription"]) continue;
        [keys addObject:key];
    }
    free(properties);
    
    NSString *classname     = NSStringFromClass([self class]);
    NSMutableString *retStr = [[NSMutableString alloc] init];
    NSArray *propertyNames  = keys;
    for (NSString *key in propertyNames) {
        id value      = [self valueForKey:key];
        
        if ([value isKindOfClass:[NSDate class]]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd - HH:mm:ss"];
            NSString *timeString = [dateFormatter stringFromDate:value];
            value = timeString;
        }
        NSString *str = [NSString stringWithFormat:@"   %@ : %@\n", key, value];
        [retStr appendString:str];
    }
    
    return [NSString stringWithFormat:@"<%@: %p> : {\n%@}", classname, self, retStr];
}


@end
