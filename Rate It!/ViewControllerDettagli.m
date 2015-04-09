/* Classe relativa alla View del "segue" */

#import "ViewControllerDettagli.h"

@interface ViewControllerDettagli ()

@end

@implementation ViewControllerDettagli

@synthesize p,scrollView,name,description,image,deadline,lastUpdate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,400)];

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
    description.text = p.pollDescription;
    description.selectable = false;
    
    /* Queste righe di codice servono per rendere variabile, a seconda del contenuto, la lunghezza della scroll view */
    
    float numberOfLines = (description.text.length * 10)/description.frame.size.width;
    
    if(numberOfLines>2)
        [scrollView setContentSize:CGSizeMake(320,400+(numberOfLines*22))];
    
}

@end