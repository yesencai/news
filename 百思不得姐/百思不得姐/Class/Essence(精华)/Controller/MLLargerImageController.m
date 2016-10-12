//
//  MLLargerImageController.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/9.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLLargerImageController.h"
#import <UIImageView+WebCache.h>
#import "MLWord.h"
#import "MLProgressView.h"
#import <SVProgressHUD.h>
@interface MLLargerImageController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MLProgressView *progressView;

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;


@end


@implementation MLLargerImageController


#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

#pragma mark - lazy

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (IBAction)close {
    [self dismiss];
}

/**
 转发
 */
- (IBAction)forwarding {
}

/**
 保存到相册
 */
- (IBAction)saveImage {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.progressView.progressTintColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.progressView.roundedCorners = 5.;
    self.progressView.progressLabel.textColor = [UIColor grayColor];

    
    CGFloat pictureW = screenW;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    if (pictureH > screenH) {
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        self.imageView.size = CGSizeMake(pictureW, pictureH);
        self.imageView.centerY = screenH * 0.5;
    }
  
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.big_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
