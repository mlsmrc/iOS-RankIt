#import "ViewControllerVoto.h"
#import "ConnectionToServer.h"
#import "Util.h"
#import "Font.h"
#import "File.h"

#define VOTO_OK 0
#define VOTO_SCADUTO 1

@interface ViewControllerVoto ()

@end

@implementation ViewControllerVoto {
    
    /* Per controllare se c'è timeout di connessione */
    bool resultConnection;
    
    /* Flag utile per capire se un sondaggio è già stato votato */
    int FLAG_ALREADY_VOTES;
    
}

@synthesize candidateNames,candidateChars,name,poll,tableView,fourth,fifth;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /* Fa apparire eventuali posizioni nascoste precedentemente */
    [fourth setHidden:NO];
    [fifth setHidden:NO];
    
    /* Impostata su "editing" la table view per poter muovere le celle */
    [tableView setEditing:YES animated:YES];
    
    /* Permette alla table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    /* Nasconde le label delle posizioni che non servono */
    if([candidateNames count] == 3) {
        
        [fourth setHidden:YES];
        [fifth setHidden:YES];
        
    }
    
    else if([candidateNames count] == 4)
        [fifth setHidden:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    FLAG_ALREADY_VOTES = 0;
    
}


/* Funzioni che permettono di visualizzare i nomi dei candidates nelle celle della schermata del voto */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [candidateNames count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"VoteCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    name = [candidateNames objectAtIndex:indexPath.row];
    
    /* Visualizzazione Candidato nella cella */
    UILabel *PosCand = (UILabel *)[cell viewWithTag:100];
    NSString *Position = [NSString stringWithFormat: @"%ld°", (long)(indexPath.row+1)];
    PosCand.text = Position;
    PosCand.font = [UIFont fontWithName:FONT_CANDIDATES_NAME size:16];
    
    UILabel *NameCand = (UILabel *)[cell viewWithTag:101];
    NameCand.text = name;
    NameCand.font = [UIFont fontWithName:FONT_CANDIDATES_NAME size:16];
    
    return cell;
    
}

/* Permette di modificare l'altezza delle righe della schermata "Home" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di stilare la classifica mediante drag & drop delle celle */
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

/* Metodo che tiene conto della classifica fatta dall'utente mediante l'array */
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [candidateNames objectAtIndex:sourceRow];
    [candidateNames removeObjectAtIndex:sourceRow];
    [candidateNames insertObject:object atIndex:destRow];
    object = [candidateChars objectAtIndex:sourceRow];
    [candidateChars removeObjectAtIndex:sourceRow];
    [candidateChars insertObject:object atIndex:destRow];
    
    /* Creazione rank */
    NSString *rankToSave = @"";
    for(int i=0; i<[candidateChars count]; i++)
        if(i!=[candidateChars count])
            rankToSave = [NSString stringWithFormat:@"%@,%@",rankToSave,candidateChars[i]];
    
    /* Salvataggio rank */
    [File SaveRank:rankToSave OfPoll:[NSString stringWithFormat:@"%d",poll.pollId]];
    
}

/* Invio della classifica al server */
- (IBAction) vota:(id)sender {
    
    /* Contiene i pollid di tutti i poll votati dall'utente */
    NSArray *VotesPListKeys = [File getAllKeysinPList:VOTES_PLIST];
    
    if([VotesPListKeys containsObject:[NSString stringWithFormat:@"%d",poll.pollId]] && poll.votes>0)
        FLAG_ALREADY_VOTES = 1;
    
    if([Util compareDate:[NSDate new] WithDate:poll.deadline]==1) {
        
        /* Popup per voto sottomesso */
        UIAlertView *alert = [UIAlertView alloc];
        alert.tag = VOTO_SCADUTO;
        alert = [alert initWithTitle:@"Esito Votazione" message:@"Sondaggio scaduto!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    
    }
    
    else {
        
        ConnectionToServer *conn = [[ConnectionToServer alloc]init];
        NSMutableString *ranking = [[NSMutableString alloc]initWithString:@""];
        
        for(int i=0;i<[candidateChars count];i++) {
            
            if(i != [candidateChars count] - 1)
                ranking = [NSMutableString stringWithFormat:@"%@%@,",ranking,[candidateChars objectAtIndex:i]];
            
            else
                ranking = [NSMutableString stringWithFormat:@"%@%@",ranking,[candidateChars objectAtIndex:i]];
            
        }
        
        /* Invio voto al server */
        resultConnection = [conn submitRankingWithPollId:[NSString stringWithFormat:@"%d",poll.pollId]  andUserId:[File getUDID] andRanking:ranking];
        
        /* Popup per voto sottomesso */
        UIAlertView *alert = [UIAlertView alloc];
        alert.tag = VOTO_OK;
        
        if(FLAG_ALREADY_VOTES==1 && poll.votes>0)
            alert = [alert initWithTitle:@"Esito Votazione" message:(resultConnection == true ? @"Votazione effettuata con successo!\nIl tuo voto è stato sovrascritto al precedente." : TIMEOUT) delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        else
            alert = [alert initWithTitle:@"Esito Votazione" message:(resultConnection == true ? @"Votazione effettuata con successo!" : TIMEOUT) delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
    
    }
    
}

/* Funzione delegate per i Popup della view */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* Titolo del bottone cliccato */
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    /* L'alert view conseguente ad una votazione effettuata */
    if(alertView.tag == VOTO_OK) {
        
        if([title isEqualToString:@"Ok"] && resultConnection==true)
            
            /* Vai alla Home */
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        
    }
    
    else if (alertView.tag == VOTO_SCADUTO && [title isEqualToString:@"Ok"]) {
        
        /* Vai alla Home */
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    
    }
    
}

@end