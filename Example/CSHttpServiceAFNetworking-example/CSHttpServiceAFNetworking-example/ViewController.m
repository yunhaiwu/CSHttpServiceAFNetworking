//
//  ViewController.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <CocoaService/CocoaService.h>
#import <CSHttpServiceAPI/CSHttpServiceAPI.h>

@interface ViewController ()

@property (nonatomic, weak) UILabel *responseLabel;

@property (nonatomic, strong) id<CSHttpTask> httpTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AFHttpService-Demo";
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView.mas_width);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:button];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"Query" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonExec:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(34);
    }];
    
    UILabel *responseLabel = [[UILabel alloc] init];
    [responseLabel setNumberOfLines:0];
    [contentView addSubview:responseLabel];
    _responseLabel = responseLabel;
    [responseLabel setTextColor:[UIColor blackColor]];
    [responseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.equalTo(button.mas_bottom).offset(30);
        make.height.mas_greaterThanOrEqualTo(100);
        make.bottom.mas_equalTo(- 80.0f);
    }];
    
}

- (void)buttonExec:(id)sender {
//    id<CSHttpService> httpService = CSFetchService(@protocol(CSHttpService));
//    [httpService requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] method:CSHTTPMethodGET params:nil headers:nil responseBlock:^(NSData *responseData, NSError *error) {
//        if (error) {
//            [self.responseLabel setText:error.userInfo[NSLocalizedDescriptionKey]];
//        } else {
//            NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//            [self.responseLabel setText:responseStr];
//        }
//    }];
    
    CSHttpServiceSugar.GET([NSURL URLWithString:@"https://www.baidu.com"]).submit(^(NSData *resData, NSError *error) {
        if (error) {
            [self.responseLabel setText:error.userInfo[NSLocalizedDescriptionKey]];
        } else {
            NSString *responseStr = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
            [self.responseLabel setText:responseStr];
        }
    });
}

@end
