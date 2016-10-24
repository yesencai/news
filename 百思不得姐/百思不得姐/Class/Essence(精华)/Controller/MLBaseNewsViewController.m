//
//  MLBaseNewsViewController.m
//  Dylan_01
//
//  Created by Dylan on 16/3/16.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import "MLBaseNewsViewController.h"
#import "JYHttpTool.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MLWord.h"
#import "MLWordCell.h"
#import "MLVedioView.h"
#import "WMPlayer.h"
#import <DOUAudioStreamer.h>
#import "Track.h"
#import "Track+Provider.h"
#import "MLVoiceView.h"

#define MLScreenH [UIScreen mainScreen].bounds.size.height
#define MLScreenW [UIScreen mainScreen].bounds.size.width
#define MLNavigationH 64
#define MLToolBarH 44


//获取帖子数据URL
static NSString *const ml_word_url = @"http://api.budejie.com/api/api_open.php";
@interface MLBaseNewsViewController ()<MLWordCellDelegate,WMPlayerDelegate>
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 最大时间 */
@property (nonatomic, copy) NSString *maxtime;
/** 用来判断刷新和加载 */
@property (nonatomic, strong) NSDictionary *parameters;
/** 注释 */
@property (nonatomic, strong) WMPlayer *wmPlayer;
/** 索引 */
@property (nonatomic, strong) NSIndexPath* ml_indexPath;
/** MLVedioView */
@property (nonatomic, strong) MLVedioView *vedioView;
/** 小窗口 */
@property (nonatomic, assign,getter=isSmallScreen) BOOL smallScreen;
/** 音频播放流 */
@property (nonatomic, strong) DOUAudioStreamer *streamer;
/** tracks */
@property (nonatomic, strong) Track *track;
/** MLVoiceView */
@property (nonatomic, strong) MLVoiceView *voiceView;
/**  */
@property (nonatomic, assign) BOOL isPlay;
/** MLWord *word */
@property (nonatomic, strong) MLWord *word;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 滑动空间 */
@property (nonatomic, strong) UISlider *ml_slider;

@end
static UIWindow *_assistant;
static NSString *const MLWordCellId = @"ml_dylan_topic";

@implementation MLBaseNewsViewController

#pragma mark - 懒加载

/**
 帖子数组懒加载
 
 @return 帖子数组
 */
- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [[NSMutableArray alloc] init];
    }
    return _topics;
}

/**
 点击播放音乐的悬浮窗口

 @return Window
 */
- (UIWindow *)assistant
{
    if (!_assistant) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        _assistant = [[UIWindow alloc]init];
        _assistant.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _assistant.frame = CGRectMake(screenW - 50, screenH * 0.5, 40, 40);
        _assistant.layer.cornerRadius = 20;
        _assistant.layer.masksToBounds = YES;
        _assistant.windowLevel = UIWindowLevelAlert;
        UIImageView* mainImageView= [[UIImageView alloc]init];
        mainImageView.userInteractionEnabled = YES;
        [mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aciontionTouch)]];
        mainImageView.frame = _assistant.bounds;
        mainImageView.animationImages = @[[UIImage imageNamed:@"showVoice-voice1"],[UIImage imageNamed:@"showVoice-voice2"],[UIImage imageNamed:@"showVoice-voice3"],[UIImage imageNamed:@"showVoice-voice4"],[UIImage imageNamed:@"showVoice-voice5"],[UIImage imageNamed:@"showVoice-voice6"],[UIImage imageNamed:@"showVoice-voice7"],[UIImage imageNamed:@"showVoice-voice8"]];
        [mainImageView setAnimationDuration:1.5f];
        [mainImageView setAnimationRepeatCount:0];
        [mainImageView startAnimating];
        [_assistant addSubview:mainImageView];
        [self rotating:mainImageView];
    }
    return _assistant;
}

#pragma mark - controller生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTableView];
    //初始化刷新控件
    [self setRefresh];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    self.navigationController.navigationBarHidden = NO;
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}
#pragma mark - 控件初始化
/**
 控件初始化
 */
- (void)setTableView{
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, bottom + 64, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLWordCell class]) bundle:nil] forCellReuseIdentifier:MLWordCellId];
}
/**
 刷新控件初始化
 */
- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark - 数据处理
/**
 加载新数据
 */
- (void)loadNewData{
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    self.parameters = parameters;
    //获取帖子数据
    [JYHttpTool getPath:ml_word_url parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.parameters!=parameters) {
            return ;
        }
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *array = responseObject[@"list"];
        if (array.count<=0 || [array isKindOfClass:[NSNull class]]) {
            return ;
        }
        self.topics = [MLWord mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.page = 0;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.parameters!=parameters) {
            return ;
        }
        [self.tableView.mj_header endRefreshing];
        DDLog(@"error=%zd",error.code);
    }];
}

/**
 加载更多数据
 */
