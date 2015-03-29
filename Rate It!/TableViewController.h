#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

FOUNDATION_EXPORT NSInteger POLL_ID;
FOUNDATION_EXPORT NSInteger POLL_NAME;
FOUNDATION_EXPORT NSInteger POLL_DESCRIPT;
FOUNDATION_EXPORT NSInteger POLL_DEADLINE;
FOUNDATION_EXPORT NSInteger POLL_VOTES;
FOUNDATION_EXPORT NSString *NO_RESULTS;
FOUNDATION_EXPORT NSString *SEARCH;
FOUNDATION_EXPORT NSString *BACK;

- (void) viewDidLoad;
- (void) DownloadPolls;
- (void) CreatePollsDetails;
- (void) HomePolls;
- (void) printMessaggeError;
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end