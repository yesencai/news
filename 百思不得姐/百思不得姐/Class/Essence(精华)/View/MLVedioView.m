//
//  MLVedioView.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/12.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLVedioView.h"
#import "MLWord.h"
#import <UIImageView+WebCache.h>
#import "WMPlayer.h"
@interface MLVedioView ()
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *timeLenght;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end
@implementation MLVedioView

+ (instancetype)vedioView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.vedioImageView.userInteractionEnabled = YES;
}

#pragma mark - setter && getter方法
- (void)setVedioInfo:(MLWord *)vedioInfo{
    _vedioInfo = vedioInfo;
    [self.vedioImageView sd_setImageWithURL:[NSURL URLWithString:vedioInfo.big_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.backgroundColor = [UIColor clearColor];
    }];
    NSInteger second = vedioInfo.vodiotime;
    NSInteger minute = second / 60;
    second = second % 60;
    self.timeLenght.text = [NSString stringWithFormat:@"%02zd:%zd",minute,second];
    self.playCount.text = [NSString stringWithFormat:@"%zd播放",vedioInfo.playcount];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WMPlayer class]]) {
            if (vedioInfo.isVedioPlay) {
                obj.hidden = NO;
            }else{
               obj.hidden = YES;
            }

        }
    }];

}
#pragma mark - action

@end
