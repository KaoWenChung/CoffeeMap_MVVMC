//
//  CafeListViewController.m
//  CoffeeMap-OC
//
//  Created by wyn on 2024/6/27.
//

#import "CafeListViewController.h"
#import "CafeTableViewCell.h"

@interface CafeListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CafeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.noResultLabel.hidden = YES;
    self.tableView.hidden = NO;

    [self.tableView registerClass:[CafeTableViewCell class] forCellReuseIdentifier:@"CafeTableViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CafeTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cellIdentifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    return cell;
}

@end
