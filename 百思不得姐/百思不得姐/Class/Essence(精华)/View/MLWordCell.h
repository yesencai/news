//
//  MLWordCell.h
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLWord;
@interface MLWordCell : UITableViewCell
/** 段子模型 */
@property (nonatomic, strong) MLWord *word;
@end
