/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p,name,deadline,lastUpdate,description,vota;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    name.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:23];
    name.text = p.pollName;
    NSString *strDeadline = @"Scadenza: ";
    strDeadline = [strDeadline stringByAppendingString:(NSString *)p.deadline];
    deadline.font = [UIFont fontWithName:@"ChalkboardSE-Light" size:14];
    deadline.textColor = [UIColor redColor];
    deadline.text = strDeadline;
    NSString *strLastUpdate = @"Ultima modifica: ";
    strLastUpdate = [strLastUpdate stringByAppendingString:(NSString *)p.lastUpdate];
    lastUpdate.font = [UIFont fontWithName:@"ChalkboardSE-Light" size:14];;
    lastUpdate.text = strLastUpdate;
    description.selectable = true;
    description.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
    description.textAlignment = NSTextAlignmentNatural;
    description.selectable = false;
    description.text = p.pollDescription;
    [[vota layer] setCornerRadius:5.0f];
    //[[vota layer] setBorderWidth:1.f];
    
}

@end