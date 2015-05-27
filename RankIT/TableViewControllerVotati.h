#import <UIKit/UIKit.h>

@interface TableViewControllerVotati : UIViewController <UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (readwrite,nonatomic) int FLAG_VOTATI;

@end