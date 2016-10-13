//
//  DDRemTagCell.h
//  Dylan_01
//
//  Created by Dylan on 16/3/9.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLRemTag;
@interface MLRemTagCell : UITableViewCell
@property(nonatomic,strong)MLRemTag *remTag;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
