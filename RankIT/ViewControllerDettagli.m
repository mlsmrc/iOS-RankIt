#import "ViewControllerCandidates.h"
#import "ConnectionToServer.h"
#import "ViewControllerDettagli.h"
#import "ViewControllerVoto.h"
#import "Font.h"
#import "UtilTableView.h"
#import "File.h"

@interface ViewControllerDettagli ()

@end

@implementation ViewControllerDettagli

@synthesize p,c,scrollView,name,description,image,deadline,cands,tableView;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,415)];
    
    /* Download dei candidates */
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%d",[p pollId]];
    cands = [conn getCandidatesWithPollId:ID];
    
    /* Tutti i settaggi del caso */
    name.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_BOLD size:21];
    name.text = p.pollName;
    
    NSString *strDeadline = @"Scadenza: ";
    strDeadline = [strDeadline stringByAppendingString:(NSString *)p.deadline];
    deadline.font = [UIFont fontWithName:FONT_DETTAGLI_POLL_LIGHT size:14];
    deadline.textColor = [UIColor redColor];
    deadline.text = strDeadline;
    
    description.selectable = true;
    description.font = [UIFont fontWithName:FONT_DETTAGLI_POLL size:16];
    description.backgroundColor = [UIColor clearColor];
    description.textAlignment = NSTextAlignmentNatural;
    description.text = p.pollDescription;
    description.selectable = false;
    [description sizeToFit];
    
    /* Queste righe di codice servono per rendere variabile, a seconda del contenuto, la lunghezza della view e dello scroll. *
     * I valori che vedete servono per spaziare tra gli oggetti e sono stati scelti empiricamente.                            */
    CGRect frame;
    CGFloat currentY = 0;
    frame = name.frame;
    currentY += 17;
    frame.origin.y = currentY;
    name.frame = frame;
    currentY += name.frame.size.height;
    frame = deadline.frame;
    currentY += 10;
    frame.origin.y = currentY;
    deadline.frame = frame;
    currentY += deadline.frame.size.height;
    frame = image.frame;
    currentY += 28;
    frame.origin.y = currentY;
    image.frame = frame;
    currentY += image.frame.size.height;
    frame = description.frame;
    frame.origin.y = currentY;
    description.frame = frame;
    currentY += description.frame.size.height;
    frame = tableView.frame;
    currentY += 20;
    frame.origin.y = currentY;
    frame.size.height = (([cands count]*CELL_HEIGHT)+175);
    tableView.frame = frame;
    currentY += tableView.frame.size.height;
    [scrollView setContentSize:CGSizeMake(320,currentY-40)];
    
}

/* Funzioni che permettono di visualizzare i nomi dei candidates nelle celle della schermata dettagli */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cands count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CandCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    c = [cands objectAtIndex:indexPath.row];
    NSString* strCandidate = [c.candChar stringByAppendingString:@") "];
    cell.textLabel.text = [strCandidate stringByAppendingString:(NSString *)c.candName];
    cell.detailTextLabel.text = c.candDescription;
    cell.imageView.image = [UtilTableView imageWithImage:[UIImage imageNamed:@"Poll-image"] scaledToSize:CGSizeMake(CELL_HEIGHT-20, CELL_HEIGHT-20)];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
    
}

/* Metodo che fa apparire momentaneamente la scroll bar per far capire all'utente che il contenuto è scrollabile */
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
    
}

/* Metodo che gestisce il ri-carimento dell view */
- (void) viewWillAppear:(BOOL)animated {
    
    /* Deseleziona l'ultima cella cliccata ogni volta che riappare la view */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
}

/* Titolo della table view dei candidates */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"CANDIDATI PER LA CLASSIFICA:";
    
}

/* Permette di modificare l'altezza delle righe della schermata "Home" */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/* Funzioni che permettono di accedere alla descrizione di un determinato candidato */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIBarButtonItem *backButton;
    
    if ([segue.identifier isEqualToString:@"showCandDetails"]) {
        
        NSIndexPath *indexPath = nil;
        c = nil;
        
        indexPath = [self.tableView indexPathForSelectedRow];
        c = [cands objectAtIndex:indexPath.row];
        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        ViewControllerCandidates *destViewController = segue.destinationViewController;
        destViewController.c = c;
        
    }
    
    else if ([segue.identifier isEqualToString:@"showVoteView"]) {
        
        backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(BACK,returnbuttontitle) style: UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        /* init delle strutture utili per il segue */
        ViewControllerVoto *destViewController = segue.destinationViewController;
        destViewController.poll = p;
        destViewController.candidateChars = [[NSMutableArray alloc]init];
        destViewController.candidateNames = [[NSMutableArray alloc]init];
        
        /* lettura di un ipotetico voto già dato al poll */
        NSString *voti = [File getRankingOfPoll:p.pollId];
        
        /* lettura di un ipotetica classifica salvata */
        NSString *savedRank = [File getSaveRankOfPoll:[NSString stringWithFormat:@"%d",p.pollId]];
        
        /* poll già votato in precedenza e niente salvato */
        if(voti!=NULL && savedRank == NULL)
        {
            /* Divido la classifica per i parimeriti */
            NSArray *arrayVoti = [voti componentsSeparatedByString:@","];
            
            /* riassegnamento array in base al voto già dato al poll */
            for(int i=0;i<[arrayVoti count];i++)
            {
                if([arrayVoti[i] containsString:@"a"])
                {
                    c=[cands objectAtIndex:0];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"b"])
                {
                    c=[cands objectAtIndex:1];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"c"])
                {
                    c=[cands objectAtIndex:2];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"d"])
                {
                    c=[cands objectAtIndex:3];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"e"])
                {
                    c=[cands objectAtIndex:4];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
            }
        }
        /* se ho una classifica salvata */
        else if((voti==NULL && savedRank!=NULL) || (voti!=NULL && savedRank!=NULL))
        {
            /* Divido la classifica per i parimeriti */
            NSArray *arrayVoti = [savedRank componentsSeparatedByString:@","];
            
            /* riassegnamento array in base al voto già dato al poll */
            for(int i=0;i<[arrayVoti count];i++)
            {
                if([arrayVoti[i] containsString:@"a"])
                {
                    c=[cands objectAtIndex:0];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"b"])
                {
                    c=[cands objectAtIndex:1];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"c"])
                {
                    c=[cands objectAtIndex:2];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"d"])
                {
                    c=[cands objectAtIndex:3];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
                if([arrayVoti[i] containsString:@"e"])
                {
                    c=[cands objectAtIndex:4];
                    [destViewController.candidateChars addObject:c.candChar];
                    [destViewController.candidateNames addObject:c.candName];
                }
            }
        }
        /* poll mai votato prima */
        else
        {
            /* inizializzo normalmente l'array dei candidates */
            for(int i=0;i<[cands count];i++)
            {
                c = [cands objectAtIndex:i];
                [destViewController.candidateChars addObject:c.candChar];
                [destViewController.candidateNames addObject:c.candName];
            }
        }
    }
    
}

@end