#import <UIKit/UIKit.h>

@interface ViewControllerCredits : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *prof;
@property (strong, nonatomic) IBOutlet UITableView *userResearch;
@property (strong, nonatomic) IBOutlet UITableView *developer;

@end
