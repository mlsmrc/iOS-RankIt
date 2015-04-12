#import "ConnectionToServer.h"
#import "ViewControllerCandidates.h"
#import "Font.h"
#import "Candidate.h"

#define FONT_SIZE_CAND_NAME 19
#define FONT_SIZE_CAND_DESCRIPTION 16
#define LINE_HEIGHT 30
#define LABEL_DESCR 5
#define DESCR_LABEL 45
#define DESCR_SUBMIT 15
#define SUBMIT_END_FRAME 35

@interface ViewControllerCandidates ()

/* Funzioni private, non inserite nell'header */
- (void) setCandsInfoToGUI:(NSMutableArray *)cands;
- (CGFloat) setYSpaceDescription:(UITextView *)Description SpacedFrom:(UILabel *)Label WithY:(CGFloat)Y;
- (CGFloat) getYSpaceLabelSpacedFrom:(UITextView *)Description WithY:(CGFloat)Y;
- (void) setYSpaceLabel:(UILabel *)Label WithY:(CGFloat)Y;
- (void) setYSpaceSubmit:(UIButton *)Button WithY:(CGFloat)Y;
- (void) setTextDescription:(UITextView *)Description forCand:(Candidate *)C;
- (void) setYSpaceVoto:(UITextField *)Voto WithY:(CGFloat)Y;
- (void) setLabel:(UILabel *)Label OfCandidate:(Candidate *)C;

@end

@implementation ViewControllerCandidates

@synthesize poll,scrollView,Submit;
@synthesize LabelForPrimo,VotoForPrimo,DescriptionForPrimo;
@synthesize LabelForSecondo,VotoForSecondo,DescriptionForSecondo;
@synthesize LabelForTerzo,VotoForTerzo,DescriptionForTerzo;
@synthesize LabelForQuarto,VotoForQuarto,DescriptionForQuarto;
@synthesize LabelForQuinto,VotoForQuinto,DescriptionForQuinto;

- (void) viewDidLoad
{
    
    [super viewDidLoad];
    
    /* Settaggi per la scrollView */
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,800)];
    //[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sfondo_Candidates"]]];
    
    /* Download dei candidates */
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%d",[poll pollId]];
    NSMutableArray *cands = [conn getCandidatesWithPollId:ID];
    
    /* Inserimento degli elementi in GUI */
    [self setCandsInfoToGUI:cands];
    
}

