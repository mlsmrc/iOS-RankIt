#import "ViewControllerCredits.h"

#define PROF 100
#define USER_RESEARCH 101
#define DEVELOPER 102

@interface ViewControllerCredits ()

@end

@implementation ViewControllerCredits
{
    NSMutableArray *professore;
    
    NSMutableArray *usRes;
    
    NSMutableArray *sviluppatori;
    
    NSMutableDictionary *email;
}

@synthesize prof,userResearch,developer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* Aggiunta valori negli array */
    [professore addObject:@"Prof. Emanuele Panizzi"];
    [usRes addObject:@"Vincenzo de Pinto"];
    [usRes addObject:@"Valentina Pizzo"];
    [sviluppatori addObject:@"Marco Finocchi"];
    [sviluppatori addObject:@"Marco Mulas"];
    [sviluppatori addObject:@"Giulio Salierno"];
    [sviluppatori addObject:@"Lorenzo Spataro"];
    
    [email setValue:@"panizzi@di.uniroma1.it" forKey:@"Prof. Emanuele Panizzi"];
    [email setValue:@"panizzi@di.uniroma1.it" forKey:@"Vincenzo de Pinto"];
    [email setValue:@"panizzi@di.uniroma1.it" forKey:@"Valentina Pizzo"];
    [email setValue:@"mrcfinocchi@gmail.com" forKey:@"Marco Finocchi"];
    [email setValue:@"mlsmrc@gmail.com" forKey:@"Marco Mulas"];
    [email setValue:@"panizzi@di.uniroma1.it" forKey:@"Giulio Salierno"];
    [email setValue:@"panizzi@di.uniroma1.it" forKey:@"Lorenzo Spataro"];
    
}
/* Funzioni che permettono di visualizzare i nomi dei candidates nelle celle della schermata dettagli */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (tableView.tag) {
        case PROF:
            NSLog(@"prof!");
            return 1;
            break;
            
        case USER_RESEARCH:
            NSLog(@"usrR!");
            return 2;
            break;
            
        case DEVELOPER:
            NSLog(@"dev!");
            return 4;
            break;
            
        default:
            break;
    }
    
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell");
    UITableViewCell *cell;
    
    switch (tableView.tag) {
        case PROF:
            cell = [self.prof dequeueReusableCellWithIdentifier:@"ProfCell"];
            cell.text = [professore objectAtIndex:indexPath.row];
            break;
            
        case USER_RESEARCH:
            cell = [self.userResearch dequeueReusableCellWithIdentifier:@"UserResearchCell"];
            cell.text = [usRes objectAtIndex:indexPath.row];
            break;
            
        case DEVELOPER:
            cell = [self.developer dequeueReusableCellWithIdentifier:@"DeveloperCell"];
            cell.text = [sviluppatori objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    //cell.font = [UIFont fontWithName:FONT_CANDIDATES_DESCRIPTION size:12];

    return cell;
    
}
/* Titolo della table view dei candidates */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"Title");
    switch (tableView.tag) {
        case PROF:
            return @"SUPERVISORE";
            break;
        
        case USER_RESEARCH:
            return @"USER RESEARCH";
            break;
            
        case DEVELOPER:
            return @"SVILUPPATORI";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*if(self.tableView == self.searchDisplayController.searchResultsTableView) {
        
        [self performSegueWithIdentifier:@"showPollDetails" sender:self];
        
    }*/
    NSLog(@"CLick");
    
}

/* Funzioni utili ad una corretta visualizzazione della table view e della search bar */
- (void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

@end
