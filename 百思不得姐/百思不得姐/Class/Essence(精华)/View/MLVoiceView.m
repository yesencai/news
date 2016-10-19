//
//  MLVoiceView.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/12.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLVoiceView.h"
#import "MLWord.h"
#import <UIImageView+WebCache.h>
#import "MLLargerImageController.h"
#import <Masonry.h>
#import "MLLargerView.h"
#import <DOUAudioStreamer.h>
#import "Track.h"
#import "Track+Provider.h"
@interface MLVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *vioceImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLenght;
@property (weak, nonatomic) IBOutlet UILabel *playCount;

/** 只进入一次 */
@property (nonatomic, assign,getter=isOnece) BOOL onece;

/** streamer */
@property (nonatomic, strong) DOUAudioStreamer *streamer;
/** tracks */
@property (nonatomic, strong) Track *track;

@end
static UIWindow *_assistant;
@implementation MLVoiceView
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
- (UIWindow *)assistant
{
    if (!_assistant) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        _assistant = [[UIWindow alloc]init];
        _assistant.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _assistant.frame = CGRectMake(screenW - 50, screenH * 0.5, 40, 40);
        _assistant.layer.cornerRadius = 20;
        _assistant.layer.masksToBounds = YES;
        _assistant.windowLevel = UIWindowLevelAlert;
        [_assistant becomeKeyWindow];
        UIImageView* mainImageView= [[UIImageView alloc]init];
        mainImageView.userInteractionEnabled = YES;
        [mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aciontionTouch)]];
        mainImageView.frame = _assistant.bounds;
        mainImageView.animationImages = @[[UIImage imageNamed:@"showVoice-voice1"],[UIImage imageNamed:@"showVoice-voice2"],[UIImage imageNamed:@"showVoice-voice3"],[UIImage imageNamed:@"showVoice-voice4"],[UIImage imageNamed:@"showVoice-voice5"],[UIImage imageNamed:@"showVoice-voice6"],[UIImage imageNamed:@"showVoice-voice7"],[UIImage imageNamed:@"showVoice-voice8"]];
        [mainImageView setAnimationDuration:1.5f];
        [mainImageView setAnimationRepeatCount:0];
        [mainImageView startAnimating];
        [_assistant addSubview:mainImageView];
        [self rotating:mainImageView];
    }
    return _assistant;
}

+ (instancetype)voiceView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.vioceImageView.userInteractionEnabled = YES;
    [self.vioceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)]];
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    if ([_streamer duration] == 0.0) {
        [self.slider setValue:0.0f animated:NO];
    }
    else {
        [self.slider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }

}

#pragma mark - setter && getter
- (void)setVoiceInfo:(MLWord *)voiceInfo{
    _voiceInfo = voiceInfo;
    [self.vioceImageView sd_setImageWithURL:[NSURL URLWithString:voiceInfo.big_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.backgroundColor = [UIColor clearColor];
    }];
    NSInteger second = voiceInfo.voicetime;
    NSInteger minute = second / 60;
    second = second % 60;
    self.timeLenght.text = [NSString stringWithFormat:@"%02zd:%zd",minute,second];
    self.playCount.text = [NSString stringWithFormat:@"%zd播放",voiceInfo.playcount];
    
    if ([self.voiceInfo isVoicePlay]) {
        [self updatePlayButtonContrains];
        self.playCount.hidden = YES;
        self.bottomView.hidden = NO;
        self.slider.hidden = NO;
    }else{
        self.leftConstraint.constant = -33.5;
        self.playCount.hidden = NO;
        self.bottomView.hidden = YES;
        self.slider.hidden = YES;
    }
}
/**
 添加助手按钮
 */
- (void)addAssistant:(BOOL)selected{
    self.assistant.hidden = selected;
}

/**
 按钮旋转
 */
- (void)rotating:(UIImageView *)imageView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 2.设置基本动画属性
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = NSIntegerMax;
    animation.duration = 10;
    // 3.添加动画到图层上
    [imageView.layer addAnimation:animation forKey:nil];
}

#pragma mark - action
- (void)play:(UIButton *)sender {

    sender.selected = !sender.selected;
    [self updatePlayButtonContrains];
    self.playCount.hidden = YES;
    self.bottomView.hidden = NO;
    [self addAssistant:!sender.selected];
    self.slider.hidden = NO;
    self.voiceInfo.voicePlay = YES;
    if (!_onece) {
        [_streamer stop];
        self.track = [Track remoteTracks:self.voiceInfo.voiceuri];
        _onece = YES;
        return;
    }
    if (sender.selected) {
        if ([_streamer status] == DOUAudioStreamerPaused ||
            [_streamer status] == DOUAudioStreamerIdle) {
            [_streamer play];
        }else{
            [_streamer pause];
        }
    }else{
        [_streamer pause];
    }
}
- (void)updatePlayButtonContrains{
    self.leftConstraint.constant = - ([UIScreen mainScreen].bounds.size.width - 33.5) * 0.5;
}
- (void)show{
    MLLargerView *view = [MLLargerView largerView];
    view.topic = self.voiceInfo;
    [view show];
}
- (void)aciontionTouch{
    _assistant = nil;
}
@end
