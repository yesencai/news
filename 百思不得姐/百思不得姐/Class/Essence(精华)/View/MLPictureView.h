//
//  MLPictureView.h
//  百思不得姐
//
//  Created by Dylan on 16/10/8.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLWord;
@interface MLPictureView : UIView
/** pictureInfo */
@property (nonatomic, strong) MLWord *pictureInfo;

+ (instancetype)pictureView;
@end
