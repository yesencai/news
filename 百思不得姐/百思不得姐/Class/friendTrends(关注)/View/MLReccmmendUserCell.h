//
//  DDReccmmendUserCell.h
//  Dylan_01
//
//  Created by Dylan on 16/3/6.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLReccmmendUser;
@interface MLReccmmendUserCell : UITableViewCell

@property(nonatomic,strong)MLReccmmendUser *user;

@property(nonatomic,assign)NSInteger cellHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
