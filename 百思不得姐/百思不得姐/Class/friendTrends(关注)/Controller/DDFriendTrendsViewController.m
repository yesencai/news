//
//  DDFriendTrendsViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDFriendTrendsViewController.h"
#import "DDReccmmendViewController.h"
#import "DDNavigationController.h"
#import "DDLoginRegistViewController.h"
@interface DDFriendTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation DDFriendTrendsViewController

- (IBAction)LoginUp:(id)sender {
    DDLoginRegistViewController *loginRegist = [[DDLoginRegistViewController alloc]init];
    [self presentViewController:loginRegist animated:YES completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDColor(233, 233, 233);
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" heighImage:@"friendsRecommentIcon-click" action:@selector(clickFriendTrends) target:self];
}
-(void)clickFriendTrends{
    DDReccmmendViewController *reccmmend = [DDReccmmendViewController new];
    [self.navigationController pushViewController:reccmmend animated:YES];
}
@end
