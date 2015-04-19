#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UISearchDisplayDelegate>

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
- (void) viewDidAppear:(BOOL)animated;
- (void) viewWillAppear:(BOOL)animated;
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller;
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end