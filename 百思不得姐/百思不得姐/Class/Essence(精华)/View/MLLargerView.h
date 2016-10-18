//
//  MLLargerView.h
//  百思不得姐
//
//  Created by Dylan on 2016/10/14.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLWord;
@interface MLLargerView : UIView
/** topic */
@property (nonatomic, strong) MLWord *topic;
+ (instancetype)largerView;
- (void)show;
@end
