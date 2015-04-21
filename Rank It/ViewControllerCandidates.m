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
#define DEPTH 10

#define MANCA_VOTO 0
#define VOTO_SBAGLIATO 1
#define VOTI_OK 2

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
- (int) checkVoti: (NSMutableArray *)Voti;
- (NSMutableString*) getRankingString:(NSMutableDictionary *)ranking;
@end

@implementation ViewControllerCandidates

@synthesize poll,scrollView,Submit;
@synthesize Picker,ViewForPicker,Chiudi,CandidateEditing;
@synthesize LabelForPrimo,VotoForPrimo,DescriptionForPrimo;
@synthesize LabelForSecondo,VotoForSecondo,DescriptionForSecondo;
@synthesize LabelForTerzo,VotoForTerzo,DescriptionForTerzo;
@synthesize LabelForQuarto,VotoForQuarto,DescriptionForQuarto;
@synthesize LabelForQuinto,VotoForQuinto,DescriptionForQuinto;

long tagSelected = -1;
long candsDim = -1;

- (void) viewDidLoad
{
    
    [super viewDidLoad];
    
    /* Settaggi per la scrollView */
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,800)];
    
    /* Settaggio dei tag */
    VotoForPrimo.tag = 1;
    VotoForSecondo.tag = 2;
    VotoForTerzo.tag = 3;
    VotoForQuarto.tag = 4;
    VotoForQuinto.tag = 5;
    
    /* Settaggi delegate per TextField voto */
    VotoForPrimo.delegate = self;
    VotoForSecondo.delegate = self;
    VotoForTerzo.delegate = self;
    VotoForQuarto.delegate = self;
    VotoForQuinto.delegate = self;
    
    /* Settaggi DataPicker */
    Picker.delegate = self;
    numbersForVoto = [[NSMutableArray alloc]init];
    CGFloat YScreen = [[UIScreen mainScreen] bounds ].size.height;
    ViewForPicker.frame = CGRectMake(0,DEPTH*YScreen,ViewForPicker.frame.size.width,ViewForPicker.frame.size.height);
    
    /* Download dei candidates */
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%d",[poll pollId]];
    NSMutableArray *cands = [conn getCandidatesWithPollId:ID];
    
    /* Popolamento Picker per la classifica */
    [numbersForVoto addObject:@"-"];
    candsDim = [cands count];
    for (int i=0; i<candsDim; i++)
        [numbersForVoto addObject:[NSString stringWithFormat:@"%d°",(i+1)]];
    
    /* Inserimento degli elementi in GUI */
    [self setCandsInfoToGUI:cands];
    
}

- (void) setCandsInfoToGUI:(NSMutableArray *)cands
{
    
    Candidate *C;
    
    /* Angolo superiore prima label */
    CGFloat Y = LabelForPrimo.frame.origin.y;
    
    for (int i=0; i<candsDim; i++)
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
    for (long j=candsDim; j<=5; j++)
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
    switch (candsDim) {
            
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

/* Setta l'altezza per la TextField del voto.                  *
 * Il valore 7 serve per allineare perfettamente con la label. */
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
 * I valori 40 e 15 sono stati scelti dopo alcune prove.                      */
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
        
        frame.origin.y=YScreen-15;
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

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    /* Rimozione di "°" dalla stringa del voto - Le stringhe del voto sono 1°, 2°, 3°, ... */
    NSString *textInTextField = [textField.text stringByReplacingOccurrencesOfString:@"°" withString:@""];
    
    /* Animazione della view per il Picker */
    [Picker selectRow:[textInTextField intValue] inComponent:0 animated:true];
    ViewForPicker.backgroundColor=[UIColor whiteColor];
    Picker.backgroundColor=[UIColor whiteColor];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView setAnimationDelegate:self];
    CGFloat YScreen = [[UIScreen mainScreen] bounds ].size.height;
    ViewForPicker.frame = CGRectMake(0,YScreen-ViewForPicker.frame.size.height-50,ViewForPicker.frame.size.width,ViewForPicker.frame.size.height);
    [self.view addSubview:ViewForPicker];
    [UIView commitAnimations];

    /* Setta come tag selezionato il tag del textField */
    tagSelected = textField.tag;
    
    /* Setta come label il nome del candidato che si sta votando                    *
     * Le stringhe arrivano tutte della forma #) Titolo, per cui esigono di pulizia */
    switch (tagSelected) {
            
        case 1:
            CandidateEditing.text = [LabelForPrimo.text stringByReplacingOccurrencesOfString:@"a)" withString:@""];
            break;
            
        case 2:
            CandidateEditing.text = [LabelForSecondo.text stringByReplacingOccurrencesOfString:@"b)" withString:@""];
            break;
            
        case 3:
            CandidateEditing.text = [LabelForTerzo.text stringByReplacingOccurrencesOfString:@"c)" withString:@""];
            break;
            
        case 4:
            CandidateEditing.text = [LabelForQuarto.text stringByReplacingOccurrencesOfString:@"d)" withString:@""];
            break;
            
        case 5:
            CandidateEditing.text = [LabelForQuinto.text stringByReplacingOccurrencesOfString:@"e)" withString:@""];
            break;
            
        default:
            break;
            
    }
    
    [CandidateEditing sizeToFit];
    return NO;
    
}

/* Metodi per visualizzare correttamente le scelte del Picker */
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return numbersForVoto.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [numbersForVoto objectAtIndex:row];
}

