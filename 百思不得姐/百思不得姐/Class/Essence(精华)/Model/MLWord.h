//
//  MLWord.h
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLComment;
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
/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 声音播放时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频播放时长 */
@property (nonatomic, assign) NSInteger vodiotime;
/** 热门评论 */
@property (nonatomic, strong) NSArray <MLComment *> *top_cmt;
/** 音频文件 */
@property (nonatomic, copy) NSString *voiceuri;
/** 视频文件 */
@property (nonatomic, copy) NSString *videouri;
#pragma mark - 额外属性
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 图片的frame */
@property (nonatomic, assign,readonly) CGRect picureFrame;
/** 声音的frame */
@property (nonatomic, assign,readonly) CGRect voiceFrame;
/** 视频的frame */
@property (nonatomic, assign,readonly) CGRect vedioFrame;

/** 是否是大图 */
@property (nonatomic, assign,getter=isBigPicture) BOOL bigPicture;
/** 是否已经点击声音播放按钮 */
@property (nonatomic, assign,getter=isVoicePlay) BOOL voicePlay;
/** 声音按钮正常状态 */
@property (nonatomic, assign,getter=isNormalPlay) BOOL normalPlay;
/** 是否已经点击视频播放 */
@property (nonatomic, assign,getter=isVedioPlay) BOOL vedioPlay;

@end
