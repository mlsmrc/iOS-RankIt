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
    description.textAlignment = NSTextAlignmentJustified;
    description.font = [UIFont fontWithName:@"Arial" size:15];
    deadline.text = (NSString *) p.deadline;
    deadline.font = [UIFont fontWithName:@"Arial" size:15];
    
}

@end