- (void) setCandsInfoToGUI:(NSMutableArray *)cands
{
    
    Candidate *C;
    int dim = (int)[cands count];
    
    /* Angolo superiore prima label */
    CGFloat Y = LabelForPrimo.frame.origin.y;
    
    for (int i=0; i<dim; i++)
    {
        
        C = cands[i];
        
        switch (i)
        {
                
            case 0:
                
                /* Aggiungi la label del candidate */
                [self setLabel:LabelForPrimo OfCandidate:C];
                
                /* Fisso l'altezza per la descrizione */
                [self setTextDescription:DescriptionForPrimo forCand:C];
                
                /* Altezze per LabelForPrimo e VotoForPrimo già fissate poichè primi elementi della view */
                
                /* Fisso l'altezza per la descrizione */
                Y = [self setYSpaceDescription:DescriptionForPrimo SpacedFrom:LabelForPrimo WithY:Y];

                break;
                
            case 1:
                
                /* Aggiungi la label del candidate */
                [self setLabel:LabelForSecondo OfCandidate:C];
                
                /* Fisso l'altezza per la descrizione */
                [self setTextDescription:DescriptionForSecondo forCand:C];
                
                /* Prendo l'altezza per la label */
                Y = [self getYSpaceLabelSpacedFrom:DescriptionForPrimo WithY:Y];
                
                /* Fisso l'altezza per la label */
                [self setYSpaceLabel:LabelForSecondo WithY:Y];
                
                /* Fisso l'altezza per il voto */
                [self setYSpaceVoto:VotoForSecondo WithY:Y];
                
                /* Fisso l'altezza per la descrizione */
                Y = [self setYSpaceDescription:DescriptionForSecondo SpacedFrom:LabelForSecondo WithY:Y];
                
                break;
                
            case 2:
                
                /* Aggiungi la label del candidate */
                [self setLabel:LabelForTerzo OfCandidate:C];
                
                /* Setto il testo della descrizione */
                [self setTextDescription:DescriptionForTerzo forCand:C];
                
                /* Prendo l'altezza per la label */
                Y = [self getYSpaceLabelSpacedFrom:DescriptionForSecondo WithY:Y];
                
                /* Fisso l'altezza per la label */
                [self setYSpaceLabel:LabelForTerzo WithY:Y];
                
                /* Fisso l'altezza per il voto */
                [self setYSpaceVoto:VotoForTerzo WithY:Y];
                
                /* Fisso l'altezza per la descrizione */
                Y = [self setYSpaceDescription:DescriptionForTerzo SpacedFrom:LabelForTerzo WithY:Y];
                
                break;
                
            case 3:
                
                /* Aggiungi la label del candidate */
                [self setLabel:LabelForQuarto OfCandidate:C];
                
                /* Setto il testo della descrizione */
                [self setTextDescription:DescriptionForQuarto forCand:C];
                
                /* Prendo l'altezza per la label */
                Y = [self getYSpaceLabelSpacedFrom:DescriptionForTerzo WithY:Y];
                
                /* Fisso l'altezza per la label */
                [self setYSpaceLabel:LabelForQuarto WithY:Y];
                
                /* Fisso l'altezza per il voto */
                [self setYSpaceVoto:VotoForQuarto WithY:Y];
                
                /* Fisso l'altezza per la descrizione */
                Y = [self setYSpaceDescription:DescriptionForQuarto SpacedFrom:LabelForQuarto WithY:Y];
                
                break;
                
            case 4:
                
                /* Aggiungi la label del candidate */
                [self setLabel:LabelForQuinto OfCandidate:C];
                
                /* Setto il testo della descrizione */
                [self setTextDescription:DescriptionForQuinto forCand:C];
                
                /* Prendo l'altezza per la label */
                Y = [self getYSpaceLabelSpacedFrom:DescriptionForQuarto WithY:Y];
                
                /* Fisso l'altezza per la label */
                [self setYSpaceLabel:LabelForQuinto WithY:Y];
                
                /* Fisso l'altezza per il voto */
                [self setYSpaceVoto:VotoForQuinto WithY:Y];
                
                /* Fisso l'altezza per la descrizione */
                Y = [self setYSpaceDescription:DescriptionForQuinto SpacedFrom:LabelForQuinto WithY:Y];
                
                break;
                
            default:
                break;
                
        }
        
    }
    
    /* Nascondo gli outlet riferenti alle risposte che non ci sono */
    for (int j=dim; j<=5; j++)
    {
        
        switch (j) {
                
            case 3:
                [LabelForQuarto setHidden:YES];
                [DescriptionForQuarto setHidden:YES];
                [VotoForQuarto setHidden:YES];
                break;
                
            case 4:
                [LabelForQuinto setHidden:YES];
                [DescriptionForQuinto setHidden:YES];
                [VotoForQuinto setHidden:YES];
                break;
                
            default:
                break;
                
        }
        
    }
    
    /* Setta l'altezza per l'ultima TextView */
    switch (dim) {
            
        case 3:
            Y = [self getYSpaceLabelSpacedFrom:DescriptionForTerzo WithY:Y];
            break;
            
        case 4:
            Y = [self getYSpaceLabelSpacedFrom:DescriptionForQuarto WithY:Y];
            break;
            
        case 5:
            Y = [self getYSpaceLabelSpacedFrom:DescriptionForQuinto WithY:Y];
            break;
            
        default:
            break;
            
    }
    
    /* Aggiunta del pulsante di invio votazione */
    [[Submit layer] setCornerRadius:5.0f];
    [self setYSpaceSubmit:(UIButton *)Submit WithY:(CGFloat)Y];
    
}

