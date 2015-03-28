#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

FOUNDATION_EXPORT NSInteger POLL_NAME;
FOUNDATION_EXPORT NSString *NO_RESULTS;

- (void)viewDidLoad;
- (void)DownloadPolls;
- (void)NamePolls;
- (void)HomePolls;
- (void)printMessaggeError;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

@end