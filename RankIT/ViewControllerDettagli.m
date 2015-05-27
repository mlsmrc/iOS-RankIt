#import "ViewControllerCandidates.h"
#import "ConnectionToServer.h"
#import "ViewControllerDettagli.h"
#import "ViewControllerVoto.h"
#import "ViewControllerModPoll.h"
#import "Font.h"
#import "Util.h"
#import "File.h"

@interface ViewControllerDettagli ()

@end

@implementation ViewControllerDettagli {
    
    /* Spinner per il ricaricamento della Schermata */
    UIActivityIndicatorView *spinner;
    
    /* Messaggio nella schermata Home */
    UILabel *messageLabel;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
    
}

@synthesize p,c,scrollView,name,description,image,deadline,cands,tableView,Vota,FLAG;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    FLAGS = [[NSMutableArray alloc]init];
    
    /* Setta la spaziatura per i voti corretta per ogni IPhone */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,415)];
    
    /* Setup spinner */
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor grayColor]];
    spinner.center = CGPointMake(screenWidth/2,(screenHeight/2)-150);
    [self.view addSubview:spinner];
    
    /* Dichiarazione della label da mostrare in caso di non connessione o assenza di poll */
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.font = [UIFont fontWithName:FONT_HOME size:20];
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.tag = 1;
    [messageLabel setFrame:CGRectOffset(messageLabel.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.3)];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    FLAG = [[File readFromReload:@"FLAG_DETTAGLI"] intValue];
    
    [FLAGS removeAllObjects];
    [FLAGS addObject:@"DETTAGLI"];
    [File writeOnReload:@"1" ofFlags:FLAGS];
    
    /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    /* Nasconde la view e fa partire l'animazione dello spinner */
    if(FLAG == 0) {
        
        [spinner startAnimating];
        [scrollView setHidden:YES];
        
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(FLAG == 0) {
        
        /* Download dei candidates */
        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
        NSString *ID = [NSString stringWithFormat:@"%d",[p pollId]];
        cands = [conn getCandidatesWithPollId:ID];
    
        /* Si ferma l'animazione dello spinner e riappare la view e */
        [spinner stopAnimating];
        [self.scrollView setHidden:NO];
    
        /* Tutti i settaggi del caso */
        name.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_BOLD size:21];
        name.text = p.pollName;
    
        deadline.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_LIGHT size:14];
        deadline.textColor = [UIColor blackColor];
        deadline.text = [Util toStringUserFriendlyDate:(NSString *)p.deadline];
    
        description.selectable = true;
        description.font = [UIFont fontWithName:FONT_DETTAGLI_POLL size:16];
        description.backgroundColor = [UIColor clearColor];
        description.textAlignment = NSTextAlignmentNatural;
        description.text = p.pollDescription;
        description.selectable = false;
        [description sizeToFit];
        
        image.image = [UIImage imageNamed:@"PlaceholderImageView"];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.layer.cornerRadius = image.frame.size.width/2;
        image.clipsToBounds = YES;
    
        /* Se è un poll scaduto non viene permessa la votazione */
        if([Util compareDate:[[NSDate alloc]init] WithDate:p.deadline]==1)
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
        /* Se un poll è stato eliminato o non c'è connessione, viene fatto vedere un messaggio a video e disibilitato il tasto "Vota" */
        if([cands count]<3) {
        
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [self printMessageError];
        
        }
        
    }
    
    /* Queste righe di codice servono per rendere variabile, a seconda del contenuto, la lunghezza della view e dello scroll. *
     * I valori che vedete servono per spaziare tra gli oggetti e sono stati scelti empiricamente.                            */
    CGRect frame;
    CGFloat currentY = 0;
    frame = name.frame;
    currentY += 17;
    frame.origin.y = currentY;
    name.frame = frame;
    currentY += name.frame.size.height;
    frame = deadline.frame;
    currentY += 10;
    frame.origin.y = currentY;
    deadline.frame = frame;
    currentY += deadline.frame.size.height;
    frame = image.frame;
    currentY += 17;
    frame.origin.y = currentY;
    image.frame = frame;
    currentY += image.frame.size.height;
    frame = description.frame;
    frame.origin.y = currentY+8;
    description.frame = frame;
    currentY += description.frame.size.height;
    [tableView reloadData];
    frame = tableView.frame;
    currentY += 20;
    frame.origin.y = currentY;
    frame.size.height = (([cands count]*CELL_HEIGHT)+110);
    tableView.frame = frame;
    currentY += tableView.frame.size.height;
    [scrollView setContentSize:CGSizeMake(320,currentY+25)];
    
    [scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza poll pubblici */
- (void) printMessageError {
    
    [self.scrollView setHidden:YES];
    messageLabel.text = TIMEOUT;
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [self.view addSubview:messageLabel];
    [self.view sendSubviewToBack:messageLabel];
    
}

/* Funzioni che permettono di visualizzare i nomi dei candidates nelle celle della schermata dettagli */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cands count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CandCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    CGRect frame;
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    c = [cands objectAtIndex:indexPath.row];
    
    /* Visualizzazione Candidato nella cella */
    UIImageView *imagePoll = (UIImageView *) [cell viewWithTag:100];
    imagePoll.image = [UIImage imageNamed:@"PlaceholderImageCell"];
    imagePoll.contentMode = UIViewContentModeScaleAspectFit;
    imagePoll.layer.cornerRadius = imagePoll.frame.size.width/2;
    imagePoll.clipsToBounds = YES;
    
    UILabel *NameCand = (UILabel *)[cell viewWithTag:101];
    NameCand.text = c.candName;
    NameCand.font = [UIFont fontWithName:FONT_CANDIDATES_NAME size:16];
    
    UILabel *DescriptionCand = (UILabel *)[cell viewWithTag:102];
    DescriptionCand.text = (NSString *)c.candDescription;
    DescriptionCand.font = [UIFont fontWithName:FONT_CANDIDATES_DESCRIPTION size:12];
    
    /* Se non c'è descrizione riposizioniamo la Label del nome al centro della cella */
    if([c.candDescription isEqual:@""]) {
        
        frame = NameCand.frame;
        frame.origin.y = 26;
        NameCand.frame = frame;
        
    }
    
    return cell;
    
}