/* Aggiorna l'altezza della TextView relativa alla descrizione e ritorna il valore Y utile per *
 * spaziare gli altri elementi nella View globale.                                             */
- (CGFloat) setYSpaceDescription:(UITextView *)Description SpacedFrom:(UILabel *)Label WithY:(CGFloat)Y
{
    
    CGRect frame;
    
    /* Fisso l'altezza per la descrizione */
    Y += Label.frame.size.height + LABEL_DESCR;
    frame = Description.frame;
    frame.origin.y=Y;
    Description.frame=frame;
    
    return Y;
    
}

/* Calcola l'altezza per la label calcolando lo spaziamento dalla descrizione del candidate precedente */
- (CGFloat) getYSpaceLabelSpacedFrom:(UITextView *)Description WithY:(CGFloat)Y
{
    
    [Description sizeToFit];
    Y += Description.frame.size.height + DESCR_LABEL;
    return Y;
    
}

/* Setta l'altezza per la label calcolando lo spaziamento dalla descrizione del candidate precedente */
- (void) setYSpaceLabel:(UILabel *)Label WithY:(CGFloat)Y
{
    
    CGRect frame;
    frame = Label.frame;
    frame.origin.y=Y;
    Label.frame=frame;
    
}

/* Setta l'altezza per la TextField del voto */
- (void) setYSpaceVoto:(UITextField *)Voto WithY:(CGFloat)Y
{
    
    CGRect frame;
    frame = Voto.frame;
    frame.origin.y=Y-7;
    Voto.frame=frame;
    
}

/* Setta il font del contenuto della TextView */
- (void) setTextDescription:(UITextView *)Description forCand:(Candidate *)C
{
    
    Description.selectable = true;
    Description.backgroundColor = [UIColor clearColor];
    Description.text= C.candDescription;
    Description.font = [UIFont fontWithName:FONT_CANDIDATES_POLL_DESCRIPTION size:FONT_SIZE_CAND_DESCRIPTION];
    DescriptionForPrimo.textAlignment = NSTextAlignmentNatural;
    Description.selectable = false;
    
}

/* Setta l'altezza del bottone submit portandolo ad ugual distanza dal basso. *
 * Il valore 40 è stato scelto dopo alcune prove.                             */
- (void) setYSpaceSubmit:(UIButton *)Button WithY:(CGFloat)Y
{
    
    CGFloat YScreen = [self get_visible_size].height;
    CGRect frame = Button.frame;
    
    if(Y>YScreen)
    {
        
        Y += DESCR_SUBMIT;
        frame.origin.y=Y;
        Button.frame=frame;
        [scrollView setContentSize:CGSizeMake(320,Y+SUBMIT_END_FRAME+40)];
        
    }
    
    else
    {
        
        frame.origin.y=YScreen-SUBMIT_END_FRAME-10;
        Button.frame=frame;
        [scrollView setContentSize:CGSizeMake(320,YScreen)];
        
    }
    
}

/* Setta il font del contenuto della Label */
- (void) setLabel:(UILabel *)Label OfCandidate:(Candidate *)C
{
    
    Label.text = [NSString stringWithFormat:@"%@) %@",C.candChar,C.candName];
    Label.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
    
}

/* Altezza dello schermo (esclude tutto ciò che non rigurda il contenuto vero e proprio) */
- (CGSize) get_visible_size {
    
    CGSize result;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        
        result.width = size.height;
        result.height = size.width;
        
    }
    
    else {
        
        result.width = size.width;
        result.height = size.height;
        
    }
    
    size = [[UIApplication sharedApplication] statusBarFrame].size;
    result.height -= MIN(size.width, size.height);
    
    if (self.navigationController != nil) {
        
        size = self.navigationController.navigationBar.frame.size;
        result.height -= MIN(size.width, size.height);
        
    }
    
    if (self.tabBarController != nil) {
        
        size = self.tabBarController.tabBar.frame.size;
        result.height -= MIN(size.width, size.height);
        
    }
    
    return result;
}

/* Metodo che fa apparire momentaneamente la scroll bar per far capire all'utente che il contenuto è scrollabile */
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

@end