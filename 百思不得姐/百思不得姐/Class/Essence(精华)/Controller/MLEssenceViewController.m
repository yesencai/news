//
//  DDEssenceViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLEssenceViewController.h"
#import "MLRemTagTableViewController.h"
#import "MLAllTableViewController.h"
#import "MLVedioTableViewController.h"
#import "MLVioceTableViewController.h"
#import "MLPictureTableViewController.h"
#import "MLWordTableViewController.h"
#import "MLScrollView.h"
@interface MLEssenceViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *seleteView;
@property(nonatomic,weak)UIButton *btn;
@property(nonatomic,strong)MLScrollView *contentView;
@property(nonatomic,weak)UIView *titleView;

@end

@implementation MLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setupNavigation];
    //初始化全部自控制器
    [self setupChildViewController];
    //设置scrollView
    [self setupScrollView];
    //设置导航标题
    [self setupTittleView];
}
//初始化子控制器
- (void)setupChildViewController{
    
    MLAllTableViewController *all = [[MLAllTableViewController alloc]init];
    [self addChildViewController:all];
    
    MLVedioTableViewController *video = [[MLVedioTableViewController alloc]init];
    [self addChildViewController:video];

    MLVioceTableViewController *voice = [[MLVioceTableViewController alloc]init];
    [self addChildViewController:voice];

    MLPictureTableViewController *picture = [[MLPictureTableViewController alloc]init];
    [self addChildViewController:picture];
    MLWordTableViewController *word = [[MLWordTableViewController alloc]init];
    [self addChildViewController:word];
}
//设置导航栏
- (void)setupNavigation{
    self.view.backgroundColor = DDColor(233, 233, 233);
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heighImage:@"MainTagSubIconClick" action:@selector(clickTag) target:self];
}
//设置导航标题
- (void)setupTittleView{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    titlesView.width = self.view.width;
    titlesView.height = MLTitleViewH;
    [self.view addSubview:titlesView];
    self.titleView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.seleteView = indicatorView;
    
    // 内部的子标签
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    CGFloat width = titlesView.width / titles.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.btn = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.seleteView.width = button.titleLabel.width;
            self.seleteView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}
//设置
- (void)setupScrollView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    MLScrollView *scrollView = [[MLScrollView alloc]init];
    scrollView.delaysContentTouches =  NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
    [self.view addSubview:scrollView];
     self.contentView = scrollView;
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}
- (void)titleClick:(UIButton *)btn{
    self.btn.enabled = YES;
    btn.enabled = NO;
    self.btn = btn;
    [UIView animateWithDuration:0.25 animations:^{
        self.seleteView.width = btn.titleLabel.width;
        self.seleteView.centerX = btn.centerX;
    }];
    CGPoint offset = self.contentView.contentOffset;
    offset.x = btn.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}

-(void)clickTag{
    MLRemTagTableViewController *tag = [[MLRemTagTableViewController alloc]init];
    [self.navigationController pushViewController:tag animated:YES];
}

#pragma mark-<UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //取出自控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    vc.view.x = scrollView.contentOffset.x;
    [scrollView addSubview:vc.view];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index =scrollView.contentOffset.x / scrollView.width;
   [self titleClick:(UIButton *)self.titleView.subviews[index]];
    
}
@end
