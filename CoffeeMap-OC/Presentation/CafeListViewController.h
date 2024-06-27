//
//  CafeListViewController.h
//  CoffeeMap-OC
//
//  Created by wyn on 2024/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CafeListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;

@end

NS_ASSUME_NONNULL_END
