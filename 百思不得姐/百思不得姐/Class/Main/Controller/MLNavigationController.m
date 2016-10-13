//
//  DDNavigationController.m
//  百思不得姐
//
//  Created by Dylan on 16/3/3.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLNavigationController.h"

@interface MLNavigationController ()

@end

@implementation MLNavigationController
+ (void)initialize
{
    if (self == [MLNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearance];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        bar.translucent = NO;
        NSDictionary *dict = @{
                               NSForegroundColorAttributeName:[UIColor blackColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]
                               };
        [bar setTitleTextAttributes:dict];
        [bar setTintColor:[UIColor blackColor]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
}
@end
