//
//  MLSendPostViewController.m
//  百思不得姐
//
//  Created by Dylan on 2016/10/10.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLSendPostViewController.h"
#import "MLVerticalButton.h"
#import <POP.h>
@interface MLSendPostViewController ()
/** 所有按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
/** sloganImageView */
@property (nonatomic, weak) UIImageView *sloganImageView;

@end
static CGFloat const ml_durationTitme = 0.1;
#define MLScreenW [UIScreen mainScreen].bounds.size.width
#define MLScreenH [UIScreen mainScreen].bounds.size.height

@implementation MLSendPostViewController

#pragma mark - lazy 
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}
- (UIImageView *)sloganImageView
{
    if (!_sloganImageView) {
        UIImageView *sloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
        sloganImageView.centerX = MLScreenW * 0.5;
        sloganImageView.y = MLScreenH * 0.2 - MLScreenH;
        [self.view addSubview:sloganImageView];
        _sloganImageView = sloganImageView;
    }
    return _sloganImageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化控件
    [self setUpUI];
    
}

/**
 初始化控件
 */
- (void)setUpUI{
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    int count = 6;
    CGFloat buttonW = 70;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (MLScreenH - buttonH * 2) * 0.5;
    CGFloat buttonStartX = 30;
    CGFloat colMargin = (MLScreenW - 2 * buttonStartX - 3 * buttonW) * 0.5;
    CGFloat rowMargin = 20;
    int maxCol = 3;
    for (int i =0; i<count; i++) {
        MLVerticalButton *verticalBtn = [[MLVerticalButton alloc]init];
        [verticalBtn setTitle:titles[i] forState:UIControlStateNormal];
        [verticalBtn addTarget:self action:@selector(clickVerticalBtn:) forControlEvents:UIControlEventTouchUpInside];
        verticalBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        [verticalBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
        [verticalBtn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        int row = i / maxCol;
        int col = i % maxCol;
        CGFloat verticalBtnX = buttonStartX + (buttonW + colMargin) * col;
        CGFloat verticalBtnY = buttonStartY + (buttonH + rowMargin) * row;
        CGFloat verticalBtnStarY =  buttonH - MLScreenH;
        [self.view addSubview:verticalBtn];
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.springBounciness = 8.;
        animation.springSpeed = 8.;
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(verticalBtnX, verticalBtnStarY, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(verticalBtnX, verticalBtnY, buttonW, buttonH)];
        animation.beginTime = CACurrentMediaTime() + ml_durationTitme * i;
        [verticalBtn pop_addAnimation:animation forKey:nil];
        [self.buttons addObject:verticalBtn];
        
    }
    CGFloat centerX = MLScreenW * 0.5;
    CGFloat centerStarY = MLScreenH * 0.2;
    POPSpringAnimation *animationSlogan = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animationSlogan.springSpeed = 10.;
    animationSlogan.springBounciness = 10.;
    animationSlogan.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX,centerStarY - MLScreenH)];
    animationSlogan.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX,centerStarY)];
    animationSlogan.beginTime = CACurrentMediaTime() + ml_durationTitme * images.count;
    [animationSlogan setCompletionBlock:^(POPAnimation * animat, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    [self.sloganImageView pop_addAnimation:animationSlogan forKey:nil];
}

#pragma mark - action
- (IBAction)dismiss {
    [self dismissCompletion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCompletion:nil];
}

#pragma mark - action
- (void)clickVerticalBtn:(MLVerticalButton *)button{
    [self dismissCompletion:^{
        NSLog(@"s%s",__func__);
    }];
}

- (void)dismissCompletion:(void(^)())completion{
    
    self.view.userInteractionEnabled = NO;
    CGFloat buttonW = 70;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (MLScreenH - buttonH * 2) * 0.5;
    CGFloat buttonStartX = 30;
    CGFloat colMargin = (MLScreenW - 2 * buttonStartX - 3 * buttonW) * 0.5;
    CGFloat rowMargin = 20;
    NSInteger maxCol = 3;
    [_buttons enumerateObjectsUsingBlock:^(MLVerticalButton  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger row = idx / maxCol;
        NSInteger col = idx % maxCol;
        CGFloat verticalBtnX = buttonStartX + (buttonW + colMargin) * col;
        CGFloat verticalBtnY = buttonStartY + (buttonH + rowMargin) * row;
        CGFloat verticalBtnStarY = MLScreenH + buttonH;
        
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(verticalBtnX, verticalBtnY, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(verticalBtnX, verticalBtnStarY, buttonW, buttonH)];
        animation.beginTime = CACurrentMediaTime() + ml_durationTitme * idx;
        [obj pop_addAnimation:animation forKey:nil];
        
    }];
    
    POPBasicAnimation *animationSlogan = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animationSlogan.fromValue = @(MLScreenH * 0.2);
    animationSlogan.toValue = @(MLScreenH);
    animationSlogan.beginTime = CACurrentMediaTime() + ml_durationTitme * _buttons.count;
    [animationSlogan setCompletionBlock:^(POPAnimation *anima, BOOL finished) {
        !completion ? : completion();
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.sloganImageView.layer pop_addAnimation:animationSlogan forKey:nil];
    
}


@end
