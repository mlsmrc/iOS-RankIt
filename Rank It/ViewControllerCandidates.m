#import "ViewControllerCandidates.h"
#import "Font.h"

@interface ViewControllerCandidates ()
@end

@implementation ViewControllerCandidates
@synthesize c,name,image,description,scrollView;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,415)];
    
    /* Tutti i settaggi del caso */
    name.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_BOLD size:21];
    name.text = c.candName;
    
    description.selectable = true;
    description.font = [UIFont fontWithName:FONT_DETTAGLI_POLL size:16];
    description.backgroundColor = [UIColor clearColor];
    description.textAlignment = NSTextAlignmentNatural;
    description.text = c.candDescription;
    description.selectable = false;
    [description sizeToFit];
    
    /* Queste righe di codice servono per rendere variabile, a seconda del contenuto, la lunghezza della view e dello scroll. *
     * I valori che vedete servono per spaziare tra gli oggetti e sono stati scelti empiricamente.                            */
    CGRect frame;
    CGFloat currentY = 0;
    frame = name.frame;
    currentY += 17;
    frame.origin.y = currentY;
    name.frame = frame;
    currentY += name.frame.size.height;
    frame = image.frame;
    currentY += 28;
    frame.origin.y = currentY;
    image.frame = frame;
    currentY += image.frame.size.height;
    frame = description.frame;
    frame.origin.y = currentY;
    description.frame = frame;
    currentY += description.frame.size.height;
    [scrollView setContentSize:CGSizeMake(320,currentY+10)];
    
}

/* Metodo che fa apparire momentaneamente la scroll bar per far capire all'utente che il contenuto è scrollabile */
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

@end