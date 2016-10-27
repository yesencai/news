//
//  MLComentCell.h
//  百思不得姐
//
//  Created by Dylan on 2016/10/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLComment;
@interface MLCommentCell : UITableViewCell

/** 评论模型 */
@property (nonatomic, strong) MLComment *comment;
@end