/* Settaggio della scelta dal Picker */
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (tagSelected) {
            
        case 1:
            [VotoForPrimo setText:[numbersForVoto objectAtIndex:row]];
            break;
            
        case 2:
            [VotoForSecondo setText:[numbersForVoto objectAtIndex:row]];
            break;
            
        case 3:
            [VotoForTerzo setText:[numbersForVoto objectAtIndex:row]];
            break;
            
        case 4:
            [VotoForQuarto setText:[numbersForVoto objectAtIndex:row]];
            break;
            
        case 5:
            [VotoForQuinto setText:[numbersForVoto objectAtIndex:row]];
            break;
            
        default:
            break;
            
    }
    
}

/* Chiude il Picker */
- (IBAction) chiudiPicker:(id)sender
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGFloat YScreen = [[UIScreen mainScreen] bounds ].size.height;
    ViewForPicker.frame = CGRectMake(0,DEPTH*YScreen,ViewForPicker.frame.size.width,ViewForPicker.frame.size.height);
    [UIView commitAnimations];

}

/* Invio della classifica al server */
- (IBAction) inviaVoto:(id)sender
{
    
    /* Dizionario di voti */
    NSMutableDictionary *voti = [[NSMutableDictionary alloc]init];
    [voti setObject:[VotoForPrimo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"a" ];
    [voti setObject:[VotoForSecondo.text stringByReplacingOccurrencesOfString:@"°" withString:@"" ] forKey:@"b" ];
    [voti setObject:[VotoForTerzo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"c" ];
    
    if (candsDim >= 4)
        [voti setObject:[VotoForQuarto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"d" ];
    if (candsDim == 5)
        [voti setObject:[VotoForQuinto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"e" ];
    
    /* Sort dei voti per facilitare il controllo successivo */
    NSMutableArray *votiSorted = [[NSMutableArray alloc]init];
    NSString *value;
    
    for(id key in voti) {
        
        value = [voti objectForKey:key] ;
        [votiSorted addObject:value];
    
    }
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    votiSorted = (NSMutableArray*)[votiSorted sortedArrayUsingDescriptors:@[sd]];
    
    /* Gestione dei valori */
    int resultsCheckVoti = [self checkVoti: votiSorted];
    
    if(resultsCheckVoti==VOTI_OK)
    {
        
        ConnectionToServer *conn = [[ConnectionToServer alloc] init];
        NSMutableString *stringVotiToSubmit = [self getRankingString:voti];
        NSLog(@"%@",stringVotiToSubmit);
        [conn submitRankingWithPollId:[NSString stringWithFormat:@"%d",poll.pollId]  andUserId:poll.userID andRanking:stringVotiToSubmit];
        
        /* Popup per voto sottomesso */
        UIAlertView *alert = [UIAlertView alloc];
        alert.tag = VOTI_OK;
        alert = [alert initWithTitle:@"Messaggio" message:@"Votazione effettuata con successo!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    
    else if(resultsCheckVoti==VOTO_SBAGLIATO)
    {
        
        /* Popup per voto sbagliato */
        UIAlertView *alert = [UIAlertView alloc];
        alert.tag = VOTO_SBAGLIATO;
        alert = [alert initWithTitle:@"Attenzione" message:@"Devono esistere voti consecutivi!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
        [alert show];
        
    }
    
    else if(resultsCheckVoti==MANCA_VOTO)
    {
        
        /* Popup per voto sbagliato */
        UIAlertView *alert = [UIAlertView alloc];
        alert.tag = MANCA_VOTO;
        alert = [alert initWithTitle:@"Attenzione" message:@"Manca uno o più di un voto!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
        [alert show];
        
    }
    
}

/* Controllo sui voti */
- (int) checkVoti: (NSMutableArray *)Voti
{
    
    /* I voti sono ordinati, basta controllare i primi valori se sono "-" o "" poichè vengono prima nell'ordine QUASI lessicografico */
    if([Voti[0] isEqual:@"-"] || [Voti[0] isEqual:@""])
        return MANCA_VOTO;
    
    long voto = [Voti[0] integerValue];
    
    for (int i=1; i < [Voti count]; i++)
    {
        
        /* Se non c'è nessun voto è bene che il MANCA_VOTO preceda il VOTO_SBAGLIATO */
        if(![Voti[i] isEqual:@"1"] && i==0)
            return VOTO_SBAGLIATO;
        
        /* I voti devono essere consecutivi */
        if ([Voti[i] integerValue]>voto+1)
            return VOTO_SBAGLIATO;
        
        voto = [Voti[i] integerValue];
        
    }
    
    return VOTI_OK;
    
}

/* Crea la stringa dei voti da inviare al server */
- (NSMutableString*) getRankingString:(NSMutableDictionary *)ranking
{
    
    NSLog(@"%@",ranking);
    NSMutableString *voti=[[NSMutableString alloc] initWithString:@""];
    for (int voto=1; voto<=candsDim; voto++)
    {
        
        for (NSString *cand in ranking)
        {
            
            if ([[ranking objectForKey:cand] integerValue]==voto)
                voti = [NSMutableString stringWithFormat:@"%@%@",voti,cand];
        }
        
        if(voto<candsDim)
            voti = [NSMutableString stringWithFormat:@"%@,",voti];
    }
    
    return voti;
    
}

/* Funzione delegate per i Popup della view */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    /* Titolo del bottone cliccato */
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    /* L'alert view conseguente ad una votazione effettuata */
    if(alertView.tag == VOTI_OK)
    {
        
        if([title isEqualToString:@"Ok"])
            /* Vai alla Home */
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        
    }
    
}

@end