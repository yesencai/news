//
//  MLWordCell.h
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLWord,MLVedioView,MLWordCell;

@protocol MLWordCellDelegate <NSObject>
@optional
- (void)MLWordCell:(MLWordCell *)wordCell playVedio:(MLVedioView *)vedioView;

@end

@interface MLWordCell : UITableViewCell
/** 段子模型 */
@property (nonatomic, strong) MLWord *word;
/** 视频显示 */
@property (nonatomic, weak) MLVedioView *vedioView;
/** delegate */
@property (nonatomic, weak) id <MLWordCellDelegate> delegate;

@end
