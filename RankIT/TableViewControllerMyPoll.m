#import "TableViewControllerMyPoll.h"
#import "ViewControllerDettagli.h"
#import "ConnectionToServer.h"
#import "APIurls.h"
#import "Font.h"
#import "File.h"
#import "UtilTableView.h"
#import "SWTableViewCell.h"
#import "UMTableViewCell.h"
#import "Reachability.h"

/* Utile per convertire un colore da esadecimale a "colore Obj-C" */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DELETE_POLL 0
#define RESET_POLL 0
#define EDIT_POLL 1

NSString *USER_TEST = @"693333a879834e2888fffcdadc0d127bee9d18e9583c45859ffb6397625afd44";
@interface UIViewController ()

//@property (nonatomic) BOOL useCustomCells;


@end
@implementation TableViewControllerMyPoll {
    
    /* Oggetto per la connessione al server */
    ConnectionToServer *Connection;
    
    /* Dizionario dei poll votati */
    NSMutableDictionary *allVotedPolls;
    
    /* Array dei poll votati che verranno visualizzati */
    NSMutableArray *allVotedPollsDetails;
    
    /* Array per i risultati di ricerca */
    NSArray *searchResults;
    
    /* Oggetto per il refresh da TableView */
    UIRefreshControl *refreshControl;
    
    /* Variabile che conterrà la subview da rimuovere */
    UIView *subView;
    
    /* Messaggio nella schermata Votati */
    UILabel *messageLabel;
    
    /* Pulsante di ritorno schermata precedente */
    UIBarButtonItem *backButton;
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    /* Permette alle table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    /* Download iniziale di tutti i poll votati */
    [self DownloadPolls];
    
    /* Se non c'è connessione o non ci sono poll votati, il background della TableView è senza linee */
    if(allVotedPolls==nil || [allVotedPolls count]==0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Altrimenti prende i nomi dei poll votati da visualizzare */
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
    
    /* Visualizza i poll votati nella schermata "Votati" */
    [self VotedPolls];
    
}

/* Download poll votati dal server */
- (void) DownloadPolls {
    
    Connection = [[ConnectionToServer alloc]init];
    /* Prova*/
    [Connection scaricaPollsWithPollId:@"" andUserId:USER_TEST andStart:@""];
    /**/
    
    //[Connection scaricaPollsWithPollId:@"" andUserId:[File getUDID] andStart:@""];
    allVotedPolls = [Connection getDizionarioPolls];
    
    if(allVotedPolls!=nil && [allVotedPolls count] != 0)
    {
        [self CreatePollsDetails];
        [self.tableView reloadData];
    }
    
    [self VotedPolls];
    
}

/* Estrapolazione dei dettagli dei poll votati ritornati dal server */
- (void) CreatePollsDetails {
    NSString *value;
    allVotedPollsDetails = [[NSMutableArray alloc]init];
    
    /* Scorre il dizionario e recupera i dettagli necessari */
    for(id key in allVotedPolls) {
        
        value = [allVotedPolls objectForKey:key];
        
        Poll *p = [[Poll alloc]initPollWithPollID:[[value valueForKey:@"pollid"] intValue]
                                         withName:[value valueForKey:@"pollname"]
                                  withDescription:[value valueForKey:@"polldescription"]
                                  withResultsType:([[value valueForKey:@"results"] isEqual:@"full"]? 1:0 )
                                     withDeadline:[value valueForKey:@"deadline"]
                                   withLastUpdate:[value valueForKey:@"updated"]
                                   withCandidates:nil
                                        withVotes:(int)[[value valueForKey:@"votes"] integerValue]];
        
  
        [allVotedPollsDetails addObject:p];
        
    }
}

/* Visualizzazione poll votati nella schermata "Votati" */
- (void) VotedPolls {
    if(allVotedPolls!=nil) {
        
        if([allVotedPolls count] != 0) {
            
            /* Rimuoviamo la subview aggiunta per il messaggio d'errore */
            subView  = [self.tableView viewWithTag:1];
            [subView removeFromSuperview];
            
            /* Background con linee */
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }
        
        else {
            
            /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza poll */
            [allVotedPollsDetails removeAllObjects];
            [self.tableView reloadData];
            
            /* Stampa del messaggio di notifica */
            [self printMessaggeError];
            
        }
        
    }
    
    /* Internet assente */
    else {
        
        /* Rimuove tutte le celle dei poll per mostrare il messaggio di assenza connessione */
        [allVotedPollsDetails removeAllObjects];
        [self.tableView reloadData];
        
        /* Stampa del messaggio di notifica */
        [self printMessaggeError];
        
    }
    
    /* Conclude il refresh (Sparisce l'animazione) */
    [refreshControl endRefreshing];
    
}

/* Funzione per la visualizzazione del messaggio di notifica di assenza connessione o assenza poll pubblici */
- (void) printMessaggeError {
    
    /* Background senza linee e definizione del messaggio di assenza poll pubblici o assenza connessione */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Assegna il messaggio a seconda dei casi */
    if(allVotedPolls!=nil)
        messageLabel.text = EMPTY_MY_POLLS_LIST;
    
    else messageLabel.text = SERVER_UNREACHABLE;
    
    /* Aggiunge la SubView con il messaggio da visualizzare */
    [self.tableView addSubview:messageLabel];
    [self.tableView sendSubviewToBack:messageLabel];
    
}

/* Permette di modificare l'altezza delle righe della schermata "Votati" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di visualizzare i nomi dei poll votati nelle celle della schermata "Votati" o i risultati di ricerca */
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
    
    else return [allVotedPollsDetails count];
    
}

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"pollName CONTAINS[c] %@",searchText];
    searchResults = [allVotedPollsDetails filteredArrayUsingPredicate:resultPredicate];
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
    
}

