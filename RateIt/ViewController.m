#import "ViewController.h"
#import "ConnectionToServer.h"
#import "ApiUrls.h"

@interface ViewController ()
{
    
    //  Oggetto per il refresh da TableView
    UIRefreshControl *refreshControl;
    
}

@end

@implementation ViewController

@synthesize TableView,Home,MieiSondaggi,Votati,Impostazioni,AddPoll,WarningInternet,TabBar;

/*  Funzione che viene eseguita prima che la schermata appaia (funzione di default per iOS)   */
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    /*  Prima che viene fatto il check sulla rete, la TableView viene resa invisibile e gli altri elementi vengono      *
     *  settati come non abilitati, il bottone Home viene settato come abilitato                                        */
    [TabBar setSelectedItem:Home];
    [TableView setHidden:YES];
    [self setEnabledAllButton:NO];
    
    //  La scritta che notifica il server non raggiungibile viene messa ad invisibile
    [WarningInternet setHidden:YES];
    
    //  Questa è la parte di codice che definisce il refresh da parte della TableView
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(HomePolls) forControlEvents:UIControlEventValueChanged];
    [self.TableView addSubview:refreshControl];
    
}

/*  Funzione che viene eseguita quando tutti gli elementi della view vengono caricati (funzione di default per iOS)     */
- (void)viewDidAppear:(BOOL)animated
{
    [self HomePolls];
}

/*  Funzione che prova a scaricare tutti i poll. Legata alla schermata Home.                                            *
 *  Viene eseguita al momento dell'apertura dell'app e al momento del refresh in seguito ad una notifica di app non     *
 *  connessa ad internet.                                                                                               *
 *  ANCORA DA IMPLEMENTARE IL CARICAMENTO DEI POLL!                                                                     */
- (void)HomePolls
{
    
    //  Download di tutti i poll pubblici
    ConnectionToServer *Connection = [[ConnectionToServer alloc]init];
    [Connection scaricaPollsWithPollId:@"" andUserId:@"" andStart:@""];
    NSDictionary *allPublicPolls = Connection.getDizionarioPolls;
    //  Decommentate la riga sotto per vedere cosa succede se siamo senza connessione. Bisogna decidere però come gestire il refresh.
    //  allPublicPolls = nil;
    
    if (allPublicPolls!=nil)
    {
        //  Setta tutti i pulsanti come abilitati
        [self setEnabledAllButton:YES];
        
        //  La tableView viene settata a visible e vengono caricati i poll
        [TableView setHidden:NO];
        
        //  (TO-DO) CARICAMENTO POLL.
    }
    
    else //Internet assente
    {
        //  Visualizza la label di mancata connessione ad internet
        [WarningInternet setHidden:NO];
        
        /*  Abilita solo i pulsanti:                                            *
            - Impostazioni (poichè è possibile usarlo anche senza internet)     *
            - Pagina corrente (Home)                                            */
        [Home setEnabled:YES];
        [Impostazioni setEnabled:YES];
    }
    
    //  Conclude il refresh (Sparisce l'animazione)
    [refreshControl endRefreshing];
}

- (IBAction)downScroll:(id)sender
{
    //  Disabilitata, abbiamo il refresh da TableView fatto bene.
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