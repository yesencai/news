//
//  MLWord.h
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWord : NSObject

/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/** 新浪V用户 */
@property (nonatomic, assign,getter=isSina_v) BOOL sina_v;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图 */
@property (nonatomic, copy) NSString *small_image;
/** 中图 */
@property (nonatomic, copy) NSString *midde_image;
/** 大图 */
@property (nonatomic, copy) NSString *big_image;
/** 段子类型 */
@property (nonatomic, assign) MLTopicType type;

#pragma mark - 额外属性
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 图片的frame */
@property (nonatomic, assign) CGRect picureFrame;
/** 是否是大图 */
@property (nonatomic, assign,getter=isBigPicture) BOOL bigPicture;


@end
