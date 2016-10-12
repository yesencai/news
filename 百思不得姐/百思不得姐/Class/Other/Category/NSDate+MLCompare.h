//
//  NSDate+MLCompare.h
//  百思不得姐
//
//  Created by Dylan on 16/9/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MLCompare)

/**
 *  判断是否是今年
 *
 */
-(BOOL)ml_isThisYear;
/**
 *  是否是昨天
 *
 */
-(BOOL)ml_isYesterDay;
/**
 *  判断时间是否是今天
 *
 */
-(BOOL)ml_isThisDay;
/**
 *  判断某个时间的年月日时分秒
 *
 *  @param unit 年、月、日
 */
-(NSDateComponents *)ml_getCreatedComponentsWithCalendarUnit:(NSCalendarUnit)unit;
/**
 *  判断当前时间的年月日时分秒
 *
 *  @param unit 年、月、日
 *
 */
-(NSDateComponents *)ml_getNowComponentsWithCalendarUnit:(NSCalendarUnit)unit;
/**
 *  得到时间差
 *
 *  @param unit 年、月、日
 *
 */
-(NSDateComponents *)ml_getTimeComponentsDifferenceWithCalendarUnit:(NSCalendarUnit)unit;

@end
