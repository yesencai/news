//
//  DDRemTagTableViewController.m
//  Dylan_01
//
//  Created by Dylan on 16/3/9.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLRemTagTableViewController.h"
#import "JYHttpTool.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MLRemTag.h"
#import "MLRemTagCell.h"
@interface MLRemTagTableViewController ()
@property(nonatomic,strong)NSMutableArray *remTagArray;

@end

@implementation MLRemTagTableViewController
- (NSMutableArray *)remTagArray
{
    if (!_remTagArray) {
        self.remTagArray = [[NSMutableArray alloc] init];
    }
    return _remTagArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = DDColor(233, 233, 233);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parems = [NSMutableDictionary dictionary];
    parems[@"a"] = @"tag_recommend";
    parems[@"action"] = @"sub";
    parems[@"c"] = @"topic";
    [JYHttpTool getPath:@"http://api.budejie.com/api/api_open.php" parameters:parems success:^(id responseObject) {
        
        self.remTagArray = [MLRemTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remTagArray.count;
}

- (MLRemTagCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLRemTagCell *cell = [MLRemTagCell cellWithTableView:tableView];
    cell.remTag = self.remTagArray[indexPath.row];
    return cell;
}

@end
