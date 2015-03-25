#import "ViewController.h"
#import "ConnectionToServer.h"
#import "ApiUrls.h"

@implementation ViewController
{
    //  Oggetto per il refresh da TableView
    UIRefreshControl *refreshControl;
    
    //  Oggetto per la connessione al server
    ConnectionToServer *Connection;
    
    //  Dizionario dei poll pubblici
    NSMutableDictionary *allPublicPolls;
    
    //  Array dei nomi dei polls che verranno visualizzati
    NSMutableArray *pollName;
    
    //  Messaggio nella schermata Home
    UILabel *messageLabel;
    
    //  Flag per la cancellazione delle celle in caso di non connessione
    int flag;
}

@synthesize TableView,Home,MieiSondaggi,Votati,Impostazioni,AddPoll,TabBar;

/*  Funzione che viene eseguita prima che la schermata appaia (funzione di default per iOS)   */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Pulsante Home selezionato (colorato di blu), tutti i pulsanti disattivati
    [TabBar setSelectedItem:Home];
    [self setEnabledAllButton:NO];
    
    //  Download iniziale di tutti i poll pubblici
    Connection = [[ConnectionToServer alloc]init];
    [Connection scaricaPollsWithPollId:@"" andUserId:@"" andStart:@""];
    allPublicPolls = Connection.getDizionarioPolls;
    
    //  Se non c'è connessione o non ci sono poll pubblici, il background della TableView è senza linee
    if (allPublicPolls==nil || [allPublicPolls count] == 0)
        self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //  Esempio grafico (Dovranno esserci i nomi dei poll pubblici qui)
    pollName = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    //  Inizialmente posto a zero
    flag = 0;
    
    //  Questa è la parte di codice che definisce il refresh da parte della TableView
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(HomePolls) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 0;
    [self.TableView addSubview:refreshControl];
}

/*  Funzione che viene eseguita quando tutti gli elementi della view vengono caricati (funzione di default per iOS)     */
- (void)viewDidAppear:(BOOL)animated
{
    [self HomePolls];
}

/*  Funzione che prova a scaricare tutti i poll. Legata alla schermata Home.                                            *
 *  Viene eseguita al momento dell'apertura dell'app, al momento del refresh ed in seguito ad una notifica di app non   *
 *  connessa ad internet.                                                                                               *
 *  ANCORA DA IMPLEMENTARE IL CARICAMENTO DEI POLL!                                                                     */
- (void)HomePolls
{
    //  Dichiarazione della label da mostrare in caso di non connessione o assenza di poll
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel setFrame:CGRectOffset(messageLabel.bounds, CGRectGetMidX(self.TableView.frame) - CGRectGetWidth(self.TableView.bounds)/2, CGRectGetMidY(self.TableView.frame) - CGRectGetHeight(self.TableView.bounds))];
    
    if (allPublicPolls!=nil)
    {
        //  Setta tutti i pulsanti come abilitati
        [self setEnabledAllButton:YES];
        
        if([allPublicPolls count] != 0)
        {
            //  Background con linee
            self.TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
            //  (TO-DO) CARICAMENTO POLL PUBBLICI
        }
        
        else
        {
            //  Background senza linee e definizione del messaggio di assenza poll pubblici
            self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            messageLabel.text = EMPTYPOLLSLIST;
            [self.TableView addSubview:messageLabel];
            [self.TableView sendSubviewToBack:messageLabel];
        }
    }
    
    else //Internet assente
    {
        //  Rimuoviamo tutte le celle dei poll per mostrare il messaggio di assenza connessione
        if(flag == 0) {
            
            [pollName removeAllObjects];
            [TableView reloadData];
            flag = 1;
            
        }
        
        //  Background senza linee e definizione del messaggio di mancata connessione
        self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        messageLabel.text = SERVER_UNREACHABLE;
        [self.TableView addSubview:messageLabel];
        [self.TableView sendSubviewToBack:messageLabel];
        
        /*  Abilita solo i pulsanti:                                            *
            - Impostazioni (poichè è possibile usarlo anche senza internet)     *
            - Pagina corrente (Home)                                            */
        [Home setEnabled:YES];
        [Impostazioni setEnabled:YES];
    }
    
    //  Conclude il refresh (Sparisce l'animazione)
    [refreshControl endRefreshing];
    
    //  Refresh (dopo scroll) dei poll pubblici
    Connection = [[ConnectionToServer alloc]init];
    [Connection scaricaPollsWithPollId:@"" andUserId:@"" andStart:@""];
    allPublicPolls = Connection.getDizionarioPolls;
    
}

- (IBAction)downScroll:(id)sender
{
    //  Disabilitata, abbiamo il refresh da TableView fatto bene.
}

/*  Funzioni necessarie per popolare le celle con i nomi dei poll pubblici (NON TOCCARE - FUNZIONA PERFERTTAMENTE)      */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pollName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    cell.textLabel.text = [pollName objectAtIndex:indexPath.row];
    return cell;
}

/*  Funzione che setta tutti i pulsanti: attivi o disattivi                                                             */
- (void) setEnabledAllButton:(BOOL)enabled
{
    [Home setEnabled:enabled];
    [MieiSondaggi setEnabled:enabled];
    [Votati setEnabled:enabled];
    [Impostazioni setEnabled:enabled];
    [AddPoll setEnabled:enabled];
}

/*  Funzione relativa a problemi di memoria (funzione di default per iOS)                                               */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end