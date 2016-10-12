//
//  DDRemTagCell.h
//  Dylan_01
//
//  Created by Dylan on 16/3/9.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDRemTag;
@interface DDRemTagCell : UITableViewCell
@property(nonatomic,strong)DDRemTag *remTag;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
