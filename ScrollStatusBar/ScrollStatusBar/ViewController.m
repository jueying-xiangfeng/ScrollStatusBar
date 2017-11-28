//
//  ViewController.m
//  ScrollStatusBar
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 Key. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ScrollStatusBar.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIRefreshControl * _refreshControl;
}

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configRefreshControl];
    [self loadData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- configRefreshControl
- (void)configRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载"];
    [_refreshControl addTarget:self action:@selector(headerRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [self.tableView sendSubviewToBack:_refreshControl];
}

- (void)headerRefresh {
    [_refreshControl endRefreshing];
    [self.tableView.scrollStatusBar showScrollStatusBar];
}

#pragma mark- loadData
- (void)loadData {
    self.dataSource = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger index = 0; index < 10; index ++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%d", (int)index]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark- configTableView
- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    // 初始化ScrollStatusBar
    self.tableView.scrollStatusBar = [ScrollStatusBar scrollStatusBarWithTitle:@"推荐内容有10条更新" coordinate_y:64];
}

#pragma mark- UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource.count > indexPath.row ? self.dataSource[indexPath.row] : @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
