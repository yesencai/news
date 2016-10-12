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
@interface MLVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *vioceImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
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
    
}


#pragma mark - action
- (IBAction)play:(UIButton *)sender {
    
}
- (void)show{
    
    MLLargerImageController *largerVC = [MLLargerImageController new];
    largerVC.topic = self.voiceInfo;
    largerVC.modalPresentationStyle = UIModalPresentationPopover;
    largerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:largerVC animated:YES completion:nil];
}
@end
