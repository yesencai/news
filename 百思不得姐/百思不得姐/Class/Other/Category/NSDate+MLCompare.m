//
//  NSDate+MLCompare.m
//  百思不得姐
//
//  Created by Dylan on 16/9/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "NSDate+MLCompare.h"

@implementation NSDate (MLCompare)

/**
 *  判断是否是今年
 *
 */
-(BOOL)ml_isThisYear{
    
    NSDateComponents *createdCmp = [self ml_getCreatedComponentsWithCalendarUnit:NSCalendarUnitYear];
    NSDateComponents *nowCmp = [self ml_getNowComponentsWithCalendarUnit:NSCalendarUnitYear];
    if (createdCmp.year==nowCmp.year) {
        return YES;
    }
    return NO;
}
/**
 *  是否是昨天
 *
 */
-(BOOL)ml_isYesterDay{
    NSCalendarUnit unit =NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *cmp = [self ml_getTimeComponentsDifferenceWithCalendarUnit:unit];
    
    if (cmp.year==0&&cmp.month==0&&cmp.day==1) {
        return YES;
    }
    return NO;
}
/**
 *  判断时间是否是今天
 *
 */
-(BOOL)ml_isThisDay{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    //创建时间
    NSString *createdStr = [fmt stringFromDate:self];
    //现在时间
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    if ([createdStr isEqualToString:nowStr]) {
        return YES;
    }
    return NO;
}
/**
 *  判断某个时间的年月日时分秒
 *
 *  @param unit 年、月、日
 */
-(NSDateComponents *)ml_getCreatedComponentsWithCalendarUnit:(NSCalendarUnit)unit{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *createdCmp =  [calendar components:NSCalendarUnitYear fromDate:self];
    return createdCmp;
}
/**
 *  判断当前时间的年月日时分秒
 *
 *  @param unit 年、月、日
 *
 */
-(NSDateComponents *)ml_getNowComponentsWithCalendarUnit:(NSCalendarUnit)unit{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowCmp =  [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return nowCmp;
}
/**
 *  得到时间差
 *
 *  @param unit 年、月、日
 *
 */
-(NSDateComponents *)ml_getTimeComponentsDifferenceWithCalendarUnit:(NSCalendarUnit)unit{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *createdStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate *createdDate = [fmt dateFromString:createdStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //得到时间差
    NSDateComponents *cmp =  [calendar components:unit fromDate:createdDate toDate:nowDate options:0];
    return cmp;
}

@end
