/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p,name,description,deadline;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /* Subview per il nome del Poll */
    name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    name.font = [UIFont fontWithName:@"Helvetica" size:20];
    name.numberOfLines = 0;
    name.textAlignment = NSTextAlignmentCenter;
    name.tag = 0;
    name.text = p.pollName;
    [name setFrame:CGRectOffset(name.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.1)];
    [self.view addSubview:name];
    [self.view sendSubviewToBack:name];
    
    /* Subview per la descrizione del Poll */
    deadline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    deadline.font = [UIFont fontWithName:@"Helvetica" size:16];
    deadline.numberOfLines = 0;
    deadline.textAlignment = NSTextAlignmentCenter;
    deadline.tag = 1;
    deadline.text = (NSString*) p.deadline;
    [deadline setFrame:CGRectOffset(deadline.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.3)];
    [self.view addSubview:deadline];
    [self.view sendSubviewToBack:deadline];
    
}

@end