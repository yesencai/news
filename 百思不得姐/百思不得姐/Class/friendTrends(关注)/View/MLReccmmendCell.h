//
//  DDReccmmendCell.h
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLReccmmend;
@interface MLReccmmendCell : UITableViewCell

@property(nonatomic,strong)MLReccmmend *reccmmend;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
