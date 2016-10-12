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

@end

@implementation MLWordCell

#pragma mark - lazy 

- (MLPictureView *)pictureView
{
    if (!_pictureView) {
        MLPictureView *pictureView = [MLPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
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
