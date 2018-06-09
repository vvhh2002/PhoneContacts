//
//  SearchViewController.m
//  PhoneContacts
//
//  Created by - on 6/9/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "SearchViewController.h"
#import <WebKit/WebKit.h>

@interface SearchViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com/?pu=sz%401321_000"]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
