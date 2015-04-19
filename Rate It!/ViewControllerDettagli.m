/* Classe relativa alla View dei dettagli di un Poll */

#import "ViewControllerCandidates.h"
#import "ViewControllerDettagli.h"
#import "Font.h"

@interface ViewControllerDettagli ()

@end

@implementation ViewControllerDettagli

@synthesize p,scrollView,name,description,image,deadline,lastUpdate;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,415)];

    /* Tutti i settaggi del caso */
    name.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_BOLD size:21];
    name.text = p.pollName;
    NSString *strDeadline = @"Scadenza: ";
    strDeadline = [strDeadline stringByAppendingString:(NSString *)p.deadline];
    deadline.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_LIGHT size:14];
    deadline.textColor = [UIColor redColor];
    deadline.text = strDeadline;
    NSString *strLastUpdate = @"Ultima modifica: ";
    strLastUpdate = [strLastUpdate stringByAppendingString:(NSString *)p.lastUpdate];
    lastUpdate.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_LIGHT size:14];
    lastUpdate.text = strLastUpdate;
    description.selectable = true;
    description.font = [UIFont fontWithName:FONT_DETTAGLI_POLL size:16];
    description.backgroundColor = [UIColor clearColor];
    description.textAlignment = NSTextAlignmentNatural;
    description.text = p.pollDescription;
    description.selectable = false;
    
    /* Queste righe di codice servono per rendere variabile, a seconda del contenuto, la lunghezza della scroll view. *
     * Il valore 5 serve per spaziare dal fondo della view, è stato scelto empiricamente.                             */
    CGRect frame;
    CGFloat currentY = 0;
    [description sizeToFit];
    frame = description.frame;
    currentY += frame.origin.y;
    currentY += frame.size.height;
    [scrollView setContentSize:CGSizeMake(320,currentY+5)];
    
}

/* Metodo che fa apparire momentaneamente la scroll bar per far capire all'utente che il contenuto è scrollabile */
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

/* Metodo che passa il poll alla schermata successiva   */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewControllerCandidates *candidates = segue.destinationViewController;
    candidates.poll = p;
    
}

@end