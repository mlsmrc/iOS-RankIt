/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = p.pollName;
    
}

@end