//
//  DDReccmmendCell.m
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLReccmmendCell.h"
#import "MLReccmmend.h"
@interface MLReccmmendCell()
/**
 *  选择cell红色部分
 */
@property(nonatomic,strong)UIView *selectedView;
@end
@implementation MLReccmmendCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.selectedView.hidden = !selected;
    self.textLabel.textColor = selected ? DDColor(237, 70, 47): DDColor(78, 78, 78);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = DDColor(233, 233, 233);
        self.textLabel.textColor = DDColor(78, 78, 78);
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, 5, self.frame.size.height);
        self.selectedView = view;
        view.backgroundColor = DDColor(237, 70, 47);
        [self.contentView addSubview:view];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"reccmmendCell";
    MLReccmmendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(void)setReccmmend:(MLReccmmend *)reccmmend{
    _reccmmend = reccmmend;
    self.textLabel.text = reccmmend.name;
}
@end