- (void)loadMoreData{
    [self.tableView.mj_header endRefreshing];
    self.page ++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"page"] = @(self.page);
    parameters[@"maxtime"] = self.maxtime;
    self.parameters = parameters;
    //获取帖子数据
    [JYHttpTool getPath:ml_word_url parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.parameters!=parameters) {
            return ;
        }
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *array = responseObject[@"list"];
        if (array.count<=0 || [array isKindOfClass:[NSNull class]]) {
            return ;
        }
        NSArray *moreDatas = [MLWord mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreDatas];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.parameters!=parameters) {
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        self.page --;
        DDLog(@"error=%zd",error.code);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topics.count;
}

- (MLWordCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLWordCell *cell = [tableView dequeueReusableCellWithIdentifier:MLWordCellId];
    cell.delegate = self;
    MLWord *word = self.topics[indexPath.row];
    cell.voiceView.playVoiceBtn.selected = word.normalPlay;
    cell.word = word;
    return cell;
}

#pragma mark - Table view dalegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLWord *word = self.topics[indexPath.row];
    return word.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=self.tableView||_wmPlayer==nil) {
        return;
    }
    if (_wmPlayer.subviews) {
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.ml_indexPath];
        CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        if (rectInSuperview.origin.y<-self.vedioView.frame.size.height||rectInSuperview.origin.y>MLScreenH-MLNavigationH-MLToolBarH) {//往上拖动
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_wmPlayer]&&_smallScreen) {
                _smallScreen = YES;
            }else{
                //放widow上,小屏显示
                [self toSmallScreen];
            }
            
        }else{
            if ([self.vedioView.subviews containsObject:_wmPlayer]) {
                
            }else{
                [self toVedioView];
            }
        }
    }
    
}
#pragma mark - 视频处理

/**
 添加到原来的View上
 */
-(void)toVedioView{
    
    MLWordCell *cell = (MLWordCell *)[self.tableView cellForRowAtIndexPath:self.ml_indexPath];
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame = cell.vedioView.bounds;
        _wmPlayer.playerLayer.frame =  _wmPlayer.bounds;
        [cell.vedioView addSubview:_wmPlayer];
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer.topView).with.offset(45);
            make.right.equalTo(_wmPlayer.topView).with.offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView).with.offset(0);
        }];
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_wmPlayer).with.offset(5);
        }];
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.equalTo(_wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _smallScreen = NO;
        _wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
}

/**
 小窗口显示
 */
-(void)toSmallScreen{
    //放widow上
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame = CGRectMake(MLScreenW/2,MLScreenH-MLToolBarH-(MLScreenW/2)*0.75, MLScreenW/2, (MLScreenW/2)*0.75);
        _wmPlayer.playerLayer.frame =  _wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer.topView).with.offset(45);
            make.right.equalTo(_wmPlayer.topView).with.offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView).with.offset(0);
        }];
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_wmPlayer).with.offset(5);
            
        }];
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.equalTo(_wmPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _wmPlayer.fullScreenBtn.selected = NO;
        self.smallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_wmPlayer];
    }];
    
}

/**
 全屏显示

 @param interfaceOrientation 支持方向
 */
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [_wmPlayer removeFromSuperview];
    _wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        _wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        _wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    _wmPlayer.frame = CGRectMake(0, 0, MLScreenW, MLScreenH);
    _wmPlayer.playerLayer.frame =  CGRectMake(0,0, MLScreenH,MLScreenW);
    
    [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(MLScreenW-40);
        make.width.mas_equalTo(MLScreenH);
    }];
    
    [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(_wmPlayer).with.offset(0);
        make.width.mas_equalTo(MLScreenH);
    }];
    
    [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_wmPlayer).with.offset((-MLScreenH/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_wmPlayer).with.offset(5);
        
    }];
    
    [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer.topView).with.offset(45);
        make.right.equalTo(_wmPlayer.topView).with.offset(-45);
        make.center.equalTo(_wmPlayer.topView);
        make.top.equalTo(_wmPlayer.topView).with.offset(0);
    }];
    
    [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MLScreenH);
        make.center.mas_equalTo(CGPointMake(MLScreenW/2-36, -(MLScreenW/2)));
        make.height.equalTo(@30);
    }];
    
    [_wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(MLScreenW/2-37, -(MLScreenW/2-37)));
    }];
    [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MLScreenH);
        make.center.mas_equalTo(CGPointMake(MLScreenW/2-36, -(MLScreenW/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
    
    _wmPlayer.fullScreenBtn.selected = YES;
    [_wmPlayer bringSubviewToFront:_wmPlayer.bottomView];
    
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (_wmPlayer==nil||_wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (_wmPlayer.isFullscreen) {
                if (_smallScreen) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }else{
                    [self toVedioView];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            _wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            _wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}

/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    
    //堵塞主线程
    [_wmPlayer pause];
    
    [_wmPlayer removeFromSuperview];
    [_wmPlayer.playerLayer removeFromSuperlayer];
    [_wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    _wmPlayer.player = nil;
    _wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [_wmPlayer.autoDismissTimer invalidate];
    _wmPlayer.autoDismissTimer = nil;
    _wmPlayer.playOrPauseBtn = nil;
    _wmPlayer.playerLayer = nil;
    _wmPlayer = nil;
}

//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        _wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        if (_smallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toVedioView];
        }
    }
    
}

///播放器事件
//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    [self releaseWMPlayer];
    
}
//单击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
}
//双击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    
}

