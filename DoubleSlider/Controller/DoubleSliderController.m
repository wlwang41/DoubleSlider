//
//  DoubleSliderController.m
//  DoubleSlider
//
//  Created by RavenLung on 3/5/16.
//  Copyright © 2016 spider. All rights reserved.
//

#import "DoubleSliderController.h"
#import "WWLMainController.h"

#define HEADER_LABEL_WIDTH                      70

@interface DoubleSliderController ()

@property (nonatomic, strong) NSMutableArray *headerDataArray;

@property (nonatomic, strong) UIScrollView *headerScrollView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;

@end

@implementation DoubleSliderController

@synthesize headerDataArray;
@synthesize headerScrollView;
@synthesize bodyScrollView;

- (void)viewDidLoad
{
	[super viewDidLoad];

	headerDataArray = [NSMutableArray array];
	[self getHeaderData];

	[self initControllersInBodyScrollView];

	self.view.backgroundColor = [UIColor brownColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.view.hidden = YES;

	[self initScrollView];
	[self initLabelsInHeaderScrollView];

	[self getDataForFirstPage];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setTabBarTitle];
}

#pragma mark - init view
- (void)setTabBarTitle
{
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	titleLabel.font = Font(17);
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.text = @"Main";

	self.tabBarController.navigationItem.titleView = titleLabel;
}

- (void)initScrollView
{
	headerScrollView = [[UIScrollView alloc] init];
	headerScrollView.backgroundColor = [UIColor whiteColor];
	headerScrollView.showsVerticalScrollIndicator = NO;
	headerScrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:headerScrollView];

	bodyScrollView = [[UIScrollView alloc] init];
	bodyScrollView.backgroundColor = [UIColor grayColor];
	bodyScrollView.delegate = self;
	bodyScrollView.showsVerticalScrollIndicator = NO;
	bodyScrollView.showsHorizontalScrollIndicator = NO;
	bodyScrollView.pagingEnabled = YES;
	[self.view addSubview:bodyScrollView];
}

- (void)initLabelsInHeaderScrollView
{
	for (int i = 0; i < headerDataArray.count; i++) {
		UILabel *label = [[UILabel alloc] init];
		label.font = Font(17);
		label.textAlignment = NSTextAlignmentCenter;
		label.tag = i;
        label.userInteractionEnabled = YES;
        [self updateLabelWithScale:label scale:0];
		[label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderLabelClick:)]];
		[headerScrollView addSubview:label];
	}
}

- (void)initControllersInBodyScrollView
{
	for (int i = 0; i < headerDataArray.count; i++) {
		WWLMainController *ctrl = [[WWLMainController alloc] init];
		[self addChildViewController:ctrl];
	}
}

#pragma mark - update data
- (void)getHeaderData
{
	// fake data
	[headerDataArray addObjectsFromArray:@[@"first", @"second", @"third", @"four", @"five", @"six", @"seven", @"eight"]];
}

- (void)getDataForFirstPage
{
	// fake data
	// success
	[self updateView];
}

#pragma mark - update view
- (void)updateView;
{
	headerScrollView.contentSize = CGSizeMake(HEADER_LABEL_WIDTH * [headerDataArray count], 0);
	bodyScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [headerDataArray count], 0);

	[headerScrollView makeConstraints: ^(MASConstraintMaker *make) {
	    make.top.equalTo(self.mas_topLayoutGuide);

	    make.left.right.equalTo(self.view);
	    make.height.equalTo(@40);
	}];

	[self updateLabelInHeaderScrollView];

	[bodyScrollView makeConstraints: ^(MASConstraintMaker *make) {
	    make.top.equalTo(headerScrollView.mas_bottom);
	    make.bottom.equalTo(self.mas_bottomLayoutGuide);
	    make.left.and.right.equalTo(self.view);
	}];

	UIViewController *firstPageVC = [self.childViewControllers firstObject];
	firstPageVC.view.frame = bodyScrollView.bounds;
	[bodyScrollView addSubview:firstPageVC.view];

	UILabel *firstLabel = [headerScrollView.subviews firstObject];
	[self updateLabelWithScale:firstLabel scale:1.0f];

	self.view.hidden = NO;
}

- (void)updateLabelInHeaderScrollView
{
	for (int i = 0; i < headerDataArray.count; i++) {
		UILabel *label = [headerScrollView.subviews objectAtIndex:i];
		label.text = [headerDataArray objectAtIndex:i];

		[label makeConstraints: ^(MASConstraintMaker *make) {
		    make.size.mas_equalTo(CGSizeMake(HEADER_LABEL_WIDTH, 40));
		    // why cannot write list this?
//            make.top.equalTo(@0);
		    make.top.equalTo(self.mas_topLayoutGuide);
		    make.left.equalTo(@(HEADER_LABEL_WIDTH * i));
		}];
	}
}

- (void)updateLabelWithScale:(UILabel *)label scale:(CGFloat)scale
{
	label.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
	CGFloat minScale = 0.7;
	CGFloat trueScale = minScale + (1 - minScale) * scale;
	label.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)updateAllLabelsLocationAndScaleInHeaderScrollView:(UILabel *)headerLabel
{
    CGFloat offsetX = headerLabel.center.x - headerScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = headerScrollView.contentSize.width - headerScrollView.frame.size.width;
    offsetX = MIN(MAX(offsetX, 0), offsetMax);
    [headerScrollView setContentOffset:CGPointMake(offsetX, headerScrollView.contentOffset.y) animated:YES];
    
    for (UILabel *label in headerScrollView.subviews) {
        if (label.tag != headerLabel.tag) {
            [self updateLabelWithScale:label scale:0];
        }
    }
}

#pragma mark - action
- (void)onHeaderLabelClick:(UITapGestureRecognizer *)tap
{
	UILabel *label = (UILabel *)tap.view;

	CGFloat offsetX = label.tag * bodyScrollView.frame.size.width;
	CGFloat offsetY = bodyScrollView.contentOffset.y;
    
    [self updateAllLabelsLocationAndScaleInHeaderScrollView:label];

	[bodyScrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:NO];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrolledRate = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSArray *headerLabels = headerScrollView.subviews;
    
    if (scrolledRate < 0 || scrolledRate > headerLabels.count - 1) {
        return;
    }
    
	NSUInteger leftIndex = (int)scrolledRate;
	NSUInteger rightIndex = leftIndex + 1;
	CGFloat scaleRight = scrolledRate - leftIndex;
	CGFloat scaleLeft = 1 - scaleRight;
	UILabel *labelLeft = headerLabels[leftIndex];
	[self updateLabelWithScale:labelLeft scale:scaleLeft];

	if (rightIndex < headerLabels.count) {
		UILabel *labelRight = headerLabels[rightIndex];
		[self updateLabelWithScale:labelRight scale:scaleRight];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UILabel *headerLabel = headerScrollView.subviews[index];
    [self updateAllLabelsLocationAndScaleInHeaderScrollView:headerLabel];
    
    WWLMainController *ctrl = self.childViewControllers[index];
    
    if (ctrl.view.superview) {
        return;
    }
    
    ctrl.view.frame = scrollView.bounds;
    [bodyScrollView addSubview:ctrl.view];
}

@end
