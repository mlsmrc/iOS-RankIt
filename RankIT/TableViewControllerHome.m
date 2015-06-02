#import "TableViewControllerHome.h"
#import "ViewControllerDettagli.h"
#import "ConnectionToServer.h"
#import "APIurls.h"
#import "Font.h"
#import "File.h"
#import "Util.h"

@interface UIViewController ()

@end

@implementation TableViewControllerHome {
    
    /* Oggetto per la connessione al server */
    ConnectionToServer *Connection;
    
    /* Dizionario dei poll pubblici */
    NSMutableDictionary *allPublicPolls;
    
    /* Array dei poll pubblici che verranno visualizzati */
    NSMutableArray *allPublicPollsDetails;
    
    /* Array per i risultati di ricerca */
    NSArray *searchResults;
    
    /* Oggetto per il refresh da TableView */
    UIRefreshControl *refreshControl;
    
    /* Variabile che conterrà la subview da rimuovere */
    UIView *subView;
    
    /* Messaggio nella schermata "Home" */
    UILabel *messageLabel;
    
    /* Pulsante di ritorno schermata precedente */
    UIBarButtonItem *backButton;
    
    /* Campo per l'api utile per scaricare i poll */
    int start;
    
    /* Booleano per indicare se si può/deve aggiornare e scaricare i poll nuovi */
    BOOL UPLOAD;
    
    /* Refresh control per i poll aggiuntivi */
    UIRefreshControl *footerRefreshControl;
    
    /* Spinner per il ricaricamento della "Home" */
    UIActivityIndicatorView *spinner;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
    
}

@synthesize FLAG_HOME;

- (void) viewDidLoad {

    [super viewDidLoad];
    
    FLAGS = [[NSMutableArray alloc]init];
    [FLAGS addObject:@"HOME"];
    [File writeOnReload:@"0" ofFlags:FLAGS];
    
    /* Puoi scaricare i poll */
    UPLOAD = YES;
    
    allPublicPollsDetails = [[NSMutableArray alloc]init];
    
    start = 0;
    
    /* Setta la spaziatura per i voti corretta per ogni IPhone */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(screenWidth == IPHONE_6_WIDTH)
        X_FOR_VOTES = IPHONE_6;
    
    else {
        
        if(screenWidth == IPHONE_6Plus_WIDTH)
            X_FOR_VOTES = IPHONE_6Plus;
        
        else
            X_FOR_VOTES = IPHONE_4_4S_5_5S;
        
    }
    
    bool write;
    
    /* Se non esiste un UDID, lo genera. Servirà per le votazioni */
    if([File getUDID]==NULL)
        write = [File writeUDID];
    
    /* Permette alle table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    searchResults = [[NSArray alloc]init];
    
    /* Dichiarazione della label da mostrare in caso di non connessione o assenza di poll */
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.font = [UIFont fontWithName:FONT_HOME size:20];
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.tag = 1;
    [messageLabel setFrame:CGRectOffset(messageLabel.bounds, CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.view.bounds)/2, CGRectGetMidY(self.view.frame) - CGRectGetHeight(self.view.bounds)/1.3)];
    
    /* Questa è la parte di codice che definisce il refresh da parte della TableView */
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshPolls)  forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 0;
    [self.tableView addSubview:refreshControl];
    
    /* Setup spinner */
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor grayColor]];
    spinner.center = CGPointMake(screenWidth/2,(screenHeight/2)-125);
    [self.view addSubview:spinner];
    
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if ([File readParameterID]!=nil) {
        
        FLAG_HOME = -1;
        [self performSegueWithIdentifier:@"showPollDetails" sender:self];
        
    }
    
    else {
        
        if(FLAG_HOME != -1)
            FLAG_HOME = [[File readFromReload:@"FLAG_HOME"] intValue];
        
        else FLAG_HOME = 0;
        
        [FLAGS addObject:@"MYPOLL"];
        [FLAGS addObject:@"VOTATI"];
        [File writeOnReload:@"0" ofFlags:FLAGS];
        
        [FLAGS removeAllObjects];
        [FLAGS addObject:@"HOME"];
        [File writeOnReload:@"1" ofFlags:FLAGS];
        
        /* Eliminazione della classifica salvata al momento del passaggio da dettagli poll a root */
        [File clearSaveRank];
        
        /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
        
        if(FLAG_HOME == 0) {
            
            /* Ogni volta che la view appare vengono scaricati i primi 10 poll pubblici */
            start = 0;
            [allPublicPolls removeAllObjects];
            [allPublicPollsDetails removeAllObjects];
            
            /* Nasconde la table view e fa partire l'animazione dello spinner */
            [spinner startAnimating];
            [self.tableView setHidden:YES];
            
        }
    
    }
    
}

- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if(FLAG_HOME == 0) {
        
        /* Download dei poll pubblici da 0 a 9 (start è = 0) */
        [self DownloadPolls:start];

    
        /* Se non c'è connessione o non ci sono poll pubblici, il background della TableView è senza linee */
        if(allPublicPolls==nil || [allPublicPolls count]==0)
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        /* Si ferma l'animazione dello spinner e riappare la table view */
        [spinner stopAnimating];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [self.tableView setHidden:NO];
        
    }
    
    [self.tableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

/* Funzione per scaricare i primi 10 poll una volta che si refresha la TableView */
- (void) refreshPolls {
    
    /* Puoi scaricare poll */
    UPLOAD=YES;
    
    /* Pulisci tutto quello scaricato in precedenza */
    [allPublicPolls removeAllObjects];
    [allPublicPollsDetails removeAllObjects];
    
    /* Inizia il download da 0 */
    start=0;
    [self DownloadPolls:start];
    
}

/* Download poll pubblici dal server */
- (void) DownloadPolls:(int)startPoll {
    
    Connection = [[ConnectionToServer alloc]init];
    NSString *value;
    NSMutableDictionary *allMyPolls = [[NSMutableDictionary alloc]init];
    
    /* Scarica i poll dell'utente e ne filtra i privati */
    if(startPoll==0) {
        
        [Connection scaricaPollsWithPollId:@"" andUserId:[File getUDID] andStart:[NSString stringWithFormat:@"%d",startPoll]];
        allMyPolls = Connection.getDizionarioPolls;
        
        for(id key in allMyPolls) {
            
            value = [allMyPolls objectForKey:key];
            if([value valueForKey:@"unlisted"]==0)
                [allMyPolls removeObjectForKey:key];
        
        }
    
    }
    
    /* Scarica i poll pubblici */
    [Connection scaricaPollsWithPollId:@"" andUserId:@"" andStart:[NSString stringWithFormat:@"%d",startPoll]];
    allPublicPolls = Connection.getDizionarioPolls;
    [allPublicPolls setValuesForKeysWithDictionary:allMyPolls];
    
    if(allPublicPolls!=nil && [allPublicPolls count] != 0) {
        
        [self CreatePollsDetails];
        [self.tableView reloadData];
        
    }
    
    if([allPublicPolls count]<10)
        UPLOAD=NO;
    
    [self HomePolls];
    
}

/* Estrapolazione dei dettagli dei poll pubblici ritornati dal server */
- (void) CreatePollsDetails {
    
    NSString *value;
    
    
    /* Scorre il dizionario e recupera i dettagli necessari */
    for(id key in allPublicPolls) {
        
        value = [allPublicPolls objectForKey:key];
        
        Poll *p = [[Poll alloc]initPollWithPollID:[[value valueForKey:@"pollid"] intValue]
                                         withName:[value valueForKey:@"pollname"]
                                  withDescription:[value valueForKey:@"polldescription"]
                                  withResultsType:([[value valueForKey:@"results"] isEqual:@"full"]? 1:0 )
                                     withDeadline:[value valueForKey:@"deadline"]
                                      withPrivate:([[value valueForKey:@"unlisted"] isEqual:@"1"]? true:false)
                                   withLastUpdate:[value valueForKey:@"updated"]
                                         withMine:[[value valueForKey:@"mine"] intValue]
                                   withCandidates:nil
                                        withVotes:(int)[[value valueForKey:@"votes"] integerValue]];

        
        
        [allPublicPollsDetails addObject:p];
        
    }
    
}

/* Visualizzazione poll pubblici nella schermata "Home" */
- (void) HomePolls {
    
    if(allPublicPolls!=nil) {
        
        if([allPublicPolls count] != 0) {
            
            /* Rimuoviamo la subview aggiunta per il messaggio d'errore */
            subView  = [self.tableView viewWithTag:1];
            [subView removeFromSuperview];
            
            /* Background con linee */
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }
        
        else {
            
            /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza poll */
            [allPublicPollsDetails removeAllObjects];
            [self.tableView reloadData];
            
            /* Stampa del messaggio di notifica */
            [self printMessageError];
            
        }
        
    }
    
    /* Internet assente */
    else {
        
        /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza connessione */
        [allPublicPollsDetails removeAllObjects];
        [self.tableView reloadData];
        
        /* Stampa del messaggio di notifica */
        [self printMessageError];
        
    }
    
    /* Conclude il refresh (Sparisce l'animazione) */
    [refreshControl endRefreshing];
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza poll pubblici */
- (void) printMessageError {
    
    /* Background senza linee e definizione del messaggio di assenza poll pubblici o assenza connessione */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Assegna il messaggio a seconda dei casi */
    if(allPublicPolls!=nil)
        messageLabel.text = EMPTY_POLLS_LIST;
    
    else messageLabel.text = SERVER_UNREACHABLE;
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [self.tableView addSubview:messageLabel];
    [self.tableView sendSubviewToBack:messageLabel];
    
}

/* Permette di modificare l'altezza delle righe della schermata "Home" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di visualizzare i nomi dei poll pubblici nelle celle della schermata "Home" o nei risultati di ricerca */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
        if([searchResults count] == 0) {
            
            [self.searchDisplayController.searchResultsTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
            
            for(UIView *view in self.searchDisplayController.searchResultsTableView.subviews) {
                
                if([view isKindOfClass:[UILabel class]]) {
                    
                    ((UILabel *)view).font = [UIFont fontWithName:FONT_HOME size:20];
                    ((UILabel *)view).textColor = [UIColor darkGrayColor];
                    ((UILabel *)view).text = NO_RESULTS;
                    
                }
            }
            
        }
        
        else [self.searchDisplayController.searchResultsTableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
        
        return [searchResults count];
        
    }
    
    else return [allPublicPollsDetails count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"PollCell";
    Poll *p;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        p = [searchResults objectAtIndex:indexPath.row];
        
    }
    
    else
        p = [allPublicPollsDetails objectAtIndex:indexPath.row];
    
    /* Visualizzazione del poll nella cella */
    UIImageView *imagePoll = (UIImageView *) [cell viewWithTag:100];
    imagePoll.image = [UIImage imageNamed:@"PlaceholderImageCell"];
    imagePoll.contentMode = UIViewContentModeScaleAspectFit;
    imagePoll.layer.cornerRadius = imagePoll.frame.size.width/2;
    imagePoll.clipsToBounds = YES;
    
    UILabel *NamePoll = (UILabel *)[cell viewWithTag:101];
    NamePoll.text = p.pollName;
    NamePoll.font = [UIFont fontWithName:FONT_HOME size:18];
    
    UILabel *DeadlinePoll = (UILabel *)[cell viewWithTag:102];
    DeadlinePoll.text = [Util toStringUserFriendlyDate:(NSString *)p.deadline];
    DeadlinePoll.font = [UIFont fontWithName:FONT_HOME size:12];
    
    UILabel *VotiPoll = (UILabel *)[cell viewWithTag:103];
    VotiPoll.text = [NSString stringWithFormat:@"Voti: %d",p.votes];
    VotiPoll.font = [UIFont fontWithName:FONT_HOME size:12];
    
    /* Immagine se e solo se poll privato */
    if (p.pvtPoll==true) {
        
        UIImageView *imagePrivate = (UIImageView *) [cell viewWithTag:104];
        imagePrivate.image = [UIImage imageNamed:@"Unlisted"];
        imagePrivate.contentMode = UIViewContentModeScaleAspectFit;
        imagePrivate.layer.cornerRadius = imagePrivate.frame.size.width/2;
        imagePrivate.clipsToBounds = YES;
    
    }
    
    else {
        
        UIImageView *imagePrivate = (UIImageView *) [cell viewWithTag:104];
        imagePrivate.image = [UIImage new];
    
    }

    /* Muove la posizione dei voti a seconda del telefono */
    CGRect newPosition = VotiPoll.frame;
    newPosition.origin.x= X_FOR_VOTES;
    VotiPoll.frame = newPosition;
    
    return cell;
    
}

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"pollName CONTAINS[c] %@",searchText];
    searchResults = [allPublicPollsDetails filteredArrayUsingPredicate:resultPredicate];
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
    
}

