//
//  QuestionViewController.m
//  MyOne
//
//  Created by HelloWorld on 7/27/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import "QuestionViewController.h"
#import "RightPullToRefreshView.h"
#import "QuestionEntity.h"
#import <MJExtension/MJExtension.h>
#import "QuestionView.h"
#import "HTTPTool.h"
#import <UIImageView+WebCache.h>

@interface QuestionViewController () <RightPullToRefreshViewDelegate, RightPullToRefreshViewDataSource>

@property (nonatomic, strong) RightPullToRefreshView *rightPullToRefreshView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QuestionViewController {
	// 当前一共有多少 item，默认为3个
	NSInteger numberOfItems;
	// 保存当前查看过的数据
	NSMutableDictionary *readItems;
	// 最后更新的日期
	NSString *lastUpdateDate;
	// 当前是否正在右拉刷新标记
	BOOL isRefreshing;
}

#pragma mark - View Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		UIImage *deselectedImage = [[UIImage imageNamed:@"tabbar_item_thing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"tabbar_item_thing_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		// 底部导航item
		UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"一图" image:nil tag:0];
		tabBarItem.image = deselectedImage;
		tabBarItem.selectedImage = selectedImage;
		self.tabBarItem = tabBarItem;
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.frame = CGRectMake(30, 30, self.view.bounds.size.width - 30*2, self.view.bounds.size.height - 30*2 - 40);
    
    self.titleLabel.frame = CGRectMake(10, self.imageView.frame.origin.y + self.imageView.frame.size.height + 20, SCREEN_WIDTH - 20, 40);
}

- (UIImageView *)imageView
{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.layer.borderWidth = 20;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.clipsToBounds = YES;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
        _titleLabel.textColor = DawnTextColor;
        _titleLabel.nightTextColor = NightTextColor;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setUpNavigationBarShowRightBarButtonItem:YES];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
	
	numberOfItems = 2;
	readItems = [[NSMutableDictionary alloc] init];
	lastUpdateDate = [BaseFunction stringDateBeforeTodaySeveralDays:0];
	isRefreshing = NO;
	
	self.rightPullToRefreshView = [[RightPullToRefreshView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame))];
	self.rightPullToRefreshView.delegate = self;
	self.rightPullToRefreshView.dataSource = self;
	[self.view addSubview:self.rightPullToRefreshView];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightModeSwitch:) name:@"DKNightVersionNightFallingNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightModeSwitch:) name:@"DKNightVersionDawnComingNotification" object:nil];
	
	[self requestQuestionContentAtIndex:0];
}

#pragma mark - Lifecycle

- (void)dealloc {
	self.rightPullToRefreshView.delegate = nil;
	self.rightPullToRefreshView.dataSource = nil;
	self.rightPullToRefreshView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification

- (void)nightModeSwitch:(NSNotification *)notification {
	[self.rightPullToRefreshView reloadData];
}

#pragma mark - RightPullToRefreshViewDataSource

- (NSInteger)numberOfItemsInRightPullToRefreshView:(RightPullToRefreshView *)rightPullToRefreshView {
	return numberOfItems;
}

- (UIView *)rightPullToRefreshView:(RightPullToRefreshView *)rightPullToRefreshView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
	QuestionView *questionView = nil;
	
	//create new view if no view is available for recycling
	if (view == nil) {
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rightPullToRefreshView.frame), CGRectGetHeight(rightPullToRefreshView.frame))];
		questionView = [[QuestionView alloc] initWithFrame:view.bounds];
		
		[view addSubview:questionView];
	} else {
		questionView = (QuestionView *)view.subviews[0];
	}
	
	//remember to always set any properties of your carousel item
	//views outside of the `if (view == nil) {...}` check otherwise
	//you'll get weird issues with carousel item content appearing
	//in the wrong place in the carousel
	if (index == numberOfItems - 1 || index == readItems.allKeys.count) {// 当前这个 item 是没有展示过的
		[questionView refreshSubviewsForNewItem];
	} else {// 当前这个 item 是展示过了但是没有显示过数据的
		[questionView configureViewWithQuestionEntity:readItems[[@(index) stringValue]]];
	}
	
	return view;
}

#pragma mark - RightPullToRefreshViewDelegate

- (void)rightPullToRefreshViewRefreshing:(RightPullToRefreshView *)rightPullToRefreshView {
	[self refreshing];
}

