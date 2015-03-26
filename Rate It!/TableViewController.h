#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

FOUNDATION_EXPORT NSInteger POLL_NAME;

- (void)viewDidLoad;
- (void)DownloadPolls;
- (void)NamePolls;
- (void)HomePolls;
- (void)printMessaggeError;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end