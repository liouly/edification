//
//  AboutViewController.m
//  MyOne
//
//  Created by HelloWorld on 7/27/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AboutViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	// 设置夜间模式背景色
	self.view.nightBackgroundColor = NightBGViewColor;
	
	[self setTitleView];
	[self setUpViews];
    
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentLabel];
	
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.wufazhuce.com/about?from=ONEApp"]]];
}

- (UIImageView *)iconView
{
    if (nil == _iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 80, 80)];
        _iconView.backgroundColor = [UIColor redColor];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.iconView.frame.origin.y + self.iconView.frame.size.height + 30, SCREEN_WIDTH - 20, 22)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = DawnTextColor;
        _titleLabel.nightTextColor = NightTextColor;
        _titleLabel.text = @"熏陶";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 30, SCREEN_WIDTH - 20, 22)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.textColor = DawnTextColor;
        _contentLabel.numberOfLines = 0;
        _contentLabel.nightTextColor = NightTextColor;
        _contentLabel.text = @"        阅读的功能在于熏陶而不是搬运，眼前可能看不出什么，但只要他读得足够多，丰厚底蕴迟早会在他身上显现出来。";
    }
    return _contentLabel;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.webView.frame = self.view.bounds;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.iconView.frame = CGRectMake((SCREEN_WIDTH - self.iconView.frame.size.width)*0.5, 30, 80, 80);
    self.titleLabel.frame = CGRectMake(10, self.iconView.frame.origin.y + self.iconView.frame.size.height + 20, SCREEN_WIDTH - 20, 22);
    self.contentLabel.frame = CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 20, SCREEN_WIDTH - 20, 100);
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setTitleView {
	UILabel *titleLabel = [UILabel new];
	titleLabel.text = @"关于";
	titleLabel.textColor = TitleTextColor;
	titleLabel.nightTextColor = TitleTextColor;
	titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
}

- (void)setUpViews {
	self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	self.webView.scalesPageToFit = NO;
	self.webView.multipleTouchEnabled = NO;
	self.webView.exclusiveTouch = NO;
	self.webView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1];;
	self.webView.scrollView.backgroundColor = self.webView.backgroundColor;
	self.webView.scrollView.scrollsToTop = YES;
//    [self.view addSubview:self.webView];
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
