#import <Foundation/Foundation.h>
#import "UtilTableView.h"

@implementation UtilTableView: NSObject

/* Stringa per la search bar */
NSString *NO_RESULTS = @"Nessun risultato trovato";

/* Stringhe per il pulsante di ritorno schermata */
NSString *SEARCH = @"Cerca";
NSString *BACK = @"";
NSString *BACK_TO_HOME = @"Home";
NSString *BACK_TO_VOTED = @"Votati";

/* Spaziatura voti per diversi IPhone */
NSString *IPHONE_4_4S_5_5S = @"              ";
NSString *IPHONE_6 = @"                             ";
NSString *IPHONE_6Plus = @"                                         ";
NSString *SPACE_FOR_VOTES = @"";

/* Larghezza degli schermi di IPhone6 e IPhone6+ */
float IPHONE_6_WIDTH = 375;
float IPHONE_6Plus_WIDTH = 414;

@end