//
//  MLWordCell.m
//  百思不得姐
//
//  Created by Dylan on 16/9/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLWordCell.h"
#import <UIImageView+WebCache.h>
#import "MLWord.h"
#import "MLPictureView.h"
#import "MLVoiceView.h"
#import "MLVedioView.h"
@interface MLWordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *sinaV;
@property (weak, nonatomic) IBOutlet UILabel *text_Lable;
/** 图片显示 */
@property (nonatomic, weak) MLPictureView *pictureView;
/** 语音显示 */
@property (nonatomic, weak) MLVoiceView *voiceView;
/** 视频显示 */
@property (nonatomic, weak) MLVedioView *vedioView;

@end

@implementation MLWordCell

#pragma mark - lazy 

/**
 图片
 */
- (MLPictureView *)pictureView
{
    if (!_pictureView) {
        MLPictureView *pictureView = [MLPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

/**
 声音
 */
- (MLVoiceView *)voiceView
{
    if (!_voiceView) {
        MLVoiceView *voiceView = [MLVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
/**
 视频
 */
- (MLVedioView *)vedioView
{
    if (!_vedioView) {
        MLVedioView *vedioView = [MLVedioView vedioView];
        [self.contentView addSubview:vedioView];
        _vedioView = vedioView;
    }
    return _vedioView;
}


#pragma mark - setter && getter方法重写

- (void)setWord:(MLWord *)word{
    _word = word;
    self.sinaV.hidden = !word.isSina_v;
    //设置头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:word.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //设置昵称
    self.nickNameLable.text = word.name;
    //时间
    self.timeLable.text = word.create_time;
    //内容
    self.text_Lable.text = word.text;
    //顶的数量
    [self.topButton setTitle:[self calculateTitleCount:word.ding] forState:UIControlStateNormal];
    //踩的数量
    [self.caiButton setTitle:[self calculateTitleCount:word.cai] forState:UIControlStateNormal];
    //转发的数量
    [self.shareButton setTitle:[self calculateTitleCount:word.repost] forState:UIControlStateNormal];
    //评论数量
    [self.commentButton setTitle:[self calculateTitleCount:word.comment] forState:UIControlStateNormal];

    if (word.type == MLTopicTypePicture) {
        self.pictureView.pictureInfo = word;
        self.pictureView.frame = word.picureFrame;
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.vedioView.hidden = YES;
    }else if (word.type == MLTopicTypeVioce) {
        self.voiceView.voiceInfo = word;
        self.voiceView.frame = word.voiceFrame;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.vedioView.hidden = YES;
    }else if (word.type == MLTopicTypeVedio) {
        self.vedioView.vedioInfo = word;
        self.vedioView.frame = word.vedioFrame;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.vedioView.hidden = NO;
    }else{
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.vedioView.hidden = YES;
    }

    
}

/**
 计算title的数量

 @param count title原数量

 @return 返回新数量
 */
- (NSString *)calculateTitleCount:(NSInteger)count{
    return count > 10000 ? [NSString stringWithFormat:@"%.f万",count / 10000.] : [NSString stringWithFormat:@"%zd",count];
}
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= margin;
    frame.origin.y += margin;
    super.frame = frame;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.;
    self.headImageView.layer.cornerRadius = 25.;
    self.headImageView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.text_Lable.numberOfLines = 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
