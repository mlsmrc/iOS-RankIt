#import "TableViewControllerResults.h"
#import "ViewControllerCandidates.h"
#import "ViewControllerDettagli.h"
#import "ViewControllerVoto.h"
#import "Font.h"
#import "File.h"
#import "Candidate.h"
#import "Util.h"

@interface TableViewControllerResults ()

@end

@implementation TableViewControllerResults {
    
    /* Pulsante di ritorno schermata precedente */
    UIBarButtonItem *backButton;
    
    /* Variabile che conterrà la subview da rimuovere */
    UIView *subView;
    
    /* Messaggio nella schermata della classifica */
    UILabel *messageLabel;
 
    /* Spinner per il ricaricamento della view dei risultati */
    UIActivityIndicatorView *spinner;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
    
}

@synthesize p,candidate,classificaFinale,tableView,FLAG;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    FLAGS = [[NSMutableArray alloc]init];
    
    /* Permette alle table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    /* Setup spinner */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor grayColor]];
    spinner.center = CGPointMake(width/2, (height/2)-150);
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
    
    [super viewWillAppear:animated];
    
    FLAG = [[File readFromReload:@"FLAG_RISULTATI"] intValue];
    
    [FLAGS removeAllObjects];
    [FLAGS addObject:@"RISULTATI"];
    [File writeOnReload:@"1" ofFlags:FLAGS];
    
    if(FLAG == 0) {
        
        /* Nasconde la table view e fa partire l'animazione dello spinner */
        [spinner startAnimating];
        [self.tableView setHidden:YES];
        
    }
    
    /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

}

- (void) viewDidAppear:(BOOL)animated {
    
    /* Se è un poll scaduto non viene permessa la votazione */
    if([Util compareDate:[[NSDate alloc]init] WithDate:p.deadline]==1)
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    if(FLAG == 0) {
        
        /* Scarica i risultati per il poll selezionato */
        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
        classificaFinale = [conn getOptimalResultsOfPoll:p];
    
        /* Gestione di 0 voti nel poll e della connessione */
        if([classificaFinale count] == 0 || classificaFinale == nil)
            [self printMessageError];
    
        /* Si ferma l'animazione dello spinner e riappare la table view */
        [spinner stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    
    }
    
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [classificaFinale count]-1;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ResultCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    NSMutableArray *candidates = [p candidates];
    NSString *risp = [classificaFinale objectAtIndex:indexPath.row];
    
    /* Cattura dell'indice per estrarre il candidato */
    int indexCand = -1;
    if([risp isEqual:@"A"])        indexCand = 0;
    else if([risp isEqual:@"B"])   indexCand = 1;
    else if([risp isEqual:@"C"])   indexCand = 2;
    else if([risp isEqual:@"D"])   indexCand = 3;
    else                            indexCand = 4;
    
    Candidate *c = candidates[indexCand];
    
    /* Classifica con pattern completo del tipo A=B>C */
    NSString *classifica=[classificaFinale objectAtIndex:[classificaFinale count]-1];
    NSMutableArray * rankLabels=[[NSMutableArray alloc]init];
    
    int j=1;
    
    for(int i=0;i<[classifica length];i++) {
    
        if(i==0)
        [rankLabels addObject:[NSString stringWithFormat:@"%d",j]];
        
        else if(i!=0 && i%2==1 && [classifica characterAtIndex:i]=='=')
            [rankLabels addObject:[NSString stringWithFormat:@"%d",j]];
        
        else if(i!=0 && i%2==1 &&[classifica characterAtIndex:i]=='>') {
            
            j++;
            [rankLabels addObject:[NSString stringWithFormat:@"%d",j]];
            
        }
        
    }
    
    /* Visualizzazione del risultato nella cella */
    UIImageView *image = (UIImageView *)[cell viewWithTag:100];
    if([[rankLabels objectAtIndex:indexPath.row]isEqualToString:@"1"]) image = [image initWithImage:[UIImage imageNamed:@"GoldMedal"]];
    else if([[rankLabels objectAtIndex:indexPath.row]isEqualToString:@"2"]) image = [image initWithImage:[UIImage imageNamed:@"SilverMedal"]];
    else if([[rankLabels objectAtIndex:indexPath.row]isEqualToString:@"3"]) image = [image initWithImage:[UIImage imageNamed:@"BronzeMedal"]];
    else image = [image initWithImage:[UIImage imageNamed:@"GrayMedal"]];
    
    UILabel *NamePoll = (UILabel *)[cell viewWithTag:101];
    NamePoll.text = c.candName;
    
    /* Nome su più linee */
    NamePoll.adjustsFontSizeToFitWidth  = NO;
    NamePoll.numberOfLines = 0;
    NamePoll.font = [UIFont fontWithName:FONT_CANDIDATES_NAME size:16];
    
    return cell;

}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showCandRankDetails" sender:self];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"showReVoteView"]) {
        
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
                    
                    candidate = [[p candidates] objectAtIndex:0];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"b"]) {
                    
                    candidate = [[p candidates] objectAtIndex:1];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"c"]) {
                    
                    candidate = [[p candidates] objectAtIndex:2];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"d"]) {
                    
                    candidate = [[p candidates] objectAtIndex:3];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"e"]) {
                    
                    candidate = [[p candidates] objectAtIndex:4];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
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
                    
                    candidate = [[p candidates] objectAtIndex:0];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];

                    
                }
                
                if([arrayVoti[i] containsString:@"b"]) {
                    
                    candidate = [[p candidates] objectAtIndex:1];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"c"]) {
                    
                    candidate = [[p candidates] objectAtIndex:2];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"d"]) {
                    
                    candidate = [[p candidates] objectAtIndex:3];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];
                    
                }
                
                if([arrayVoti[i] containsString:@"e"]) {
                    
                    candidate = [[p candidates] objectAtIndex:4];
                    [destViewController.candidateChars addObject:candidate.candChar];
                    [destViewController.candidateNames addObject:candidate.candName];

                    
                }
                
            }
            
        }
        
        /* Poll mai votato prima */
        else {
            
            /* Inizializza normalmente l'array dei candidates */
            for(int i=0;i<[[p candidates] count];i++) {
                
                candidate = [[p candidates] objectAtIndex:i];
                [destViewController.candidateChars addObject:candidate.candChar];
                [destViewController.candidateNames addObject:candidate.candName];

                
            }
            
        }

        
    }
    
    else if([segue.identifier isEqualToString:@"showCandRankDetails"]) {
        
        NSIndexPath *indexPath = nil;
        NSString *candChar;
        candidate = nil;
        
        indexPath = [self.tableView indexPathForSelectedRow];
        candChar = [classificaFinale objectAtIndex:indexPath.row];
        
        /* Cattura dell'indice per estrarre il candidato */
        int indexCand = -1;
        if([candChar isEqual:@"A"])        indexCand = 0;
        else if([candChar isEqual:@"B"])   indexCand = 1;
        else if([candChar isEqual:@"C"])   indexCand = 2;
        else if([candChar isEqual:@"D"])   indexCand = 3;
        else                            indexCand = 4;
        
        candidate = p.candidates[indexCand];

        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK_TO_RANKING,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        ViewControllerCandidates *destViewController = segue.destinationViewController;
        destViewController.c = candidate;
        
    }
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza voti */
- (void) printMessageError {
    
    /* Assegna il messaggio a seconda dei casi */
    if(classificaFinale!=nil)
        messageLabel.text = NO_RANKING;
    
    else {
        
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        messageLabel.text = TIMEOUT;
        
    }
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [tableView addSubview:messageLabel];
    [tableView sendSubviewToBack:messageLabel];
    
}

@end