/* Funzioni che permettono di accedere alla descrizione di un determinato poll sia dalla schermata "Home" che dai risultati di ricerca */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showPollDetails"]) {
        
        NSIndexPath *indexPath = nil;
        Poll *p = nil;
        
        
        NSString *parameterID = [File readParameterID];
         
         if (parameterID!=nil) {
             ConnectionToServer *conn = [[ConnectionToServer alloc]init];
             [conn scaricaPollsWithPollId:parameterID andUserId:@"" andStart:@""];
             NSMutableDictionary *result = [conn getDizionarioPolls];
             NSString *value = [result valueForKey:parameterID];
         
         
             p = [[Poll alloc]initPollWithPollID:[[value valueForKey:@"pollid"] intValue]
                                        withName:[value valueForKey:@"pollname"]
                                 withDescription:[value valueForKey:@"polldescription"]
                                 withResultsType:([[value valueForKey:@"results"] isEqual:@"full"]? 1:0 )
                                    withDeadline:[value valueForKey:@"deadline"]
                                     withPrivate:([[value valueForKey:@"unlisted"] isEqual:@"1"]? true:false)
                                  withLastUpdate:[value valueForKey:@"updated"]
                                        withMine:[[value valueForKey:@"mine"] intValue]
                                  withCandidates:nil
                                       withVotes:[[value valueForKey:@"votes"] intValue]];
         
         
             [File clearParameterID];
             
         }
        else
        {
            if(self.searchDisplayController.active) {
            
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            p = [searchResults objectAtIndex:indexPath.row];
            backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(SEARCH,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
            
            }
        
            else {
            
            indexPath = [self.tableView indexPathForSelectedRow];
            p = [allPublicPollsDetails objectAtIndex:indexPath.row];
            backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK_TO_HOME,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
            }
        }
        
        ViewControllerDettagli *destViewController = segue.destinationViewController;
        destViewController.p = p;
        destViewController.FLAG_ITEM = 0;
        
        [FLAGS removeAllObjects];
        [FLAGS addObject:@"DETTAGLI"];
        [File writeOnReload:@"0" ofFlags:FLAGS];
        
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.tableView == self.searchDisplayController.searchResultsTableView) {
        
        [self performSegueWithIdentifier:@"showPollDetails" sender:self];
        
    }
    
}

/* Funzioni utili ad una corretta visualizzazione della table view e della search bar */
- (void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            for(UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0,statusBarFrame.size.height);
            
        }];
        
    }
    
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            for(UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
            
        }];
        
    }
    
}

/* Funzione che gestisce lo scroll dall'alto verso il basso per caricare ulteriori poll se ce ne sono di altri non caricati */
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    if(endScrolling >= scrollView.contentSize.height && UPLOAD==YES) {
        
        /* Scarica i successivi 10 */
        start+=10;
        [self DownloadPolls:start];
        
    }
    
}

@end