#import "TableViewControllerMyPoll.h"
#import "TableViewControllerResults.h"
#import "ViewControllerDettagli.h"
#import "ConnectionToServer.h"
#import "APIurls.h"
#import "Font.h"
#import "File.h"
#import "Util.h"
#import "SWTableViewCell.h"
#import "UMTableViewCell.h"
#import "Reachability.h"

#define DELETE_POLL 2
#define RESET_POLL 1
#define EDIT_POLL 0


@interface UIViewController ()

@end
@implementation TableViewControllerMyPoll {
    
    /* Oggetto per la connessione al server */
    ConnectionToServer *Connection;
    
    /* Dizionario dei poll */
    NSMutableDictionary *allMyPolls;
    
    /* Array dei poll che verranno visualizzati */
    NSMutableArray *allMyPollsDetails;
    
    /* Array per i risultati di ricerca */
    NSArray *searchResults;
    
    /* Oggetto per il refresh da TableView */
    UIRefreshControl *refreshControl;
    
    /* Variabile che conterrà la subview da rimuovere */
    UIView *subView;
    
    /* Messaggio nella schermata "I Miei Sondaggi" */
    UILabel *messageLabel;
    
    /* Pulsante di ritorno schermata precedente */
    UIBarButtonItem *backButton;
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    /* Setta la spaziatura per i voti corretta per ogni IPhone */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == IPHONE_6_WIDTH)
        X_FOR_VOTES = IPHONE_6;
    
    else {
        
        if(screenWidth == IPHONE_6Plus_WIDTH)
            X_FOR_VOTES = IPHONE_6Plus;
        
        else
            X_FOR_VOTES = IPHONE_4_4S_5_5S;
        
    }
    
    /* Permette alle table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    /* Download iniziale di tutti i poll */
    [self DownloadPolls];
    
    /* Se non c'è connessione o non ci sono poll , il background della TableView è senza linee */
    if(allMyPolls==nil || [allMyPolls count]==0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Altrimenti prende i nomi dei poll da visualizzare */
    else [self CreatePollsDetails];
    
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
    [refreshControl addTarget:self action:@selector(DownloadPolls) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 0;
    [self.tableView addSubview:refreshControl];
    
    /* Visualizza i poll nella schermata "I Miei Sondaggi" */
    [self MyPolls];
    
}

/* Download poll dal server */
- (void) DownloadPolls {
    
    Connection = [[ConnectionToServer alloc]init];
    
    /* Connessione di prova */
    [Connection scaricaPollsWithPollId:@"" andUserId:[File getUDID] andStart:@""];
    
    
    allMyPolls = [Connection getDizionarioPolls];
    
    if(allMyPolls!=nil && [allMyPolls count] != 0) {
        
        [self CreatePollsDetails];
        [self.tableView reloadData];
        
    }
    
    [self MyPolls];
    
}

/* Estrapolazione dei dettagli dei poll ritornati dal server */
- (void) CreatePollsDetails {
    
    NSString *value;
    allMyPollsDetails = [[NSMutableArray alloc]init];
    
    /* Scorre il dizionario e recupera i dettagli necessari */
    for(id key in allMyPolls) {
        
        value = [allMyPolls objectForKey:key];
        
        Poll *p = [[Poll alloc]initPollWithPollID:[[value valueForKey:@"pollid"] intValue]
                                         withName:[value valueForKey:@"pollname"]
                                  withDescription:[value valueForKey:@"polldescription"]
                                  withResultsType:([[value valueForKey:@"results"] isEqual:@"full"]? 1:0)
                                     withDeadline:[value valueForKey:@"deadline"]
                                   withLastUpdate:[value valueForKey:@"updated"]
                                   withCandidates:nil
                                        withVotes:(int)[[value valueForKey:@"votes"] integerValue]];
        
        
        [allMyPollsDetails addObject:p];
        
    }
    
}

/* Visualizzazione poll nella schermata "I Miei Sondaggi" */
- (void) MyPolls {
    
    if(allMyPolls!=nil) {
        
        if([allMyPolls count] != 0) {
            
            /* Rimuoviamo la subview aggiunta per il messaggio d'errore */
            subView  = [self.tableView viewWithTag:1];
            [subView removeFromSuperview];
            
            /* Background con linee */
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }
        
        else {
            
            /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza poll */
            [allMyPollsDetails removeAllObjects];
            [self.tableView reloadData];
            
            /* Stampa del messaggio di notifica */
            [self printMessaggeError];
            
        }
        
    }
    
    /* Internet assente */
    else {
        
        /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza connessione */
        [allMyPollsDetails removeAllObjects];
        [self.tableView reloadData];
        
        /* Stampa del messaggio di notifica */
        [self printMessaggeError];
        
    }
    
    /* Conclude il refresh (Sparisce l'animazione) */
    [refreshControl endRefreshing];
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza poll */
- (void) printMessaggeError {
    
    /* Background senza linee e definizione del messaggio di assenza poll o assenza connessione */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Assegna il messaggio a seconda dei casi */
    if(allMyPolls!=nil)
        messageLabel.text = EMPTY_MY_POLLS_LIST;
    
    else messageLabel.text = SERVER_UNREACHABLE;
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [self.tableView addSubview:messageLabel];
    [self.tableView sendSubviewToBack:messageLabel];
    
}

/* Permette di modificare l'altezza delle righe della schermata "I Miei Sondaggi" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di visualizzare i nomi dei poll nelle celle della schermata "I Miei Sondaggi" o nei risultati di ricerca */
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
    
    else return [allMyPollsDetails count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MyPollCell";
    UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
        cell = [[UMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    Poll *p;
    
    //[cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:58.0f];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        p = [searchResults objectAtIndex:indexPath.row];
    
    else
        p = [allMyPollsDetails objectAtIndex:indexPath.row];
    
    /* Visualizzazione del poll nella cella */
    UILabel *NamePoll = (UILabel *)[cell viewWithTag:101];
    NamePoll.text = p.pollName;
    NamePoll.font = [UIFont fontWithName:FONT_HOME size:18];
    
    UILabel *DeadlinePoll = (UILabel *)[cell viewWithTag:102];
    DeadlinePoll.text = [Util toStringUserFriendlyDate:(NSString *)p.deadline];
    DeadlinePoll.font = [UIFont fontWithName:FONT_HOME size:12];
    
    
    UILabel *VotiPoll = (UILabel *)[cell viewWithTag:103];
    VotiPoll.text = [NSString stringWithFormat:@"Voti: %d",p.votes];
    VotiPoll.font = [UIFont fontWithName:FONT_HOME size:12];
    
    /* Muovo la posizione dei voti a seconda del telefono */
    CGRect newPosition = VotiPoll.frame;
    newPosition.origin.x= X_FOR_VOTES;
    VotiPoll.frame = newPosition;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"pollName CONTAINS[c] %@",searchText];
    searchResults = [allMyPollsDetails filteredArrayUsingPredicate:resultPredicate];
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    /* Eliminazione della classifica salvata al momento del passaggio da vota poll a dettagli poll */
    [File clearSaveRank];
    
    /* Ogni volta che la view appare vengono scaricati i poll creati */
    [self DownloadPolls];
    
}

/* Gestione barra dei bottoni con swipe */
- (NSArray *) rightButtons {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]title:@"Modif."];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0]title:@"Azzera"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0]title:@"Elimina"];
    
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,(id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,nil];
    
    return rightUtilityButtons;
    
}

