/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p, description, deadline;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = p.pollName;
    description.text = p.pollDescription;
    deadline.text = (NSString *) p.deadline;
    
}

@end