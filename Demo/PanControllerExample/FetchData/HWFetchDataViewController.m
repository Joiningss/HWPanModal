//
//  HWFetchDataViewController.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/9/9.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HWFetchDataViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface HWFetchDataViewController () <UITableViewDelegate, UITableViewDataSource, HWPanModalPresentable>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HWFetchDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicatorView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    [self.indicatorView startAnimating];
    [self fetchData];

}

- (void)fetchData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *list = [NSMutableArray array];
        NSString *text = @"Downstairs, the doctor left three different medicines in different colored capsules2 with instructions for giving them. One was to bring down the fever, another purgative3, the third to overcome an acid condition. The germs of influenza4 can only exist in an acid condition, he explained. He seemed to know all about influenza and said there was nothing to worry about if the fever did not go above one hundred and four degree. This was a light epidemic5 of flu and there was no danger if you avoided pneumonia6.\n"
                         "Back in the room I wrote the boy's temperature down and made a note of the time to give the various capsules.";
        for (int i = 0; i < 20; ++i) {
            NSString *subText = [text substringToIndex:arc4random() % text.length];
            [list addObject:subText];
        }
        self.dataSource = list;
        [self.tableView reloadData];
        [self.indicatorView stopAnimating];
        [self hw_panModalSetNeedsLayoutUpdate];
    });
}

#pragma mark - HWPanModalPresentable

- (nullable UIScrollView *)panScrollable {
    return self.tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.estimatedRowHeight = 60;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIActivityIndicatorView new];
        _indicatorView.color = [UIColor blackColor];
    }
    return _indicatorView;
}


@end
