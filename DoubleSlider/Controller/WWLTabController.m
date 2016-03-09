//
//  WWLTabController.m
//  DoubleSlider
//
//  Created by RavenLung on 3/5/16.
//  Copyright © 2016 spider. All rights reserved.
//

#import "WWLTabController.h"

#import "DoubleSliderController.h"
#import "WWLUserController.h"

#define DOUBLESLIDERCONTROLLER_TAG                  1
#define WWLUSERCONTROLLER_TAG                       2

@interface WWLTabController ()

@end

@implementation WWLTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    DoubleSliderController *doubleSliderCtrl = [[DoubleSliderController alloc] init];
    WWLUserController *userCtrl = [[WWLUserController alloc] init];
    
    self.viewControllers = @[doubleSliderCtrl, userCtrl];
    
    doubleSliderCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feeds" image:nil tag:DOUBLESLIDERCONTROLLER_TAG];
    userCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"User" image:nil tag:WWLUSERCONTROLLER_TAG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
