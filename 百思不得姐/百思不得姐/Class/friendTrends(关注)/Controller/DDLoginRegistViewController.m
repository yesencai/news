//
//  DDLoginRegistViewController.m
//  百思不得姐
//
//  Created by Dylan on 16/9/18.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "DDLoginRegistViewController.h"

@interface DDLoginRegistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *regiterView;

@end

@implementation DDLoginRegistViewController
- (IBAction)clickRegister:(UIButton *)sender {
    BOOL max = self.backView.frame.origin.x >= 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(max ? -self.backView.bounds.size.width : 0, 0);
        self.regiterView.transform = CGAffineTransformMakeTranslation(max ? -self.regiterView.bounds.size.width : 0,0);
    } completion:^(BOOL finished) {
        [sender setTitle:max ? @"快速登录" : @"快速注册" forState:UIControlStateNormal];
    }];
}
- (IBAction)clickCloseButtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