- (void)rightPullToRefreshView:(RightPullToRefreshView *)rightPullToRefreshView didDisplayItemAtIndex:(NSInteger)index {
	if (index == numberOfItems - 1) {// 如果当前显示的是最后一个，则添加一个 item
		numberOfItems++;
		[self.rightPullToRefreshView insertItemAtIndex:(numberOfItems - 1) animated:YES];
	}
	
	if (index < readItems.allKeys.count && readItems[[@(index) stringValue]]) {
		QuestionView *questionView = (QuestionView *)[rightPullToRefreshView itemViewAtIndex:index].subviews[0];
		[questionView configureViewWithQuestionEntity:readItems[[@(index) stringValue]]];
	} else {
		[self requestQuestionContentAtIndex:index];
	}
}

- (void)rightPullToRefreshViewCurrentItemIndexDidChange:(RightPullToRefreshView *)rightPullToRefreshView {
	if (isGreatThanIOS9) {
		UIView *currentItemView = [rightPullToRefreshView currentItemView];
		for (id subView in rightPullToRefreshView.contentView.subviews) {
			if (![subView isKindOfClass:[UILabel class]]) {
				UIView *itemView = (UIView *)subView;
				QuestionView *questionView = (QuestionView *)itemView.subviews[0].subviews[0];
				UIWebView *webView = (UIWebView *)[questionView viewWithTag:WebViewTag];
				if (itemView == currentItemView.superview) {
					webView.scrollView.scrollsToTop = YES;
				} else {
					webView.scrollView.scrollsToTop = NO;
				}
			}
		}
	}
}

#pragma mark - Network Requests

// 右拉刷新
- (void)refreshing {
	if (readItems.allKeys.count > 0) {// 避免第一个还未加载的时候右拉刷新更新数据
		[self showHUDWithText:@""];
		isRefreshing = YES;
		[self requestQuestionContentAtIndex:0];
	}
}

- (void)updatePic:(NSString *)url title:(NSString *)title
{
    if (url.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
}

- (void)requestQuestionContentAtIndex:(NSInteger)index {
	NSString *date = [BaseFunction stringDateBeforeTodaySeveralDays:index];
	[HTTPTool requestQuestionContentByDate:date lastUpdateDate:lastUpdateDate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSArray *images = [responseObject objectForKey:@"images"];
            if (images.count > 0) {
                NSDictionary *dic = images.firstObject;
                NSString *url = [dic objectForKey:@"url"];
                NSString *title = [dic objectForKey:@"copyright"];
                NSString *imageUrl = [NSString stringWithFormat:@"http://s.cn.bing.net%@",url];
                [self updatePic:imageUrl title:title];
            }
            
//            QuestionEntity *returnQuestionEntity = [QuestionEntity objectWithKeyValues:responseObject[@"questionAdEntity"]];
//            if (IsStringEmpty(returnQuestionEntity.strQuestionId)) {
//                returnQuestionEntity.strQuestionMarketTime = date;
//            }
			
            self.rightPullToRefreshView.hidden = YES;
			if (isRefreshing) {
				[self endRefreshing];
//                if ([returnQuestionEntity.strQuestionId isEqualToString:((QuestionEntity *)readItems[@"0"]).strQuestionId]) {// 没有最新数据
//                    [self showHUDWithText:IsLatestData delay:HUD_DELAY];
//                } else {// 有新数据
//                    // 删掉所有的已读数据，不用考虑第一个已读数据和最新数据之间相差几天，简单粗暴
//                    [readItems removeAllObjects];
//                    [self hideHud];
//                }
//
//                [self endRequestQuestionContent:returnQuestionEntity atIndex:index];
			} else {
				[self hideHud];
//                [self endRequestQuestionContent:returnQuestionEntity atIndex:index];
			}
        }
	} failBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"question error = %@", error);
	}];
}

#pragma mark - Private

- (void)endRefreshing {
	isRefreshing = NO;
	[self.rightPullToRefreshView endRefreshing];
}

- (void)endRequestQuestionContent:(QuestionEntity *)questionEntity atIndex:(NSInteger)index {
	[readItems setObject:questionEntity forKey:[@(index) stringValue]];
	[self.rightPullToRefreshView reloadItemAtIndex:index animated:NO];
}

#pragma mark - Parent

- (void)share {
	[super share];
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
