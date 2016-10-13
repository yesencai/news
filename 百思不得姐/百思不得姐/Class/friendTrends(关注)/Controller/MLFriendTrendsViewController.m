//
//  DDFriendTrendsViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLFriendTrendsViewController.h"
#import "MLReccmmendViewController.h"
#import "MLNavigationController.h"
#import "MLLoginRegistViewController.h"
@interface MLFriendTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation MLFriendTrendsViewController

- (IBAction)LoginUp:(id)sender {
    MLLoginRegistViewController *loginRegist = [[MLLoginRegistViewController alloc]init];
    [self presentViewController:loginRegist animated:YES completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDColor(233, 233, 233);
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" heighImage:@"friendsRecommentIcon-click" action:@selector(clickFriendTrends) target:self];
}
-(void)clickFriendTrends{
    MLReccmmendViewController *reccmmend = [MLReccmmendViewController new];
    [self.navigationController pushViewController:reccmmend animated:YES];
}
@end
