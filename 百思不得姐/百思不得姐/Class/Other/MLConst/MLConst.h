//
//  MLConst.h
//  百思不得姐
//
//  Created by Dylan on 16/9/27.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MLTopicType){
    MLTopicTypeWord = 29,                     //段子
    MLTopicTypeVioce = 31,                    //声音
    MLTopicTypeVedio = 41,                    //视频
    MLTopicTypePicture = 10,                  //图片
    MLTopicTypeAll = 1,                       //全部
};

//标题的高度
extern CGFloat const MLTitleViewH;
//头像的高度
extern CGFloat const MLHeadImageH;
//头像距离顶部的间距
extern CGFloat const MLHeadImageSpacing;
//底部工具条的高度
extern CGFloat const MLButtomToolViewH;
//图片帖子的最大高度
extern CGFloat const MLPictureMaxHeight;
//图片帖子的最大高度
extern CGFloat const MLPictureNormalHeight;


