#import <UIKit/UIKit.h>

@interface TableViewControllerHome : UIViewController <UISearchDisplayDelegate>

FOUNDATION_EXPORT NSString *NO_RESULTS;
FOUNDATION_EXPORT NSString *SEARCH;
FOUNDATION_EXPORT NSString *BACK;

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end