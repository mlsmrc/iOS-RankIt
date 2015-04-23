#import "ViewControllerVoto.h"
#import "UtilTableView.h"

@interface ViewControllerVoto ()

@end

@implementation ViewControllerVoto

@synthesize candidates,c,tableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /* Impostata su "editing" la table view per poter muovere le celle */
    [tableView setEditing:YES animated:YES];
    
    /* Permette alla table view di non stampare celle vuote che vanno oltre quelle dei risultati */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

/* Funzioni che permettono di visualizzare i nomi dei candidates nelle celle della schermata del voto */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [candidates count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"VoteCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    c = [candidates objectAtIndex:indexPath.row];
    cell.textLabel.text = c.candName;
    cell.imageView.image = [UtilTableView imageWithImage:[UIImage imageNamed:@"Poll-image"] scaledToSize:CGSizeMake(CELL_HEIGHT-20, CELL_HEIGHT-20)];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
    
}

/* Permette di modificare l'altezza delle righe della schermata "Home" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di stilare la classifica mediante drag & drop delle celle */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [candidates exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

@end

/* ---------------------------------------------- */
/* QUALCOSA SERVIRA DOPO PER VOTARE, NON BUTTARE! */

///* Invio della classifica al server */
//- (IBAction) inviaVoto:(id)sender
//{
//
//    /* Dizionario di voti */
//    NSMutableDictionary *voti = [[NSMutableDictionary alloc]init];
//    [voti setObject:[VotoForPrimo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"a" ];
//    [voti setObject:[VotoForSecondo.text stringByReplacingOccurrencesOfString:@"°" withString:@"" ] forKey:@"b" ];
//    [voti setObject:[VotoForTerzo.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"c" ];
//
//    if (candsDim >= 4)
//        [voti setObject:[VotoForQuarto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"d" ];
//    if (candsDim == 5)
//        [voti setObject:[VotoForQuinto.text stringByReplacingOccurrencesOfString:@"°" withString:@""] forKey:@"e" ];
//
//    /* Sort dei voti per facilitare il controllo successivo */
//    NSMutableArray *votiSorted = [[NSMutableArray alloc]init];
//    NSString *value;
//
//    for(id key in voti) {
//
//        value = [voti objectForKey:key] ;
//        [votiSorted addObject:value];
//
//    }
//
//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//    votiSorted = (NSMutableArray*)[votiSorted sortedArrayUsingDescriptors:@[sd]];
//
//    /* Gestione dei valori */
//    int resultsCheckVoti = [self checkVoti: votiSorted];
//
//    if(resultsCheckVoti==VOTI_OK)
//    {
//
//        ConnectionToServer *conn = [[ConnectionToServer alloc] init];
//        NSMutableString *stringVotiToSubmit = [self getRankingString:voti];
//        NSLog(@"%@",stringVotiToSubmit);
//        [conn submitRankingWithPollId:[NSString stringWithFormat:@"%d",poll.pollId]  andUserId:poll.userID andRanking:stringVotiToSubmit];
//
//        /* Popup per voto sottomesso */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = VOTI_OK;
//        alert = [alert initWithTitle:@"Messaggio" message:@"Votazione effettuata con successo!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//
//    }
//
//    else if(resultsCheckVoti==VOTO_SBAGLIATO)
//    {
//
//        /* Popup per voto sbagliato */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = VOTO_SBAGLIATO;
//        alert = [alert initWithTitle:@"Attenzione" message:@"Devono esistere voti consecutivi!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
//        [alert show];
//
//    }
//
//    else if(resultsCheckVoti==MANCA_VOTO)
//    {
//
//        /* Popup per voto sbagliato */
//        UIAlertView *alert = [UIAlertView alloc];
//        alert.tag = MANCA_VOTO;
//        alert = [alert initWithTitle:@"Attenzione" message:@"Manca uno o più di un voto!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Correggi", nil];
//        [alert show];
//
//    }
//
//}
//
///* Controllo sui voti */
//- (int) checkVoti: (NSMutableArray *)Voti
//{
//
//    /* I voti sono ordinati, basta controllare i primi valori se sono "-" o "" poichè vengono prima nell'ordine QUASI lessicografico */
//    if([Voti[0] isEqual:@"-"] || [Voti[0] isEqual:@""])
//        return MANCA_VOTO;
//
//    long voto = [Voti[0] integerValue];
//
//    for (int i=1; i < [Voti count]; i++)
//    {
//
//        /* Se non c'è nessun voto è bene che il MANCA_VOTO preceda il VOTO_SBAGLIATO */
//        if(![Voti[i] isEqual:@"1"] && i==0)
//            return VOTO_SBAGLIATO;
//
//        /* I voti devono essere consecutivi */
//        if ([Voti[i] integerValue]>voto+1)
//            return VOTO_SBAGLIATO;
//
//        voto = [Voti[i] integerValue];
//
//    }
//
//    return VOTI_OK;
//
//}
//
///* Crea la stringa dei voti da inviare al server */
//- (NSMutableString*) getRankingString:(NSMutableDictionary *)ranking
//{
//
//    NSLog(@"%@",ranking);
//    NSMutableString *voti=[[NSMutableString alloc] initWithString:@""];
//    for (int voto=1; voto<=candsDim; voto++)
//    {
//
//        for (NSString *cand in ranking)
//        {
//
//            if ([[ranking objectForKey:cand] integerValue]==voto)
//                voti = [NSMutableString stringWithFormat:@"%@%@",voti,cand];
//        }
//
//        if(voto<candsDim)
//            voti = [NSMutableString stringWithFormat:@"%@,",voti];
//    }
//
//    return voti;
//
//}
//
///* Funzione delegate per i Popup della view */
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//    /* Titolo del bottone cliccato */
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//
//    /* L'alert view conseguente ad una votazione effettuata */
//    if(alertView.tag == VOTI_OK)
//    {
//
//        if([title isEqualToString:@"Ok"])
//            /* Vai alla Home */
//            [self.navigationController popToRootViewControllerAnimated:TRUE];
//
//    }
//
//}
/* ---------------------------------------------- */