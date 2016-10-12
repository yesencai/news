//
//  DDTabBarViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/3.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDTabBarViewController.h"
#import "DDtabBar.h"
#import "DDEssenceViewController.h"
#import "DDFriendTrendsViewController.h"
#import "DDMeViewController.h"
#import "DDNewViewController.h"
#import "DDNavigationController.h"
@interface DDTabBarViewController ()

@end

@implementation DDTabBarViewController
+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控制器
    [self setChildViewController:[DDEssenceViewController new] image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon" title:@"精华"];
    
    [self setChildViewController:[DDNewViewController new] image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon" title:@"新帖"];

    [self setChildViewController:[DDFriendTrendsViewController new] image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon" title:@"关注"];

    [self setChildViewController:[DDMeViewController new] image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon" title:@"我"];
    [self setValue:[[DDtabBar alloc]init] forKey:@"tabBar"];
}
-(void)setChildViewController:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    DDNavigationController *nav = [[DDNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
