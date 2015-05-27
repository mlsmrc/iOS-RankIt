#import "TableViewControllerResults.h"
#import "ViewControllerCandidates.h"
#import "ViewControllerDettagli.h"
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
    
    /* Messaggio nella schermata Home */
    UILabel *messageLabel;
 
    /* Spinner per il ricaricamento della view dei risultati */
    UIActivityIndicatorView *spinner;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
    
}

@synthesize poll,candidate,classificaFinale,tableView,FLAG;

- (void)viewDidLoad {
    
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
    
    /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    if(FLAG == 0) {
        
        /* Nasconde la table view e fa partire l'animazione dello spinner */
        [spinner startAnimating];
        [self.tableView setHidden:YES];
        
    }

}

- (void) viewDidAppear:(BOOL)animated {
    
    if(FLAG == 0) {
        
        /* Scarica i risultati per il poll selezionato */
        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
        classificaFinale = [conn getOptimalResultsOfPoll:poll];
    
        /* Gestione di 0 voti nel poll e della connessione */
        if([classificaFinale count] == 0 || classificaFinale==nil)
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
    
    NSMutableArray *candidates = [poll candidates];
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
    else image = [image initWithImage:[UIImage imageNamed:@"GreyMedal"]];
    
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

    if([segue.identifier isEqualToString:@"showVotedResultsDetails"]) {
        
        ViewControllerDettagli *destViewController = segue.destinationViewController;
        destViewController.p = poll;
        [FLAGS removeAllObjects];
        [FLAGS addObject:@"DETTAGLI"];
        [File writeOnReload:@"0" ofFlags:FLAGS];
        
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
        
        candidate = poll.candidates[indexCand];

        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK_TO_RANKING,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        ViewControllerCandidates *destViewController = segue.destinationViewController;
        destViewController.c = candidate;
        
    }
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza voti */
- (void) printMessageError {
    
    /* Background senza linee e definizione del messaggio di assenza poll pubblici o assenza connessione */
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Assegna il messaggio a seconda dei casi */
    if(classificaFinale!=nil)
        messageLabel.text = NO_RANKING;
    
    else messageLabel.text = TIMEOUT;
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [tableView addSubview:messageLabel];
    [tableView sendSubviewToBack:messageLabel];
    
}

@end