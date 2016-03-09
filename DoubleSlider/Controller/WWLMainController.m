//
//  WWLMainController.m
//  DoubleSlider
//
//  Created by RavenLung on 3/8/16.
//  Copyright © 2016 spider. All rights reserved.
//

#import "WWLMainController.h"
#import "MJRefresh.h"

#define WWL_PAGE_SIZE               15
#define TOTAL_COUNT                 45
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface WWLMainController ()

@property (nonatomic, strong) NSMutableArray *fakeData;

@end

@implementation WWLMainController

@synthesize fakeData;

- (void)viewDidLoad
{
	[super viewDidLoad];

	fakeData = [NSMutableArray array];

	self.view.backgroundColor = [UIColor purpleColor];
	[self initHeader];
	[self initFooter];

	[self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - init view
- (void)initHeader
{
	MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

	header.automaticallyChangeAlpha = YES;
	header.lastUpdatedTimeLabel.hidden = YES;
	header.stateLabel.hidden = YES;
//	[header setTitle:@"Pull Pull Pull" forState:MJRefreshStateIdle];
//	[header setTitle:@"Release Release Release" forState:MJRefreshStatePulling];
//	[header setTitle:@"Loading Loading Loading" forState:MJRefreshStateRefreshing];
//	header.stateLabel.font = Font(16);
//	header.stateLabel.textColor = [UIColor grayColor];
	NSMutableArray *idleImages = [NSMutableArray array];

	for (NSUInteger i = 1; i <= 60; i++) {
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
		[idleImages addObject:image];
	}

	[header setImages:idleImages forState:MJRefreshStateIdle];

	NSMutableArray *refreshingImages = [NSMutableArray array];

	for (NSUInteger i = 1; i <= 3; i++) {
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
		[refreshingImages addObject:image];
	}

	[header setImages:refreshingImages forState:MJRefreshStatePulling];
	[header setImages:refreshingImages forState:MJRefreshStateRefreshing];

	self.tableView.mj_header = header;
}

- (void)initFooter
{
	MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

	footer.automaticallyHidden = YES;
	footer.refreshingTitleHidden = YES;
	footer.automaticallyRefresh = NO;

	NSMutableArray *idleImages = [NSMutableArray array];

	for (NSUInteger i = 1; i <= 60; i++) {
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
		[idleImages addObject:image];
	}

	[footer setImages:idleImages forState:MJRefreshStateIdle];

	NSMutableArray *refreshingImages = [NSMutableArray array];

	for (NSUInteger i = 1; i <= 3; i++) {
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
		[refreshingImages addObject:image];
	}

	[footer setImages:refreshingImages forState:MJRefreshStatePulling];
	[footer setImages:refreshingImages forState:MJRefreshStateRefreshing];

	self.tableView.mj_footer = footer;
}

#pragma mark - update data
- (void)loadNewData
{
	[fakeData removeAllObjects];

	for (int i = 0; i < WWL_PAGE_SIZE; i++) {
		[fakeData addObject:MJRandomData];
	}

	[self.tableView reloadData];
	[self.tableView.mj_header endRefreshing];
	[self.tableView.mj_footer resetNoMoreData];
}

- (void)loadMoreData
{
	for (int i = 0; i < WWL_PAGE_SIZE; i++) {
		[fakeData addObject:MJRandomData];
	}

	[self.tableView reloadData];

	if (fakeData.count == TOTAL_COUNT) {
		self.tableView.mj_footer.hidden = YES;
		[self.tableView.mj_footer endRefreshingWithNoMoreData];
	}
	else {
		[self.tableView.mj_footer endRefreshing];
	}
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return fakeData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"WWLMainCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}

	cell.textLabel.text = [fakeData objectAtIndex:indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
