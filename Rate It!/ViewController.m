/* Classe relativa alla View del "segue" */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p,name,description,deadline,lastUpdate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /* Subview per il nome del Poll */
    name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    name.font = [UIFont fontWithName:@"Helvetica" size:16];
    name.numberOfLines = 0;
    name.textAlignment = NSTextAlignmentCenter;
    name.tag = 0;
    name.text = p.pollName;
    [name setFrame:CGRectOffset(name.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.05)];
    [self.view addSubview:name];
    [self.view sendSubviewToBack:name];
    
    /* Subview per la deadline del Poll */
    deadline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    deadline.font = [UIFont fontWithName:@"Helvetica" size:12];
    deadline.textColor = [UIColor redColor];
    deadline.numberOfLines = 0;
    deadline.textAlignment = NSTextAlignmentNatural;
    deadline.tag = 1;
    NSString *strDeadline = @"Scadenza: ";
    strDeadline = [strDeadline stringByAppendingString:(NSString*)p.deadline];
    deadline.text = strDeadline;
    [deadline setFrame:CGRectOffset(deadline.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2.1, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.11)];
    [self.view addSubview:deadline];
    [self.view sendSubviewToBack:deadline];
    
    /* Subview per l'ultimo aggiornamento del Poll */
    lastUpdate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    lastUpdate.font = [UIFont fontWithName:@"Helvetica" size:12];
    lastUpdate.numberOfLines = 0;
    lastUpdate.textAlignment = NSTextAlignmentNatural;
    lastUpdate.tag = 1;
    NSString *strLastUpdate = @"Ultima modifica: ";
    strLastUpdate = [strLastUpdate stringByAppendingString:(NSString*)p.lastUpdate];
    lastUpdate.text = strLastUpdate;
    [lastUpdate setFrame:CGRectOffset(lastUpdate.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2.1, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.14)];
    [self.view addSubview:lastUpdate];
    [self.view sendSubviewToBack:lastUpdate];
    
    /* Subview per la descrizione del Poll */
    description = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    description.font = [UIFont fontWithName:@"Helvetica" size:13];
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentNatural;
    description.tag = 1;
    description.text = p.pollDescription;
    [description setFrame:CGRectOffset(description.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2.1, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.23)];
    [self.view addSubview:description];
    [self.view sendSubviewToBack:description];
    
}

@end