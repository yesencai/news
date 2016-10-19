//
//  MLVoiceView.h
//  百思不得姐
//
//  Created by Dylan on 2016/10/12.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLWord;
@interface MLVoiceView : UIView
/** pictureInfo */
@property (nonatomic, strong) MLWord *voiceInfo;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playVoiceBtn;
+ (instancetype)voiceView;

@end