/* Titolo della table view dei candidates */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"CANDIDATI DELLA CLASSIFICA:";
    
}

/* Permette di modificare l'altezza delle righe della schermata "Home" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di accedere alla descrizione di un determinato candidato */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIBarButtonItem *backButton;
    
    if([segue.identifier isEqualToString:@"showCandDetails"]) {
        
        NSIndexPath *indexPath = nil;
        c = nil;
        
        indexPath = [self.tableView indexPathForSelectedRow];
        c = [cands objectAtIndex:indexPath.row];
        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        ViewControllerCandidates *destViewController = segue.destinationViewController;
        destViewController.c = c;
        
    }
    
    else if([segue.identifier isEqualToString:@"showVoteView"])
    {
        
        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        /* Init delle strutture utili per il segue */
        ViewControllerVoto *destViewController = segue.destinationViewController;
        destViewController.poll = p;
        destViewController.candidateChars = [[NSMutableArray alloc]init];
        destViewController.candidateNames = [[NSMutableArray alloc]init];
        
        /* Lettura di un ipotetico voto già dato al poll */
        NSString *voti = [File getRankingOfPoll:p.pollId];
        
        /* Lettura di un ipotetica classifica salvata */
        NSString *savedRank = [File getSaveRankOfPoll:[NSString stringWithFormat:@"%d",p.pollId]];
        
        /* Poll già votato in precedenza e non salvato */
        if(voti!=NULL && savedRank == NULL) {
            
            /* Divide la classifica */
            NSArray *arrayVoti = [voti componentsSeparatedByString:@","];
            
            /* Riassegnamento array in base al voto già dato al poll */
            for(int i=0;i<[arrayVoti count];i++) {
                
                if([arrayVoti[i] containsString:@"a"]) {
                    
                    c=[cands objectAtIndex:0];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"b"]) {
                    
                    c=[cands objectAtIndex:1];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"c"]) {
                    
                    c=[cands objectAtIndex:2];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"d"]) {
                    
                    c=[cands objectAtIndex:3];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"e"]) {
                    
                    c=[cands objectAtIndex:4];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                   
                }
                
            }
            
        }
        
        /* Classifica salvata */
        else if((voti==NULL && savedRank!=NULL) || (voti!=NULL && savedRank!=NULL)) {
            
            /* Divide la classifica */
            NSArray *arrayVoti = [savedRank componentsSeparatedByString:@","];
            
            /* Riassegnamento array in base al voto già dato al poll */
            for(int i=0;i<[arrayVoti count];i++) {
                
                if([arrayVoti[i] containsString:@"a"]) {
                    
                    c=[cands objectAtIndex:0];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"b"]) {
                    
                    c=[cands objectAtIndex:1];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"c"]) {
                    
                    c=[cands objectAtIndex:2];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"d"]) {
                    
                    c=[cands objectAtIndex:3];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"e"]) {
                    
                    c=[cands objectAtIndex:4];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                    
                }
                
            }
            
        }
        
        /* Poll mai votato prima */
        else {
            
            /* Inizializza normalmente l'array dei candidates */
            for(int i=0;i<[cands count];i++) {
                
                c = [cands objectAtIndex:i];
                [destViewController.candidateChars addObject:c.candChar];
                [destViewController.candidateNames addObject:c.candName];
                
            }
            
        }
        
    }
    
    else if ([[segue identifier] isEqualToString:@"modPoll"])
    {
        ViewControllerModPoll *vc = (ViewControllerModPoll*) [segue destinationViewController ];
        
        vc.p = p; //passiamo il poll da modificare alla view successiva
        vc.candidates = self.cands; //passiamo i candidates alla vista successiva 
        
        
    }
}

/* shouldPerformSegueWithIdentifier verifica che il poll che stiamo andando a modificare non sia già stato votato */

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if([identifier isEqualToString:@"modPoll"] && p.votes == 0)
    {
        return YES;
    
    }else if([identifier isEqualToString:@"modPoll"] && p.votes > 0)
    {
        [self errorHandlerModifyPoll]; //lanciamo un alert in quanto il poll è già stato votato
        return NO;
    }else
    {
        return YES;
    }
}

/* Error Handler in caso di modifica pool già votato */

- (void) errorHandlerModifyPoll
{

    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test Message"
                                                    message:@"This is a test"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    
    

}

/* Funzione delegate per i Popup della view */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* Titolo del bottone cliccato */
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Ok"])
        /* Vai alla Home */
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    
}





@end