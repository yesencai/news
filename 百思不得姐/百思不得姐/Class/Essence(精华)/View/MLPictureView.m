//
//  MLPictureView.m
//  百思不得姐
//
//  Created by Dylan on 16/10/8.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLPictureView.h"
#import <UIImageView+WebCache.h>
#import "MLWord.h"
#import "MLProgressView.h"
#import "MLLargerView.h"
#import "SVProgressHUD.h"
@interface MLPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;

@property (weak, nonatomic) IBOutlet MLProgressView *progressView;
@end
@implementation MLPictureView

+ (instancetype)pictureView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
//    self.autoresizingMask = UIViewAutoresizingNone;
    self.contentImageView.userInteractionEnabled = YES;
    [self.contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)]];
    self.progressView.progressTintColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.progressView.roundedCorners = 5.;
    self.progressView.progressLabel.textColor = [UIColor grayColor];

}
#pragma mark - setter && getter 方法
- (void)setPictureInfo:(MLWord *)pictureInfo{
    _pictureInfo = pictureInfo;

    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:pictureInfo.midde_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.progressView.hidden = NO;
            CGFloat progress = 1.00 * receivedSize / expectedSize;
            if (progress < 0 || progress ==-0) {
                progress = 0;
            }
            [self.progressView setProgress:progress animated:NO];
            self.progressView.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",progress * 100];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.progressView.hidden = YES;
            if (!pictureInfo.bigPicture) {
                return ;
            }
            UIGraphicsBeginImageContextWithOptions(pictureInfo.picureFrame.size, YES, 0.0);
            CGFloat width = pictureInfo.picureFrame.size.width;
            CGFloat height = width * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            self.contentImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }];
    
    self.gifImageView.hidden = ![pictureInfo.midde_image.pathExtension.lowercaseString isEqualToString:@"gif"];
    self.bigButton.hidden = !pictureInfo.bigPicture;
}

#pragma mark - action
- (void)show{
    MLLargerView *view = [MLLargerView largerView];
    view.topic = self.pictureInfo;
    [view show];

}
@end
