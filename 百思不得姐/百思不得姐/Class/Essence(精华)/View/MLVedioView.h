//
//  MLVedioView.h
//  百思不得姐
//
//  Created by Dylan on 2016/10/12.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLWord,WMPlayer;
@interface MLVedioView : UIView
//@property (weak, nonatomic) IBOutlet WMPlayer *wmPlayer;
//@property (weak, nonatomic) WMPlayer *wmPlayer;

/** pictureInfo */
@property (nonatomic, strong) MLWord *vedioInfo;
@property (weak, nonatomic) IBOutlet UIImageView *vedioImageView;

+ (instancetype)vedioView;

@end