/* - (NSArray *) leftButtons {
 
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0]title:@"Elimina"];
    return leftUtilityButtons;
 
}*/

#pragma mark - SWTableViewDelegate

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
            
        case DELETE_POLL: {
            
            /* Cattura del poll */
            Poll *p;
            
            if(self.tableView == self.searchDisplayController.searchResultsTableView) {
                
                cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                p = [searchResults objectAtIndex:index];
                
            }
            
            else
                p = [allMyPollsDetails objectAtIndex:index];
            
            UIAlertController *AlertDelete;
            UIAlertAction *ok;
            
            if(p.votes!=0) {
                
                /* Alert eliminazione */
                AlertDelete = [UIAlertController alertControllerWithTitle:@"Impossibile eliminare!" message:@"Questo sondaggio possiede dei voti.\nResettalo prima di eliminarlo." preferredStyle:UIAlertControllerStyleActionSheet];
                
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    /* Rientro dell'alert */
                    [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                /* Aggiunta pulsante all'alert */
                [AlertDelete addAction:ok];
                
            }
            
            else {
                
                /* Controllo connessione */
                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                
                if([networkReachability currentReachabilityStatus] == NotReachable) {
                    
                    AlertDelete= [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                        /* Rientro dell'alert */
                        [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    /* Aggiunta pulsanti all'alert */
                    [AlertDelete addAction:ok];
                    
                    /* Uscita dell'alert */
                    [self presentViewController:AlertDelete animated:YES completion:nil];
                    
                    [cell hideUtilityButtonsAnimated:YES];
                    break;
                    
                }
                
                /* Alert eliminazione */
                AlertDelete = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"Sei sicuro di voler eliminare il sondaggio?" preferredStyle:UIAlertControllerStyleActionSheet];
                
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Elimina" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                    
                    /* Controllo connessione */
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    
                    if(![networkReachability currentReachabilityStatus] == NotReachable) {
                        
                        /* Se c'è connessione, elimina il poll e ricarica la schermata */
                        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
                        [conn deletePollWithPollId:[NSString stringWithFormat:@"%d",p.pollId] AndUserID:[File getUDID]];
                        [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                        
                        /* Dopo l'eliminazione è utile ricaricare i vari contenuti */
                        [self DownloadPolls];
                        searchResults = nil;
                        searchResults = [[NSArray alloc]init];
                        [self.searchDisplayController.searchResultsTableView reloadData];
                        
                    }
                    
                    else {
                        
                        /* Altrimenti notifica l'accaduto */
                        UIAlertController *OkAlertReset = [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        /* Uscita dell'alert */
                        [self presentViewController:OkAlertReset animated:YES completion:nil];
                        
                        UIAlertAction *okreset = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            
                            /* Rientro dell'alert */
                            [OkAlertReset dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
                        
                        [OkAlertReset addAction:okreset];
                        
                    }
                    
                }];
                
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    /* Rientro dell'alert */
                    [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                /* Aggiunta pulsanti all'alert */
                [AlertDelete addAction:ok];
                [AlertDelete addAction:cancel];
                
            }
            
            /* Presentazione dell'alert */
            [self presentViewController:AlertDelete animated:YES completion:nil];
            [cell hideUtilityButtonsAnimated:YES];
            break;
            
        }
            
    }
    
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
            
        case EDIT_POLL: {
            break;
        }
        case RESET_POLL: {
            
            /* Cattura del poll */
            Poll *p;
            
            /* indice della riga cliccata */
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            if(self.tableView == self.searchDisplayController.searchResultsTableView) {
                
                cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                
                p = [searchResults objectAtIndex:cellIndexPath.row];
                
            }
            
            else
                p = [allMyPollsDetails objectAtIndex:cellIndexPath.row];
            
            UIAlertController *AlertReset;
            UIAlertAction *ok;
            
            if(p.votes>0) {
                
                /* Controllo connessione */
                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                
                if([networkReachability currentReachabilityStatus] == NotReachable) {
                    
                    AlertReset = [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                        /* Rientro dell'alert */
                        [AlertReset dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    /* Aggiunta pulsanti all'alert */
                    [AlertReset addAction:ok];
                    
                    /* Uscita dell'alert */
                    [self presentViewController:AlertReset animated:YES completion:nil];
                    
                    [cell hideUtilityButtonsAnimated:YES];
                    break;
                    
                }
                
                AlertReset = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"Sei sicuro di voler azzerare i voti?" preferredStyle:UIAlertControllerStyleActionSheet];
                
            }
            
            else {
                
                AlertReset = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"Il sondaggio non ha nessun voto da eliminare." preferredStyle:UIAlertControllerStyleActionSheet];
                
                ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    /* Rientro dell'alert */
                    [AlertReset dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                /* Aggiunta pulsanti all'alert */
                [AlertReset addAction:ok];
                
                /* Uscita dell'alert */
                [self presentViewController:AlertReset animated:YES completion:nil];
                
                [cell hideUtilityButtonsAnimated:YES];
                break;
                
            }
            
            /* Creazione pulsanti */
            ok = [UIAlertAction actionWithTitle:@"Azzera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                
                /* Handler dell'ok */
                ConnectionToServer *Conn = [[ConnectionToServer alloc]init];
                
                if([Conn resetPollWithPollId:[NSString stringWithFormat:@"%d",p.pollId] AndUserID:[File getUDID]]) {
                    
                    /* Se c'è connessione, resetta i voti del poll */
                    [p setVotes:0];
                    [allMyPolls setValue:p forKey:[NSString stringWithFormat:@"%ld",(long)index]];
                    
                    /* Dopo l'azzeramento è utile ricaricare i vari contenuti */
                    [self.searchDisplayController.searchResultsTableView reloadData];
                    [self.tableView reloadData];
                    
                }
                
                else {
                    
                    /* Altrimenti notifica l'accaduto */
                    UIAlertController *OkAlertReset = [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    /* Uscita dell'alert */
                    [self presentViewController:OkAlertReset animated:YES completion:nil];
                    
                    UIAlertAction *okreset = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                        /* Rientro dell'alert */
                        [OkAlertReset dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    [OkAlertReset addAction:okreset];
                    
                }
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
                /* Rientro dell'alert */
                [AlertReset dismissViewControllerAnimated:YES completion:nil];
                
            }];
            
            /* Aggiunta pulsanti all'alert */
            [AlertReset addAction:ok];
            [AlertReset addAction:cancel];
            
            /* Uscita dell'alert */
            [self presentViewController:AlertReset animated:YES completion:nil];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
            
        }
        case DELETE_POLL: {
            
            /* Cattura del poll */
            Poll *p;
            
            /* indice della riga cliccata */
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            if(self.tableView == self.searchDisplayController.searchResultsTableView) {
                
                cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                p = [searchResults objectAtIndex:cellIndexPath.row];
                
            }
            
            else
                p = [allMyPollsDetails objectAtIndex:cellIndexPath.row];
            
            UIAlertController *AlertDelete;
            UIAlertAction *ok;
            
            if(p.votes!=0) {
                
                /* Alert eliminazione */
                AlertDelete = [UIAlertController alertControllerWithTitle:@"Impossibile eliminare!" message:@"Questo sondaggio possiede dei voti.\nResettalo prima di eliminarlo." preferredStyle:UIAlertControllerStyleActionSheet];
                
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    /* Rientro dell'alert */
                    [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                /* Aggiunta pulsante all'alert */
                [AlertDelete addAction:ok];
                
            }
            
            else {
                
                /* Controllo connessione */
                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                
                if([networkReachability currentReachabilityStatus] == NotReachable) {
                    
                    AlertDelete= [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                        /* Rientro dell'alert */
                        [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    /* Aggiunta pulsanti all'alert */
                    [AlertDelete addAction:ok];
                    
                    /* Uscita dell'alert */
                    [self presentViewController:AlertDelete animated:YES completion:nil];
                    
                    [cell hideUtilityButtonsAnimated:YES];
                    break;
                    
                }
                
                /* Alert eliminazione */
                AlertDelete = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"Sei sicuro di voler eliminare il sondaggio?" preferredStyle:UIAlertControllerStyleActionSheet];
                
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Elimina" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                    
                    /* Controllo connessione */
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    
                    if(![networkReachability currentReachabilityStatus] == NotReachable) {
                        
                        /* Se c'è connessione, elimina il poll e ricarica la schermata */
                        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
                        [conn deletePollWithPollId:[NSString stringWithFormat:@"%d",p.pollId] AndUserID:[File getUDID]];
                        [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                        
                        /* Dopo l'eliminazione è utile ricaricare i vari contenuti */
                        [self DownloadPolls];
                        searchResults = nil;
                        searchResults = [[NSArray alloc]init];
                        [self.searchDisplayController.searchResultsTableView reloadData];
                        
                    }
                    
                    else {
                        
                        /* Altrimenti notifica l'accaduto */
                        UIAlertController *OkAlertReset = [UIAlertController alertControllerWithTitle:@"Errore!" message:SERVER_UNREACHABLE_2 preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        /* Uscita dell'alert */
                        [self presentViewController:OkAlertReset animated:YES completion:nil];
                        
                        UIAlertAction *okreset = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            
                            /* Rientro dell'alert */
                            [OkAlertReset dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
                        
                        [OkAlertReset addAction:okreset];
                        
                    }
                    
                }];
                
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    /* Rientro dell'alert */
                    [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                /* Aggiunta pulsanti all'alert */
                [AlertDelete addAction:ok];
                [AlertDelete addAction:cancel];
                
            }
            
            /* Presentazione dell'alert */
            [self presentViewController:AlertDelete animated:YES completion:nil];
            [cell hideUtilityButtonsAnimated:YES];
            break;
            
        }
            
        default:
            break;
            
    }
    
}

- (BOOL) swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
    
}

- (BOOL) swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    
    switch (state) {
            
        case 1:
            return YES;
            break;
            
        case 2:
            return YES;
            break;
            
        default:
            break;
            
    }
    
    return YES;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showMyPollResults" sender:self];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showMyPollResults"]) {
        
        NSIndexPath *indexPath = nil;
        Poll *p = nil;
        
        if (self.searchDisplayController.active) {
            
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            p = [searchResults objectAtIndex:indexPath.row];
            backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(SEARCH,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
        }
        
        else {
            
            indexPath = [self.tableView indexPathForSelectedRow];
            p = [allMyPollsDetails objectAtIndex:indexPath.row];
            backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK_TO_MY_POLL,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
        }
        
        TableViewControllerResults *destViewController = segue.destinationViewController;
        destViewController.poll = p;
        
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

@end