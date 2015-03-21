//
//  ViewController.m
//  RateIt
//
//  Created by Valentina Pizzo on 19/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#import "ViewController.h"
#define ARC4RANDOM_MAX      0x100000000

@interface ViewController ()
@end

@implementation ViewController

@synthesize TableView,Home,MieiSondaggi,Votati,Impostazioni,AddPoll,WarningInternet,CheckingInternet;

- (void)viewDidLoad {
    
    /*  Prima che viene fatto il check sulla rete, la TableView *
     *  viene messa invisibile e gli altri elementi vengono     *
     *  settati come non abilitati                              */
    [TableView setHidden:YES];
    [self setAllButtonWithBool:NO];
    
    /* La scritta che ti notifica il server non raggiungibile   *
     * viene messa ad invisibile, mentre il l'activityIndicator *
     * viene messa a visibile e in funzione                     */
    
    [WarningInternet setHidden:YES];
    [CheckingInternet setHidden:NO];
    [CheckingInternet startAnimating];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/*  Funzione che viene eseguita quando tutti gli elementi       *
 *  della view vengono caricati                                 */
- (void)viewDidAppear:(BOOL)animated
{
    [self attemptToSeeView];
}

/*  Funzione che controlla se l'app ha l'accesso ad internet    *
 *  YES, se ha accesso ad internet                              *
 *  NO,  altrimenti                                             *
 *  DA IMPLEMENTARE                                             */
-(BOOL)checkInternet
{
    sleep(1);
    double random = ((double)arc4random() / (ARC4RANDOM_MAX));
    if(random>0.5)
    {
        NSLog(@"Connesso!");
        return true;
    }
    else
    {
        NSLog(@"Non connesso!");
        return false;
    }
}

/*  Funzione che viene eseguita quando si cerca di ottenere la  *
 *  TableView.
 *  Viene eseguita al momento dell'apertura dell'app e al       *
 *  momento del refresh in seguito ad una notifica di app non   *
 *  connessa ad internet.                                       *
 *  DA IMPLEMENTARE IL CARICAMENTO DEI POLL                     */
-(void)attemptToSeeView
{
    // controllo della connessione ad internet
    BOOL internet = [self checkInternet];
    
    // L'activityIndicator viene stoppata e settata a invisibile
    [CheckingInternet stopAnimating];
    [CheckingInternet setHidden:YES];
    
    if (internet)
    {
        /*  Setta tutti i pulsanti come abilitati               */
        [self setAllButtonWithBool:YES];
        
        /*  La tableView viene settata a visibile e vengono     *
         *  caricati i poll                                     */
        [TableView setHidden:NO];
        
        //CARICAMENTO POLL...
    }
    // internet mancante
    else
    {
        // visualizza la label di mancata connessione ad internet
        [WarningInternet setHidden:NO];
        
        /* setta a visibile solo il pulsante delle impostazioni *
         * poichè è possibile usarlo anche senza internet       */
        [Impostazioni setEnabled:YES];
        
    }
}

/*  Funzione relativa all'azione  di downScroll                 *
 *  Disabilita tutti i bottoni e ritenta il collegamento ad     *
 *  internet con conseguente aggiornamento dei poll             */
- (IBAction)downScroll:(id)sender
{
    [self setAllButtonWithBool:NO];
    [TableView setHidden:YES];
    [CheckingInternet setHidden:NO];
    [CheckingInternet startAnimating];
    [self attemptToSeeView];
}

/*  Funzione che setta tutti i bottoni a attivi o disattivi     */
- (void) setAllButtonWithBool:(BOOL)enabled
{
    [Home setEnabled:enabled];
    [MieiSondaggi setEnabled:enabled];
    [Votati setEnabled:enabled];
    [Impostazioni setEnabled:enabled];
    [AddPoll setEnabled:enabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
