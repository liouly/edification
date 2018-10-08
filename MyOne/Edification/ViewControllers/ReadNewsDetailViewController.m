//
//  ReadNewsDetailViewController.m
//  MyOne
//
//  Created by 林辉武 on 2018/10/6.
//  Copyright © 2018年 melody. All rights reserved.
//

#import "ReadNewsDetailViewController.h"

@interface ReadNewsDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ReadNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置夜间模式背景色
    self.view.nightBackgroundColor = NightBGViewColor;
    
    [self setTitleView];
    
    [self.view addSubview:self.webView];
    
    if (self.webUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
        [self.webView loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.frame = self.view.bounds;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 真蛋疼，这行代码在这个方法的原因是为了解决点击了其他模块之后返回个人界面点击列表项进入下一个界面导航栏的 tintColor 变成白色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:229 / 255.0];
}

- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"头条";
    titleLabel.textColor = TitleTextColor;
    titleLabel.nightTextColor = TitleTextColor;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (UIWebView *)webView
{
    if (nil == _webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = NO;
        _webView.multipleTouchEnabled = NO;
        _webView.exclusiveTouch = NO;
        _webView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1];;
        _webView.scrollView.backgroundColor = _webView.backgroundColor;
        _webView.scrollView.scrollsToTop = YES;
        _webView.delegate = self;
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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
