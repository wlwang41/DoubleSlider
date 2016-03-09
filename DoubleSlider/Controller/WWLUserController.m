//
//  WWLUserController.m
//  DoubleSlider
//
//  Created by RavenLung on 3/5/16.
//  Copyright © 2016 spider. All rights reserved.
//

#import "WWLUserController.h"

@interface WWLUserController ()

@end

@implementation WWLUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Info";
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarTitle];
}

- (void)setTabBarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = Font(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"My info";
    
    self.tabBarController.navigationItem.titleView = titleLabel;
}

@end
