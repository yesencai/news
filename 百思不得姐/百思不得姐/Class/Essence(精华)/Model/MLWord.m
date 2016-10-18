//
//  MLWord.m
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLWord.h"
#import "MLComment.h"
#import <MJExtension.h>
#import "NSDate+MLCompare.h"
@implementation MLWord

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"small_image":@"image0",@"midde_image":@"image2",@"big_image":@"image1"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"top_cmt":[MLComment class]};
}

- (NSString *)create_time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置日期的格式，声明字符串每个字符之间的含义
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //微博创建日期
    NSDate *createdDate = [formatter dateFromString:_create_time];
    //手机当前时间
    NSDate *nowDate = [NSDate date];
    //创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    //得到时间差
    NSDateComponents *cmp =  [calendar components:unit fromDate:createdDate toDate:nowDate options:0];
    if ([createdDate ml_isThisYear]) {//判断是否是今年
        
        if ([createdDate ml_isThisDay]) {//是否今天
            if (cmp.hour>=1) {
                return [NSString stringWithFormat:@"%ld 小时前",cmp.hour];
                
            }else if (cmp.minute>1){
                return [NSString stringWithFormat:@"%ld 分钟前",cmp.minute];
                
            }else{
                return @"刚刚";
            }
            
        }else if ([createdDate ml_isYesterDay]){//判断是否是昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createdDate];
        }else{
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createdDate];
        }
        
    }else{
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    }

}

- (CGFloat)cellHeight{
    
    if (!_cellHeight) {
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * MLHeadImageSpacing, MAXFLOAT);
        CGRect textRect = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil];
        _cellHeight = textRect.size.height + 2 * MLHeadImageSpacing + MLButtomToolViewH + MLHeadImageH + 20;
        if (self.type==MLTopicTypePicture) {
            CGFloat picureW = maxSize.width;
            CGFloat picureH = picureW * self.height / self.width;
            _bigPicture = picureH > MLPictureMaxHeight;
            picureH = picureH > MLPictureMaxHeight ? MLPictureNormalHeight : picureH;
            _picureFrame = CGRectMake(10, textRect.size.height + 80, picureW, picureH);
            _cellHeight += picureH + 5;
        }
        if (self.type == MLTopicTypeVioce) {
            CGFloat vioceW = maxSize.width;
            CGFloat vioceH = vioceW * self.height / self.width;
            _voiceFrame = CGRectMake(10, textRect.size.height + 80, vioceW, vioceH);
            _cellHeight += vioceH + 5;
        }
        if (self.type == MLTopicTypeVedio) {
            CGFloat vedioW = maxSize.width;
            CGFloat vedioH = vedioW * self.height / self.width;
            _vedioFrame = CGRectMake(10, textRect.size.height + 80, vedioW, vedioH);
            _cellHeight += vedioH + 5;
        }
    }
    return _cellHeight;
}
@end
