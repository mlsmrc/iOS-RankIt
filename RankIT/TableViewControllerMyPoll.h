#import <UIKit/UIKit.h>

@interface TableViewControllerMyPoll : UIViewController <UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
