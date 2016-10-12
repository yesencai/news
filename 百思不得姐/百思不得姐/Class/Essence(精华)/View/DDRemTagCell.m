//
//  DDRemTagCell.m
//  Dylan_01
//
//  Created by Dylan on 16/3/9.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDRemTagCell.h"
#import "DDRemTag.h"
#import <UIImageView+WebCache.h>
#import "NSString+Size.h"
@interface DDRemTagCell()

/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *imageListImageView;

/**
 *  名字
 */
@property(nonatomic,strong)UILabel *themeNameLable;

/**
 *  关注数
 */
@property(nonatomic,strong)UILabel *subNumberLable;

/**
 *  关注按钮
 */
@property(nonatomic,strong)UIButton *focusBtn;

@end
@implementation DDRemTagCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imageListImageView = [[UIImageView alloc]init];
        imageListImageView.x = 10;
        imageListImageView.y = 10;
        imageListImageView.width = 50;
        imageListImageView.height = 50;
        self.imageListImageView = imageListImageView;
        [self.contentView addSubview:imageListImageView];
        
        UILabel *themeNameLable = [[UILabel alloc]init];
        themeNameLable.font = [UIFont systemFontOfSize:15];
        themeNameLable.textColor = [UIColor blackColor];
        themeNameLable.y = imageListImageView.y;
        themeNameLable.x = CGRectGetMaxX(imageListImageView.frame)+10;
        self.themeNameLable = themeNameLable;
        [self.contentView addSubview:themeNameLable];
        
        UILabel *subNumberLable = [[UILabel alloc]init];
        subNumberLable.font = [UIFont systemFontOfSize:13];
        subNumberLable.textColor = [UIColor grayColor];
        subNumberLable.x = themeNameLable.x;
        subNumberLable.y = CGRectGetMaxY(themeNameLable.frame)+30;
        self.subNumberLable = subNumberLable;
        [self.contentView addSubview:subNumberLable];
        
        UIButton *fBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fBtn setBackgroundImage:[UIImage imageNamed:@"FollowBtnBg"] forState:UIControlStateNormal];
        [fBtn setBackgroundImage:[UIImage imageNamed:@"FollowBtnClickBg"] forState:UIControlStateHighlighted];
        [fBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [fBtn setTitle:@"+ 订阅" forState:UIControlStateNormal];
        fBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
        fBtn.width = fBtn.currentBackgroundImage.size.width;
        fBtn.height = fBtn.currentBackgroundImage.size.height;
        self.focusBtn = fBtn;
        [self.contentView addSubview:fBtn];

    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{

    static NSString *ID = @"DDRemTagCell";
    DDRemTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setRemTag:(DDRemTag *)remTag{
    _remTag = remTag;
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:remTag.image_list] placeholderImage:[UIImage imageNamed:@""]];
    self.themeNameLable.text = remTag.theme_name;
    CGSize themeNameSize = [NSString sizeWithText:self.themeNameLable.text font:self.themeNameLable.font];
    self.themeNameLable.width = themeNameSize.width;
    self.themeNameLable.height = themeNameSize.height;
    
    NSString *str = nil;
    if (remTag.sub_number.intValue<10000) {
        str = remTag.sub_number;
    }else{
        str = [NSString stringWithFormat:@"%.f万",[remTag.sub_number intValue ]/10000.];
    }
    self.subNumberLable.text = [NSString stringWithFormat:@"%@人关注",str];
    CGSize subSize = [NSString sizeWithText:self.subNumberLable.text font:self.subNumberLable.font];
    self.subNumberLable.width = subSize.width;
    self.subNumberLable.height = subSize.height;
    
    self.focusBtn.centerY = 35;
    self.focusBtn.x = self.contentView.width - self.focusBtn.width - 20;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 10;
    frame.size.width -=frame.origin.x * 2;
    frame.size.height -= 1;
    [super setFrame:frame];
}
@end
