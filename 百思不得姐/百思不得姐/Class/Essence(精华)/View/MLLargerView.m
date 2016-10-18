//
//  MLLargerView.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/14.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLLargerView.h"
#import "MLProgressView.h"
#import "MLWord.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <POP.h>
@interface MLLargerView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MLProgressView *progressView;
/** imageView */
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation MLLargerView

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
static UIWindow *_largerWindow;
- (void)show{
    _largerWindow = [[UIWindow alloc]init];
    _largerWindow.windowLevel = UIWindowLevelStatusBar;
    _largerWindow.frame = [UIScreen mainScreen].bounds;
    _largerWindow.hidden = NO;
    self.frame = _largerWindow.bounds;
    [_largerWindow addSubview:self];

}
+ (instancetype)largerView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

#pragma mark - lazy

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
        imageView.userInteractionEnabled = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
        [imageView.layer pop_addAnimation:scaleAnimation forKey:nil];
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)setTopic:(MLWord *)topic{
    _topic = topic;
    self.progressView.progressTintColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.progressView.roundedCorners = 5.;
    self.progressView.progressLabel.textColor = [UIColor grayColor];
    
    CGFloat pictureW = screenW;
    CGFloat pictureH = pictureW * topic.height / topic.width;
    if (pictureH > screenH) {
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        self.imageView.size = CGSizeMake(pictureW, pictureH);
        self.imageView.centerY = screenH * 0.5;
    }

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        if (progress < 0 || progress ==-0) {
            progress = 0;
        }
        [self.progressView setProgress:progress animated:NO];
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"下载图片失败"];
            [self dismiss];
        }
    }];

}
- (IBAction)dissmiss:(id)sender {
      [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.imageView.alpha = 0;
        _largerWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _largerWindow = nil;
    }];
}

@end
