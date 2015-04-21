#import <Foundation/Foundation.h>
#import "PList.h"

@implementation PList: NSObject

/* Dato il pollid e la classifica va a scrivere all'interno del file Votes.plist la votazione effettuata */
+(BOOL)addOnPListRanking: (NSString*)ranking OfPoll:(NSString*)pollid
{
    /* Catturo il path del file Votes.plist dove si manterranno le votazioni effettuate */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Votes" ofType:@"plist"];
    
    NSLog(@"%@",path);
    
    /* Cattura del file Votes.plist in un dizionario */
    NSMutableDictionary *votesPList = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    /* Aggiunta riga e scrittura su file */
    [votesPList setObject:ranking forKey:pollid];
    
    return [votesPList writeToFile:path atomically:YES];
    
}

/* Dato il pollid va a leggere all'interno del file Votes.plist la votazione effettuata */
+ (NSString*) getRankingOfPoll:(NSString*)pollid
{
    /* Catturo il path del file Votes.plist dove si manterranno le votazioni effettuate */
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"Votes" ofType:@"plist"] mutableCopy];
    
    /* Cattura del file Votes.plist in un dizionario */
    NSMutableDictionary *votesPList = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    return [votesPList objectForKey:pollid];
}

@end