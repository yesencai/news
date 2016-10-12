//
//  DDMeViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/4.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDMeViewController.h"
#import "DFDViewController.h"
@interface DDMeViewController ()

@end

@implementation DDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDColor(233, 233, 233);
    self.navigationItem.title = @"我的";
    UIBarButtonItem *moon = [UIBarButtonItem itemWithImage:@"mine-moon-icon" heighImage:@"mine-moon-icon-click" action:@selector(clickmoon) target:self];
    UIBarButtonItem *setting = [UIBarButtonItem itemWithImage:@"mine-setting-icon" heighImage:@"mine-setting-icon-click" action:@selector(clicksetting) target:self];
    self.navigationItem.rightBarButtonItems = @[setting,moon];

}
-(void)clickmoon{
    [self.navigationController pushViewController:DFDViewController.new animated:YES];
}
-(void)clicksetting{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
