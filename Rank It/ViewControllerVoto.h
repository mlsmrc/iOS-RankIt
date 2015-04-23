#import <UIKit/UIKit.h>
#import "Candidate.h"

@interface ViewControllerVoto : UIViewController <UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *candidates;
@property (strong,nonatomic) Candidate *c;
@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end