//
//  MLWordCell.h
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLWord,MLVedioView,MLWordCell,MLVoiceView;

@protocol MLWordCellDelegate <NSObject>
@optional

/**
 点击播放视频

 @param wordCell  wordCell
 @param vedioView vedioView
 */
- (void)MLWordCell:(MLWordCell *)wordCell playVedio:(MLVedioView *)vedioView;
/**
 点击播放音频
 
 @param wordCell  wordCell
 @param voiceView voiceView
 */
- (void)MLWordCell:(MLWordCell *)wordCell playVoice:(MLVoiceView *)voiceView;
/**
 滑动slider控制播放进度
 
 @param wordCell  wordCell
 @param sliderChange sliderChange
 */
- (void)MLWordCell:(MLWordCell *)wordCell sliderValueChange:(UISlider *)sliderChange;
/**
 点击slider控制播放进度
 
 @param wordCell  wordCell
 @param sliderTouch sliderTouch
 */
- (void)MLWordCell:(MLWordCell *)wordCell sliderTouch:(UISlider *)sliderTouch pan:(UITapGestureRecognizer *)pan;


@end

@interface MLWordCell : UITableViewCell
/** 段子模型 */
@property (nonatomic, strong) MLWord *word;
/** 视频显示 */
@property (nonatomic, weak) MLVedioView *vedioView;
/** 语音显示 */
@property (nonatomic, weak) MLVoiceView *voiceView;
/** delegate */
@property (nonatomic, weak) id <MLWordCellDelegate> delegate;

@end
