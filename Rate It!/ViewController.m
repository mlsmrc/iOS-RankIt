/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p,name,description,image,deadline,lastUpdate,vota;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    name.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:23];
    name.text = p.pollName;
    NSString *strDeadline = @"Scadenza: ";
    strDeadline = [strDeadline stringByAppendingString:(NSString *)p.deadline];
    deadline.font = [UIFont fontWithName:@"ChalkboardSE-Light" size:15];
    deadline.textColor = [UIColor redColor];
    deadline.text = strDeadline;
    NSString *strLastUpdate = @"Ultima modifica: ";
    strLastUpdate = [strLastUpdate stringByAppendingString:(NSString *)p.lastUpdate];
    lastUpdate.font = [UIFont fontWithName:@"ChalkboardSE-Light" size:15];;
    lastUpdate.text = strLastUpdate;
    description.selectable = true;
    description.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];
    description.textAlignment = NSTextAlignmentNatural;
    description.text = p.pollDescription;
    description.selectable = false;
    [[vota layer] setCornerRadius:5.0f];
    
}

@end