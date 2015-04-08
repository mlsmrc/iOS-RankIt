/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p,scrollView,name,description,image,deadline,lastUpdate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,600)];

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
    description.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:15];
    description.textAlignment = NSTextAlignmentNatural;
    
    /* Prova con 255 caratteri esatti (il max numero di caratteri per la descrizione del Poll) */
    //description.text = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?";
    
    description.text = p.pollDescription;
    description.selectable = false;
    
}

@end