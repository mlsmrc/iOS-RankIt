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

@synthesize TableView,Home,MieiSondaggi,Votati,Impostazioni,AddPoll,TabBar;

/*  Funzione che viene eseguita prima che la schermata appaia (funzione di default per iOS)   */
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //  Pulsante Home selezionato (colorato di blu), tutti i pulsanti disattivati, TableView senza righe
    [TabBar setSelectedItem:Home];
    [self setEnabledAllButton:NO];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
 *  Viene eseguita al momento dell'apertura dell'app, al momento del refresh ed in seguito ad una notifica di app non   *
 *  connessa ad internet.                                                                                               *
 *  ANCORA DA IMPLEMENTARE IL CARICAMENTO DEI POLL!                                                                     */
- (void)HomePolls
{
    
    //  Download di tutti i poll pubblici
    ConnectionToServer *Connection = [[ConnectionToServer alloc]init];
    [Connection scaricaPollsWithPollId:@"" andUserId:@"" andStart:@""];
    NSDictionary *allPublicPolls = Connection.getDizionarioPolls;
    //  Decommentare/Commentare la riga sotto per simulare cosa succede senza/con connessione.
    //  allPublicPolls = nil;
    
    if (allPublicPolls!=nil)
    {
        //  Setta tutti i pulsanti come abilitati
        [self setEnabledAllButton:YES];
        
        //  (TO-DO) CARICAMENTO POLL
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Qui vedremo i poll pubblici.\nSe scrollate fa refresh!";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.TableView.backgroundView = messageLabel;
    }
    
    else //Internet assente
    {
        //  MANCATA CONNESSIONE
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Problema di connessione.\nSe scrollate cerca di riconnettersi!";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.TableView.backgroundView = messageLabel;
        
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