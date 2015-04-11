#import "ConnectionToServer.h"
#import "ViewControllerCandidates.h"
#import "Font.h"
#import "Candidate.h"

#define FONT_SIZE_CAND_NAME 18
#define FONT_SIZE_CAND_DESCRIPTION 16
#define LINE_HEIGHT 6.5
#define LABEL_DESCR 20
#define DESCR_LABEL 60
#define DESCR_SUBMIT 80
#define SUBMIT_END_FRAME 30

@interface ViewControllerCandidates ()

/*  Funzioni private, non inserite nell'header   */

- (void) setCandsInfoToGUI:(NSMutableArray *)cands;
-(CGFloat) setYSpaceDescription:(UITextView *)Description SpacedFrom:(UILabel *)Label WithY:(CGFloat)Y;
-(CGFloat) getYSpaceLabelSpacedFrom:(UITextView *)Description WithY:(CGFloat)Y;
-(void)setYSpaceLabel:(UILabel *)Label WithY:(CGFloat)Y;
-(void)setYSpaceSubmit:(UIButton *)Button WithY:(CGFloat)Y;
-(void)setTextDescription:(UITextView *)Description forCand:(Candidate *)C;
-(void)setYSpaceVoto:(UITextField *)Voto WithY:(CGFloat)Y;

@end

@implementation ViewControllerCandidates


@synthesize poll,scrollView,Submit;

@synthesize LabelForPrimo,VotoForPrimo,DescriptionForPrimo;
@synthesize LabelForSecondo,VotoForSecondo,DescriptionForSecondo;
@synthesize LabelForTerzo,VotoForTerzo,DescriptionForTerzo;
@synthesize LabelForQuarto,VotoForQuarto,DescriptionForQuarto;
@synthesize LabelForQuinto,VotoForQuinto,DescriptionForQuinto;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    /*  Settaggi per la scrollView    */
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,800)];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sfondo_Candidates"]]];
    
    /*  Download delle candidates   */
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%d",[poll pollId]];
    NSMutableArray *cands = [conn getCandidatesWithPollId:ID];
    
    /*  Inserimento degli elementi in GUI   */
    [self setCandsInfoToGUI:cands];
    
    
}

- (void) setCandsInfoToGUI:(NSMutableArray *)cands
{
    Candidate *C;
    int dim = (int)[cands count];
    
    /*  Utili per riordinare gli elementi nella view     */
    CGFloat Y = LabelForPrimo.frame.origin.y; // angolo superiore prima label
    
    for (int i=0; i<dim; i++)
    {
        C = cands[i];
        
        switch (i)
        {
            case 0:
                
                LabelForPrimo.text = [NSString stringWithFormat:@"a) %@",C.candName];
                LabelForPrimo.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
                
                [self setTextDescription:DescriptionForPrimo forCand:C];
                
                /*  Altezze per LabelForPrimo e VotoForPrimo già fissate poichè primi elementi della view   */
                
                /*  Fisso l'altezza per la descrizione  */
                Y = [self setYSpaceDescription:DescriptionForPrimo SpacedFrom:LabelForPrimo WithY:Y];

                break;
            case 1:
                
                LabelForSecondo.text = [NSString stringWithFormat:@"b) %@",C.candName];
                LabelForSecondo.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
                
                /*  Fisso l'altezza per la descrizione  */
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
                LabelForTerzo.text = [NSString stringWithFormat:@"c) %@",C.candName];
                LabelForTerzo.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
                
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
                LabelForQuarto.text = [NSString stringWithFormat:@"d) %@",C.candName];
                LabelForQuarto.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
                
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
                LabelForQuinto.text = [NSString stringWithFormat:@"e) %@",C.candName];
                LabelForQuinto.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_NAME];
                
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
    
    /*  Nascondo gli outlet riferenti alle risposte che non ci sono */
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
    
    /*  Aggiunta del pulsante di invio votazione    */
    [self setYSpaceSubmit:(UIButton *)Submit WithY:(CGFloat)Y];
}

/* Aggiorna l'altezza della TextView relativa alla descrizione e ritorna il valore Y utile per  *
 * spaziare gli altri elementi nella View globale.                                              */
-(CGFloat) setYSpaceDescription:(UITextView *)Description SpacedFrom:(UILabel *)Label WithY:(CGFloat)Y
{
    CGRect frame;
    /* Fisso l'altezza per la descrizione */
    Y += Label.frame.size.height + LABEL_DESCR; // somma altezza prima label + spaziatura con descrizione
    frame = Description.frame;
    frame.origin.y=Y;
    Description.frame=frame;
    
    return Y;
}

/* Calcola l'altezza per la label calcolando lo spaziamento dalla descrizione del candidate precedente    */
-(CGFloat) getYSpaceLabelSpacedFrom:(UITextView *)Description WithY:(CGFloat)Y
{
    
    [Description sizeToFit];
    
    int numLines = Description.frame.size.height/Description.font.lineHeight;
    
    if(numLines>1)
        Y += numLines * LINE_HEIGHT + DESCR_LABEL;
    else
        Y += DESCR_LABEL;
    
    return Y;
}

/* Setta l'altezza per la label calcolando lo spaziamento dalla descrizione del candidate precedente    */
-(void)setYSpaceLabel:(UILabel *)Label WithY:(CGFloat)Y
{
    CGRect frame;
    frame = Label.frame;
    frame.origin.y=Y;
    Label.frame=frame;
}

/* Setta l'altezza per la TextField del voto    */
-(void)setYSpaceVoto:(UITextField *)Voto WithY:(CGFloat)Y
{
    CGRect frame;
    frame = Voto.frame;
    frame.origin.y=Y;
    Voto.frame=frame;
}

/* Setta l'altezza per la TextView della descrizione    */
-(void)setTextDescription:(UITextView *)Description forCand:(Candidate *)C
{
    Description.selectable = true;
    Description.text= C.candDescription;
    Description.font = [UIFont fontWithName:FONT_CANDIDATES_POLL size:FONT_SIZE_CAND_DESCRIPTION];
    Description.selectable = false;
}

/*Setta l'altezza del bottone submit portandolo ad ugual distanza dal basso *
 *I valori 40 e 90 sono stati scelti dopo alcune prove                      */
-(void)setYSpaceSubmit:(UIButton *)Button WithY:(CGFloat)Y
{
    CGFloat Yscreen = [[UIScreen mainScreen] bounds ].size.height-90;
    CGRect frame = Button.frame;
    
    if(Y>Yscreen)
    {
        Y += DESCR_SUBMIT;
        frame.origin.y=Y;
        Button.frame=frame;
        [scrollView setContentSize:CGSizeMake(320,Y+SUBMIT_END_FRAME+40)];
    }
    else
    {
        frame.origin.y=Yscreen-SUBMIT_END_FRAME;
        Button.frame=frame;
        [scrollView setContentSize:CGSizeMake(320,Yscreen)];
    }
}
@end