/* Funzioni che permettono di accedere alla descrizione di un determinato poll sia dalla schermata "Votati" che dai risultati di ricerca */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showMyPollDetails"]) {
        
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
            p = [allVotedPollsDetails objectAtIndex:indexPath.row];
            backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK_TO_VOTED,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
        }
        
        ViewControllerDettagli *destViewController = segue.destinationViewController;
        destViewController.p = p;
        
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        
        [self performSegueWithIdentifier:@"showPollDetails" sender:self];
        
    }
    
}

/* Metodo che fa apparire momentaneamente la scroll bar per far capire all'utente che il contenuto è scrollabile */
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

/* Metodi che servono per mantenere la search bar fuori dallo scroll generale della table view */
- (void) viewWillAppear:(BOOL)animated {
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    /* Eliminazione della classifica salvata al momento del passaggio da vota poll a dettagli poll */
    [File clearSaveRank];
    
    /* Ogni volta che la view appare vengono scaricati i poll votati */
    [self DownloadPolls];
    [super viewWillAppear:animated];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyPollCell" forIndexPath:indexPath];
    Poll *p;
        
    // optionally specify a width that each set of utility buttons will share
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:58.0f];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
        
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        p = [searchResults objectAtIndex:indexPath.row];
    }
        
    else
        p = [allVotedPollsDetails objectAtIndex:indexPath.row];
        
    /* Visualizzazione del poll nella cella */
    UILabel *NamePoll = (UILabel *)[cell viewWithTag:103];
    NamePoll.text = p.pollName;
    NamePoll.font = [UIFont fontWithName:FONT_HOME size:18];
        
    UILabel *DeadlinePoll = (UILabel *)[cell viewWithTag:104];
    DeadlinePoll.text = [NSString stringWithFormat:@"%@              Voti:%d",(NSString *)p.deadline,p.votes];
    DeadlinePoll.font = [UIFont fontWithName:FONT_HOME size:12];
        
        /* Controllo sulla scadenza del poll */
    if([Poll compareDate:p.deadline WithDate:[[NSDate alloc]init]] == -1)
        DeadlinePoll.text = @"Sondaggio scaduto!";
        

        
    return cell;
}

