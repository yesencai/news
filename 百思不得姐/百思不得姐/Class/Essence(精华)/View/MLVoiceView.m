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
@interface MLVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *vioceImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLenght;
@property (weak, nonatomic) IBOutlet UILabel *playCount;

@end

@implementation MLVoiceView


+ (instancetype)voiceView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.vioceImageView.userInteractionEnabled = YES;
    [self.vioceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)]];
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
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

- (void)updatePlayButtonContrains{
    self.leftConstraint.constant = - ([UIScreen mainScreen].bounds.size.width - 33.5) * 0.5;
}
- (void)show{
    MLLargerView *view = [MLLargerView largerView];
    view.topic = self.voiceInfo;
    [view show];
}

@end
