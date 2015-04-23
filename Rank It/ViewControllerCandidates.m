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
    currentY += 20;
    frame.origin.y = currentY;
    image.frame = frame;
    currentY += image.frame.size.height;
    frame = description.frame;
    currentY += 20;
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

/* ---------------------------------------------- */
/* QUALCOSA SERVIRA DOPO PER VOTARE, NON BUTTARE! */

///* Invio della classifica al server */
//- (IBAction) inviaVoto:(id)sender
//{
//    
//    /* Dizionario di voti */
//    NSMutableDictionary *voti = [[NSMutableDictionary alloc]init];
//    [voti setObject:[VotoForPrimo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"a" ];
//    [voti setObject:[VotoForSecondo.text stringByReplacingOccurrencesOfString:@"°" withString:@"" ] forKey:@"b" ];
//    [voti setObject:[VotoForTerzo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"c" ];
//    
//    if (candsDim >= 4)
//        [voti setObject:[VotoForQuarto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"d" ];
//    if (candsDim == 5)
//        [voti setObject:[VotoForQuinto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"e" ];
//    
//    /* Sort dei voti per facilitare il controllo successivo */
//    NSMutableArray *votiSorted = [[NSMutableArray alloc]init];
//    NSString *value;
//    
//    for(id key in voti) {
//        
//        value = [voti objectForKey:key] ;
//        [votiSorted addObject:value];
//    
//    }
//    
//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//    votiSorted = (NSMutableArray*)[votiSorted sortedArrayUsingDescriptors:@[sd]];
//    
//    /* Gestione dei valori */
//    int resultsCheckVoti = [self checkVoti: votiSorted];
//    
//    if(resultsCheckVoti==VOTI_OK)
//    {
//        
//        ConnectionToServer *conn = [[ConnectionToServer alloc] init];
//        NSMutableString *stringVotiToSubmit = [self getRankingString:voti];
//        NSLog(@"%@",stringVotiToSubmit);
//        [conn submitRankingWithPollId:[NSString stringWithFormat:@"%d",poll.pollId]  andUserId:poll.userID andRanking:stringVotiToSubmit];
//        
//        /* Popup per voto sottomesso */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = VOTI_OK;
//        alert = [alert initWithTitle:@"Messaggio" message:@"Votazione effettuata con successo!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        
//    }
//    
//    else if(resultsCheckVoti==VOTO_SBAGLIATO)
//    {
//        
//        /* Popup per voto sbagliato */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = VOTO_SBAGLIATO;
//        alert = [alert initWithTitle:@"Attenzione" message:@"Devono esistere voti consecutivi!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
//        [alert show];
//        
//    }
//    
//    else if(resultsCheckVoti==MANCA_VOTO)
//    {
//        
//        /* Popup per voto sbagliato */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = MANCA_VOTO;
//        alert = [alert initWithTitle:@"Attenzione" message:@"Manca uno o più di un voto!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
//        [alert show];
//        
//    }
//    
//}
//
///* Controllo sui voti */
//- (int) checkVoti: (NSMutableArray *)Voti
//{
//    
//    /* I voti sono ordinati, basta controllare i primi valori se sono "-" o "" poichè vengono prima nell'ordine QUASI lessicografico */
//    if([Voti[0] isEqual:@"-"] || [Voti[0] isEqual:@""])
//        return MANCA_VOTO;
//    
//    long voto = [Voti[0] integerValue];
//    
//    for (int i=1; i < [Voti count]; i++)
//    {
//        
//        /* Se non c'è nessun voto è bene che il MANCA_VOTO preceda il VOTO_SBAGLIATO */
//        if(![Voti[i] isEqual:@"1"] && i==0)
//            return VOTO_SBAGLIATO;
//        
//        /* I voti devono essere consecutivi */
//        if ([Voti[i] integerValue]>voto+1)
//            return VOTO_SBAGLIATO;
//        
//        voto = [Voti[i] integerValue];
//        
//    }
//    
//    return VOTI_OK;
//    
//}
//
///* Crea la stringa dei voti da inviare al server */
//- (NSMutableString*) getRankingString:(NSMutableDictionary *)ranking
//{
//    
//    NSLog(@"%@",ranking);
//    NSMutableString *voti=[[NSMutableString alloc] initWithString:@""];
//    for (int voto=1; voto<=candsDim; voto++)
//    {
//        
//        for (NSString *cand in ranking)
//        {
//            
//            if ([[ranking objectForKey:cand] integerValue]==voto)
//                voti = [NSMutableString stringWithFormat:@"%@%@",voti,cand];
//        }
//        
//        if(voto<candsDim)
//            voti = [NSMutableString stringWithFormat:@"%@,",voti];
//    }
//    
//    return voti;
//    
//}
//
///* Funzione delegate per i Popup della view */
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    /* Titolo del bottone cliccato */
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    
//    /* L'alert view conseguente ad una votazione effettuata */
//    if(alertView.tag == VOTI_OK)
//    {
//        
//        if([title isEqualToString:@"Ok"])
//            /* Vai alla Home */
//            [self.navigationController popToRootViewControllerAnimated:TRUE];
//        
//    }
//    
//}
/* ---------------------------------------------- */

@end