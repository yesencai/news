//
//  DDGuidePageView.m
//  Dylan_01
//
//  Created by Dylan on 16/3/15.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "DDGuidePageView.h"
@interface DDGuidePageView()
@property(nonatomic,strong)NSString *currentVersion;

@end
NSString *const CFBundleShortVersionString = @"CFBundleShortVersionString";
@implementation DDGuidePageView

+(instancetype)guideInstance{
    return [[self alloc]init];
}
-(instancetype)init{
    if (self = [super init]) {
        
        UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushguidetop"]];
        [self addSubview:topImageView];
        
        UIImageView *midImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushguidemid"]];
        [self addSubview:midImageView];
        midImageView.centerX = [UIScreen mainScreen].bounds.size.width/2;
        midImageView.centerY = [UIScreen mainScreen].bounds.size.height/2;
        
        topImageView.centerX = midImageView.centerX;
        topImageView.y = CGRectGetMinY(midImageView.frame)-topImageView.height-30;
        
        UIImageView *botImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushguidebot"]];
        [self addSubview:botImageView];
        
        botImageView.centerX = midImageView.centerX;
        botImageView.y = CGRectGetMaxY(midImageView.frame);
        botImageView.userInteractionEnabled=  YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 40, 100, 60);
        [botImageView addSubview:btn];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)show{
    
    //当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[CFBundleShortVersionString];
    self.currentVersion = currentVersion;
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]stringForKey:CFBundleShortVersionString];
    if (![currentVersion isEqualToString:lastVersion]) {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        self.frame = window.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        [window addSubview:self];
    }

}
-(void)click{
    
    [UIView animateWithDuration:0.25 animations:^{
        [[NSUserDefaults standardUserDefaults]setObject:self.currentVersion forKey:CFBundleShortVersionString];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
