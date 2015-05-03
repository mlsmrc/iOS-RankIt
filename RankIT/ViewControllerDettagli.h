#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "Poll.h"

@interface ViewControllerDettagli : UIViewController

@property (strong,nonatomic) Poll *p;
@property (strong,nonatomic) Candidate *c;
@property (strong,nonatomic) NSMutableArray* cands;
@property (nonatomic) int flussoFrom;
@property (weak,nonatomic) IBOutlet UILabel *name;
@property (weak,nonatomic) IBOutlet UITextView *description;
@property (weak,nonatomic) IBOutlet UIImageView *image;
@property (weak,nonatomic) IBOutlet UILabel *deadline;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Vota;

@end