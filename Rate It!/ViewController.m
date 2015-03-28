/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize pollname;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = pollname;
    
}

@end