///播放状态
//播放失败的代理方法
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    
}
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    [wmplayer player];
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    [wmplayer removeFromSuperview];
}

#pragma mark - <MLWordCellDelegate>

/**
 点击视频播放

 @param wordCell  wordCell
 @param vedioView vedioView
 */
- (void)MLWordCell:(MLWordCell *)wordCell playVedio:(MLVedioView *)vedioView{

    NSIndexPath* indexPath = [self.tableView indexPathForCell:wordCell];
    self.ml_indexPath = indexPath;
    MLWord *word = self.topics[indexPath.row];
    if (self.wmPlayer) {
        [self releaseWMPlayer];
    }
    _wmPlayer = [[WMPlayer alloc]initWithFrame:vedioView.bounds];
    _wmPlayer.delegate = self;
    _wmPlayer.closeBtnStyle = CloseBtnStyleClose;
    [vedioView addSubview:_wmPlayer];
    self.vedioView = vedioView;
    _wmPlayer.URLString = word.videouri;
    [_wmPlayer play];
    word.vedioPlay = YES;
    [self.tableView reloadData];

}

/**
 点击音频播放

 @param wordCell  wordCell
 @param voiceView voiceView
 */
- (void)MLWordCell:(MLWordCell *)wordCell playVoice:(MLVoiceView *)voiceView{
    self.ml_slider = voiceView.slider;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:wordCell];
    MLWord *word = self.topics[indexPath.row];
    if (!voiceView.playVoiceBtn.selected && !word.voicePlay) {
        [_streamer stop];
        self.track = [Track remoteTracks:word.voiceuri];
        [self _resetStreamer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    if (self.word) {
        self.word.voicePlay = NO;
        self.word.normalPlay = word.normalPlay;
    }
    [self addAssistant:word.normalPlay ];
    word.normalPlay = !word.normalPlay;
    self.word = word;
    word.voicePlay = YES;
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }else{
        [_streamer pause];
    }
    [self.tableView reloadData];
}

/**
 滑动 slider

 @param wordCell     wordCell
 @param sliderChange sliderChange
 */
- (void)MLWordCell:(MLWordCell *)wordCell sliderValueChange:(UISlider *)sliderChange{
    [_streamer setCurrentTime:[_streamer duration] * [sliderChange value]];
}

/**
 点击slider

 @param wordCell    wordCell
 @param sliderTouch sliderTouch
 @param pan         pan
 */
- (void)MLWordCell:(MLWordCell *)wordCell sliderTouch:(UISlider *)sliderTouch pan:(UITapGestureRecognizer *)pan{
    CGPoint touchLocation = [pan locationInView:sliderTouch];
    CGFloat value = (sliderTouch.maximumValue - sliderTouch.minimumValue) * (touchLocation.x/sliderTouch.frame.size.width);
    [sliderTouch setValue:value animated:YES];
    [_streamer setCurrentTime:[_streamer duration] * [sliderTouch value]];
}
#pragma mark - 音频处理
- (void)_resetStreamer
{
    [self _cancelStreamer];
    if (self.track) {
        _streamer = [DOUAudioStreamer streamerWithAudioFile:_track];
    }
    [_streamer play];
    [DOUAudioStreamer setHintWithAudioFile:_track];
    
}
- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        _streamer = nil;
    }
}
- (void)_timerAction:(NSTimer *)timer{
    if ([_streamer duration] == 0.0) {
        [self.ml_slider setValue:0.0f animated:NO];
    }else {
        [self.ml_slider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}

#pragma mark - 事件action
/**
 刷新控件实现方法
 */
- (void)refresh{
    //获取数据
    [self loadNewData];
}

/**
 加载更多
 */
- (void)loadMore{
    [self loadMoreData];
}
#pragma mark - other
/**
 添加助手按钮
 */
- (void)addAssistant:(BOOL)selected{
    [self assistant].hidden = selected;
}

/**
 按钮旋转
 */
- (void)rotating:(UIImageView *)imageView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 2.设置基本动画属性
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = NSIntegerMax;
    animation.duration = 10;
    // 3.添加动画到图层上
    [imageView.layer addAnimation:animation forKey:nil];
}

/**
 删除window悬浮按钮
 */
- (void)aciontionTouch{
    _assistant = nil;
}

@end
