//
//  DDReccmmendCell.h
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDReccmmend;
@interface DDReccmmendCell : UITableViewCell

@property(nonatomic,strong)DDReccmmend *reccmmend;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
