#import <UIKit/UIKit.h>
#import "Poll.h"
#import "Candidate.h"
#import "ConnectionToServer.h"

@interface TableViewControllerResults : UIViewController

@property (strong,nonatomic) Poll *poll;
@property (strong,nonatomic) Candidate *candidate;
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *classificaFinale;
@property int flussoFrom;

@end