- (NSArray *)rightButtons
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0]
                                                title:@"Reset\nVoti"];
    
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                               title:@"Edit"];
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                            nil];

    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return leftUtilityButtons;
}

// Set row height on an individual basis

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [self rowHeightForIndexPath:indexPath];
//}
//
//- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
//    return ([indexPath row] * 10) + 60;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want default white
}

#pragma mark - SWTableViewDelegate


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}
/* Gestione barra dei bottoni con swipe sinistra -> destra */
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case DELETE_POLL:
        {
            /* Cattura del poll */
            Poll *p;
            if(self.tableView == self.searchDisplayController.searchResultsTableView)
            {
                cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                p = [searchResults objectAtIndex:index];
            }
            
            else
                p = [allVotedPollsDetails objectAtIndex:index];
            
            UIAlertController *AlertDelete;
            if(p.votes!=0)
            {
                /* Alert eliminazione */
                 AlertDelete = [UIAlertController alertControllerWithTitle:@"Delete Poll"
                                                                                     message:[NSString stringWithFormat:@"Impossibile il poll \"%@\"\nPossiede almeno 1 voto.\nResettare il poll prima di eliminare",p.pollName]
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
                
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Si"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                /* Aggiunta pulsante all'alert */
                [AlertDelete addAction:ok];
            }
            else
            {
                /* Alert eliminazione */
                AlertDelete = [UIAlertController alertControllerWithTitle:@"Delete Poll"
                                                                                 message:[NSString stringWithFormat:@"Sei sicuro di voler eliminare il poll \"%@\"?",p.pollName]
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
            
                /* Creazione pulsanti */
                UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Si"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     /* Handler dell'ok */
                                     ConnectionToServer *conn = [[ConnectionToServer alloc]init];
                                     bool response = [conn deletePollWithPollId:[NSString stringWithFormat:@"%d",p.pollId] AndUserID:USER_TEST];
                                     [AlertDelete dismissViewControllerAnimated:YES completion:nil];
                                     
                                     UIAlertController *OkAlertDelete;
                                     
                                     /* Gestione della risposta */
                                     if (response)
                                     {
                                         OkAlertDelete= [UIAlertController alertControllerWithTitle:@"Operazione completata"
                                                                                            message:[NSString stringWithFormat:@"Eliminato il poll \"%@\"",p.pollName]
                                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
                                     }
                                     else
                                     {
                                         OkAlertDelete= [UIAlertController alertControllerWithTitle:@"Errore"
                                                                                            message:@"Problemi di connessione al server"
                                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
                                     }
                                     
                                     UIAlertAction* okdelete = [UIAlertAction
                                                               actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [OkAlertDelete dismissViewControllerAnimated:YES completion:nil];
                                                                   
                                                                   /* Elimina poll senza richiedere una connessione al server */
                                                                   NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                                                                   [allVotedPolls removeObjectForKey:[NSString stringWithFormat:@"%d",p.pollId]];
                                                                   [allVotedPollsDetails removeObjectAtIndex:cellIndexPath.row];
                                                                   [self.tableView reloadData];
                                                                   if ([allVotedPolls count] == 0) {
                                                                       [self printMessaggeError];
                                                                   }
                                                                   
                                                               }];
                                     
                                     [OkAlertDelete addAction:okdelete];
                                     [self presentViewController:OkAlertDelete animated:YES completion:nil];

                                     
                                 }];
                UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Annulla"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         /* Handler del cancel */
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
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case RESET_POLL:
        {
            /* Cattura del poll */
            Poll *p;
            if(self.tableView == self.searchDisplayController.searchResultsTableView)
            {
                cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                p = [searchResults objectAtIndex:index];
            }
            else
                p = [allVotedPollsDetails objectAtIndex:index];

            UIAlertController *AlertReset;
            
            /* Controllo connessione */
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            if ([networkReachability currentReachabilityStatus]==NotReachable) {
                AlertReset = [UIAlertController alertControllerWithTitle:@"Reset Poll"
                                                                                  message:SERVER_UNREACHABLE
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Ok"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         /* Handler del cancel */
                                         [AlertReset dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                /* Aggiunta pulsanti all'alert */
                [AlertReset addAction:ok];
                
                /* Presentazione dell'alert */
                [self presentViewController:AlertReset animated:YES completion:nil];
                
                [cell hideUtilityButtonsAnimated:YES];
                break;
            }
            
            if (p.votes>1)
                AlertReset = [UIAlertController alertControllerWithTitle:@"Reset Poll"
                                                             message:[NSString stringWithFormat:@"Sei sicuro di voler eliminare tutti i %d voti del poll?",p.votes] preferredStyle:UIAlertControllerStyleActionSheet];
            else if (p.votes==1)
                AlertReset = [UIAlertController alertControllerWithTitle:@"Reset Poll"
                                                                 message:@"Sei sicuro di voler eliminare l'unico voto ricevuto al poll?"
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
            else
            {
                AlertReset = [UIAlertController alertControllerWithTitle:@"Reset Poll"
                                                                 message:@"Il poll non ha nessun voto da eliminare"
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             /* Handler del cancel */
                                             [AlertReset dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                
                /* Aggiunta pulsanti all'alert */
                [AlertReset addAction:ok];
                
                /* Presentazione dell'alert */
                [self presentViewController:AlertReset animated:YES completion:nil];
                
                [cell hideUtilityButtonsAnimated:YES];
                break;

            }
            
            /* Creazione pulsanti */
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Si"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     /* Handler dell'ok */
                                     ConnectionToServer *conn = [[ConnectionToServer alloc]init];
                                     UIAlertController *OkAlertReset;
                                     UIAlertAction* okreset;
                                     if([conn resetPollWithPollId:[NSString stringWithFormat:@"%d",p.pollId] AndUserID:USER_TEST])
                                     {
                                         OkAlertReset = [UIAlertController alertControllerWithTitle:@"Operazione completata"
                                                                                              message:[NSString stringWithFormat:@"Eliminati tutti i voti del poll \"%@\"",p.pollName]
                                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
                                         okreset = [UIAlertAction
                                                                   actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                                                   {
                                                                       [OkAlertReset dismissViewControllerAnimated:YES completion:nil];
                                                                       
                                                                       /* Resetta i voti del poll senza richiedere una connessione al server */
                                                                       [p setVotes:0];
                                                                       [allVotedPolls setValue:p forKey:[NSString stringWithFormat:@"%ld",(long)index]];
                                                                       [self.tableView reloadData];
                                                                       
                                                                   }];
                                         
                                         [OkAlertReset addAction:okreset];
                                     }
                                     else
                                     {
                                         OkAlertReset= [UIAlertController alertControllerWithTitle:@"Errore"
                                                                                            message:SERVER_UNREACHABLE
                                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
                                         UIAlertAction* okreset = [UIAlertAction
                                                                   actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                                                   {
                                                                       [OkAlertReset dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
                                         
                                         [OkAlertReset addAction:okreset];
                                     }

                                    [AlertReset dismissViewControllerAnimated:YES completion:nil];
                                     
                                     [self presentViewController:OkAlertReset animated:YES completion:nil];
                                 }];
           UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Annulla"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         /* Handler del cancel */
                                         [AlertReset dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            /* Aggiunta pulsanti all'alert */
            [AlertReset addAction:ok];
            [AlertReset addAction:cancel];
            
            /* Presentazione dell'alert */
            [self presentViewController:AlertReset animated:YES completion:nil];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case EDIT_POLL:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
           // [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0,statusBarFrame.size.height);
        }];
    }
    
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
    
}

@end