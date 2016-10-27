//
//  MLComentCell.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLCommentCell.h"
#import "MLComment.h"
#import "MLUser.h"
#import <UIImageView+WebCache.h>
@interface MLCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UILabel *contenLable;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLable;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation MLCommentCell

- (void)setComment:(MLComment *)comment{
    _comment = comment;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.frofile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nickNameLable.text = comment.user.username;
    NSString *sexImage;
    self.contenLable.text = comment.content;
    if ([comment.user.sex isEqualToString:@"m"]) {
        sexImage = @"Profile_manIcon";
    }else{
        sexImage = @"Profile_womanIcon";
    }
    self.sexImageView.image = [UIImage imageNamed:sexImage];
    self.praiseCountLable.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    self.playButton.hidden = !(comment.voiceuri.length>0);
    [self.playButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
