#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface TableViewControllerMyPoll : UIViewController <UISearchDisplayDelegate,SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end