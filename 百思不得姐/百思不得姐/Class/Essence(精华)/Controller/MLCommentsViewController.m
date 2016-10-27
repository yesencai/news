//
//  MLCommentsViewController.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/25.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLCommentsViewController.h"
#import "MLWordCell.h"
#import "UIBarButtonItem+DDBarButtonItem.h"
#import <Masonry.h>
#import "MLWord.h"
#import "JYHttpTool.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MLUser.h"
#import "MLComment.h"
#import "MLCommentCell.h"
static NSString *commentId = @"commentId";

@interface MLCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewBottomConstraint;
/** 热门评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
@end

@implementation MLCommentsViewController

#pragma mark - lazy
- (NSMutableArray *)latestComments
{
    if (!_latestComments) {
        _latestComments = [NSMutableArray array];
    }
    return _latestComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNavigation];
    //添加通知
    [self addNotification];
    //设置头部视图
    [self setHeadView];
    //初始化刷新控件
    [self setRefresh];
    //获取评论数
    [self refresh];

}
#pragma mark - setUI
- (void)setNavigation{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" heighImage:@"comment_nav_item_share_icon_click" action:@selector(actionClick) target:self];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLCommentCell class]) bundle:nil] forCellReuseIdentifier:commentId];
}
- (void)setHeadView{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    MLWordCell *cell = [MLWordCell cell];
    cell.word = self.ml_word;
    cell.height = self.ml_word.cellHeight;
    headView.frame = CGRectMake(0, 0,self.view.bounds.size.width - 20 , self.ml_word.cellHeight);
    [headView addSubview:cell];
    self.tableView.tableHeaderView = headView;
}

/**
 添加刷新控件
 */
- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

}

#pragma mark - Notification
/**
 添加通知
 */
- (void)addNotification{
    [MLNotification addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 删除通知
 */
- (void)removeNotification{
    [MLNotification removeObserver:self];
}
#pragma mark - action
- (void)actionClick{

}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.ViewBottomConstraint.constant = MLScreenH - frame.origin.y;
    }];
}

/**
 刷新
 */
- (void)refresh{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.ml_word.ID;
    parameters[@"hot"] = @"1";
    [JYHttpTool getPath:ml_comment_url parameters:parameters success:^(id responseObject) {
        self.hotComments = [MLComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latestComments = [MLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            [self.tableView.mj_footer  endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 加载更多
 */
- (void)loadMore{
    
}
#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hotComments.count) {
        return 2;
    }
    if (self.latestComments.count) {
        return 1;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return self.hotComments.count ? @"热门评论" : @"最新评论";
    }
    return @"最新评论";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *comments = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [[UILabel alloc]init];
    label.text = comments;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.hotComments.count>0 ? self.hotComments.count : self.latestComments.count;
    }
    if (section==1) {
        return self.latestComments.count;
    }
    return 0;
}
- (MLCommentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentId];
    MLComment *comment = [self commentsIndexPath:indexPath];
    cell.comment = comment;
    return cell;
}

- (NSArray *)comentsInSection:(NSInteger)section{
    if (section==0) {
        return self.hotComments.count>0 ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (MLComment *)commentsIndexPath:(NSIndexPath *)indexPath{
    if ([self comentsInSection:indexPath.section].count>0) {
        return [self comentsInSection:indexPath.section][indexPath.row];
    }
    return nil;
}
- (void)dealloc{
    [self removeNotification];
}
@end
