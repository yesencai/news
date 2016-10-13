//
//  DDReccmmendUserCell.m
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLReccmmendUserCell.h"
#import "MLReccmmendUser.h"
#import <UIImageView+WebCache.h>
#import "NSString+Size.h"
#import <Masonry.h>
@interface MLReccmmendUserCell()
/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *headImageView;
/**
 *  昵称
 */
@property(nonatomic,strong)UILabel *nickNameLable;
/**
 *  粉丝数
 */
@property(nonatomic,strong)UILabel *fansCountLable;
/**
 *  关注按钮
 */
@property(nonatomic,strong)UIButton *focusBtn;

@end
@implementation MLReccmmendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *iamgeView = [[UIImageView alloc]init];
        self.headImageView = iamgeView;
        iamgeView.frame = CGRectMake(10, 10, 50, 50);
        iamgeView.layer.cornerRadius = 50/2.;
        [self.contentView addSubview:iamgeView];
        
        //昵称
        UILabel *nickNameLable = [[UILabel alloc]init];
        self.nickNameLable = nickNameLable;
        self.nickNameLable.textColor = [UIColor blackColor];
        self.nickNameLable.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nickNameLable];
        
        //粉丝数
        UILabel *fansCouthLable = [[UILabel alloc]init];
        self.fansCountLable = fansCouthLable;
        fansCouthLable.textColor = [UIColor grayColor];
        fansCouthLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:fansCouthLable];

        //关注btn
        UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.focusBtn = focusBtn;
        focusBtn.width = 51;
        focusBtn.height = 25;
        focusBtn.x = self.width - focusBtn.width - 85;
        DDLog(@"self.width=%f",self.width);
        [focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [focusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [focusBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
        focusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [focusBtn setBackgroundImage:[UIImage imageNamed:@"FollowBtnBg"] forState:UIControlStateNormal];
        [self.contentView addSubview:focusBtn];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MLReccmmendUserCell";
    MLReccmmendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(void)setUser:(MLReccmmendUser *)user{
    _user = user;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nickNameLable.text = user.screen_name;
    CGSize size = [NSString sizeWithText:self.nickNameLable.text font:self.nickNameLable.font];
    self.nickNameLable.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.y, size.width, size.height);
    
    self.fansCountLable.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    CGSize fansSize = [NSString sizeWithText:self.fansCountLable.text font:self.fansCountLable.font];
    
    self.fansCountLable.frame = CGRectMake(self.nickNameLable.x, CGRectGetMaxY(self.headImageView.frame)-15, fansSize.width, fansSize.height);
    self.cellHeight = CGRectGetMaxY(self.headImageView.frame)+15;
    
    self.focusBtn.centerY = self.cellHeight/2;

}
-(void)focusClick{
    
}
@end
