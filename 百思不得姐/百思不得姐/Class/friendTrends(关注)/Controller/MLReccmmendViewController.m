//
//  DDReccmmendViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLReccmmendViewController.h"
#import "JYHttpTool.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "MLReccmmend.h"
#import "MLReccmmendCell.h"
#import "MLReccmmendUser.h"
#import "MLReccmmendUserCell.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
@interface MLReccmmendViewController()<UITableViewDataSource,UITableViewDelegate>
/**
 *  左边tableView
 */
@property(nonatomic,strong)UITableView *leftTableView;
/**
 *  右边tableview
 */
@property(nonatomic,strong)UITableView *rightTableView;

/**
 *  数据源数组
 */
@property(nonatomic,strong)NSMutableArray *leftDataSource;

/**
 *  右边数据源数组
 */
@property(nonatomic,strong)NSMutableArray *rightDataSource;

@end
@implementation MLReccmmendViewController
- (NSMutableArray *)leftDataSource
{
    if (!_leftDataSource) {
        self.leftDataSource = [[NSMutableArray alloc] init];
    }
    return _leftDataSource;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = DDColor(233, 233, 233);
    [self creatTableView];
    [self creatRfresh];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [JYHttpTool getPath:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(id responseObject) {
        DDLog(@"resposeObject=%@",responseObject);
        // 服务器返回的JSON数据
        self.leftDataSource = [MLReccmmend mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTableView reloadData];
            [SVProgressHUD dismiss];
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            if ([self.leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                [self.leftTableView.delegate tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)creatTableView{
    
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 70, self.view.frame.size.height) style:UITableViewStylePlain];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    self.leftTableView = leftTableView;
    [self setExtraCellLineHidden:leftTableView];
    [self.view addSubview:self.leftTableView];
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, 0, self.view.frame.size.width-70, self.view.frame.size.height) style:UITableViewStylePlain];
    rightTableView.backgroundColor = [UIColor clearColor];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.rowHeight = 70;
    [self setExtraCellLineHidden:rightTableView];
    [self.view addSubview:rightTableView];
    self.rightTableView = rightTableView;

    
}
//创建刷新控件
-(void)creatRfresh{
     self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreUsers)];
    self.rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}
-(void)loadMoreUsers{
    
    MLReccmmend *reccmmed = self.leftDataSource[[self.leftTableView indexPathForSelectedRow].row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(reccmmed.id);
    parameters[@"page"] = @(++reccmmed.currenPage);
    [JYHttpTool getPath:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(id responseObject) {
        DDLog(@"resposeObject=%@",responseObject);
        //服务器返回的JSON数据
        NSArray *array = [MLReccmmendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [reccmmed.reccmmendUserArray addObjectsFromArray:array];
        if (reccmmed.total ==reccmmed.reccmmendUserArray.count) {
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.rightTableView.mj_footer endRefreshing];
        }

        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)refreshMoreUsers{

    MLReccmmend *reccmmed = self.leftDataSource[[self.leftTableView indexPathForSelectedRow].row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(reccmmed.id);
    [JYHttpTool getPath:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(id responseObject) {
        DDLog(@"resposeObject=%@",responseObject);
        //服务器返回的JSON数据
        reccmmed.reccmmendUserArray = [MLReccmmendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        reccmmed.total = [responseObject[@"total"] integerValue];
        reccmmed.currenPage = 1;
        if (reccmmed.total ==reccmmed.reccmmendUserArray.count) {
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.rightTableView.mj_footer endRefreshing];
        }
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        [self.rightTableView.mj_header endRefreshing];
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.rightTableView.mj_header endRefreshing];
    [self.rightTableView.mj_footer endRefreshing];
    if (tableView == self.leftTableView) {
        MLReccmmend *r = self.leftDataSource[[self.leftTableView indexPathForSelectedRow].row];
        if (r.reccmmendUserArray.count>0) {
            if (r.total ==r.reccmmendUserArray.count) {
                [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.rightTableView.mj_footer endRefreshing];
            }
            [self.rightTableView reloadData];
        }else{
            self.rightTableView.mj_footer.hidden = YES;
            [self.rightTableView.mj_header beginRefreshing];
            [self.rightTableView reloadData];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.leftTableView) {
        return self.leftDataSource.count;
    }else{
        NSInteger index = [self.leftTableView indexPathForSelectedRow].row;
        self.rightTableView.mj_footer.hidden = self.leftDataSource.count==0;
        if (self.leftDataSource.count>0) {
            MLReccmmend *r = self.leftDataSource[index];
            return r.reccmmendUserArray.count;
        }
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        MLReccmmendCell *reccmmend = [MLReccmmendCell cellWithTableView:tableView];
        reccmmend.reccmmend = self.leftDataSource[indexPath.row];
        return reccmmend;
    }else{
        MLReccmmendUserCell *userCell = [MLReccmmendUserCell cellWithTableView:tableView];
        MLReccmmend *r = self.leftDataSource[[self.leftTableView indexPathForSelectedRow].row];
        userCell.user = r.reccmmendUserArray[indexPath.row];
        return userCell;
    }
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)dealloc{
    [JYHttpTool cancelAllOperation];
    
}
@end
