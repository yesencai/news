//
//  MLBaseNewsViewController.m
//  Dylan_01
//
//  Created by Dylan on 16/3/16.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLBaseNewsViewController.h"
#import "JYHttpTool.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MLWord.h"
#import "MLWordCell.h"

//获取帖子数据URL
static NSString *const ml_word_url = @"http://api.budejie.com/api/api_open.php";
@interface MLBaseNewsViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 最大时间 */
@property (nonatomic, copy) NSString *maxtime;
/** 用来判断刷新和加载 */
@property (nonatomic, strong) NSDictionary *parameters;

@end

@implementation MLBaseNewsViewController

#pragma mark - 懒加载

/**
 帖子数组懒加载
 
 @return 帖子数组
 */
- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [[NSMutableArray alloc] init];
    }
    return _topics;
}


#pragma mark - controller生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    //初始化刷新控件
    [self setRefresh];
    
}

#pragma mark - 控件初始化
static NSString *const MLWordCellId = @"topic";
/**
 控件初始化
 */
- (void)setTableView{
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, bottom + 64, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLWordCell class]) bundle:nil] forCellReuseIdentifier:MLWordCellId];
}
/**
 刷新控件初始化
 */
- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark - 数据处理
/**
 加载新数据
 */
- (void)loadNewData{
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    self.parameters = parameters;
    //获取帖子数据
    [JYHttpTool getPath:ml_word_url parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.parameters!=parameters) {
            return ;
        }
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *array = responseObject[@"list"];
        if (array.count<=0 || [array isKindOfClass:[NSNull class]]) {
            return ;
        }
        self.topics = [MLWord mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.page = 0;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.parameters!=parameters) {
            return ;
        }
        [self.tableView.mj_header endRefreshing];
        DDLog(@"error=%zd",error.code);
    }];
}

/**
 加载更多数据
 */
- (void)loadMoreData{
    [self.tableView.mj_header endRefreshing];
    self.page ++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"tpye"] = @(self.type);
    parameters[@"page"] = @(self.page);
    parameters[@"maxTime"] = self.maxtime;
    self.parameters = parameters;
    //获取帖子数据
    [JYHttpTool getPath:ml_word_url parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.parameters!=parameters) {
            return ;
        }
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *array = responseObject[@"list"];
        if (array.count<=0 || [array isKindOfClass:[NSNull class]]) {
            return ;
        }
        NSArray *moreDatas = [MLWord mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreDatas];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.parameters!=parameters) {
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        self.page --;
        DDLog(@"error=%zd",error.code);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topics.count;
}

- (MLWordCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLWordCell *cell = [tableView dequeueReusableCellWithIdentifier:MLWordCellId];
    MLWord *word = self.topics[indexPath.row];
    cell.word = word;
    return cell;
}

#pragma mark - Table view dalegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLWord *word = self.topics[indexPath.row];
    return word.cellHeight;
}

#pragma mark - 事件action
/**
 刷新控件实现方法
 */
- (void)refresh{
    //获取数据
    [self loadNewData];
}

/**
 加载更多
 */
- (void)loadMore{
    [self loadMoreData];
}

@end
