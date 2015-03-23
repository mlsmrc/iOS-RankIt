#import "ConnectionToServer.h"

@implementation ConnectionToServer

NSMutableDictionary *dizionarioPolls;

/*  La funzione inizialmente sostituisce alle sottostringhe del tipo _PARAMETRO_    *
 *  all'interno della stringa url i paramentri della funzione e crea una richiesta  *
 *  asincrona verso l'API, il cui risultato verrà inserito all'interno di un        *
 *  dizionario                                                                      *
 *  Se non si vuole inserire un parametro si inserisce una stringa vuota ""         *
 *  (il php delle API lo avvertirà come se il parametro non fosse stato inserito)   */
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*)start
{
    // Sostituzione dei parametri
    NSString *url=[URL_GET_POLLS  stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat:@"%@",pollId]];
    url=[url  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:userId];
    url=[url stringByReplacingOccurrencesOfString:@"_START_" withString:[NSString stringWithFormat:@"%@",start]];
    
    // Stampa di prova
    NSLog(@"URL RICHIESTA: %@",url);
    
    // Creazione della richiesta ed invio
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict;
    
    dizionarioPolls = [[NSMutableDictionary alloc]init];

    if(response!=nil)
    {
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        // DA CONTROLLARE SE LA GRANDEZZA DEL DIZIONARIO è 0
    }

    response = nil;
    
    // ERRORE da fixare! Capita quando si popola il parametro pollId
    for(id key in dict)
    {
        NSLog(@"%@",key);
        [dizionarioPolls setObject:key forKey:[key valueForKey:@"pollid"]];
    }
    
}

/* Ritorna il dizionario contenente i poll nel formato <id,poll>    */
- (NSMutableDictionary*) getDizionarioPolls
{
    return dizionarioPolls;
}

@end