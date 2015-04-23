#import <Foundation/Foundation.h>
#import "PList.h"

NSString *VOTES_PLIST = @"Votes";
NSString *INFO_PLIST = @"Info";
NSString *CUSTOM_UDID = @"CustomUDID";

@implementation PList: NSObject

/* Dato il pollid e la classifica va a scrivere all'interno del file Votes.plist la votazione effettuata */
+ (BOOL) writeOnPListRanking: (NSString*)ranking OfPoll:(NSString*)pollid
{
    return [PList writeString:ranking forKey:pollid inPList:VOTES_PLIST];
}

/* Dato il pollid va a leggere all'interno del file Votes.plist la votazione effettuata */
+ (NSString*) getRankingOfPoll:(NSString*)pollid
{
    return [PList readStringforKey:pollid inPList:VOTES_PLIST];
}

/* Lettura da info.plist dell'uuid salvato in precedenza. Se inesistente torna NULL */
+ (NSString*) getUDID
{
    return [PList readStringforKey:CUSTOM_UDID inPList:INFO_PLIST];
}

/* Scrittura su info.plist dell'uuid generato */
+ (BOOL) writeUDID
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [PList writeString:uuid forKey:CUSTOM_UDID inPList:INFO_PLIST];
}

/* Funzione generica privata che scrive una coppia <chiave,info> su una plist */
+ (BOOL) writeString:(NSString*)Info forKey:(NSString*)key inPList:(NSString *)PList
{
    /* Catturo il path del file Votes.plist dove si manterranno le votazioni effettuate */
    NSString *path = [[NSBundle mainBundle] pathForResource:PList ofType:@"plist"];
    
    NSMutableDictionary *votesPList = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    /* Aggiunta riga e scrittura su file */
    [votesPList setObject:Info forKey:key];
    
    return [votesPList writeToFile:path atomically:YES];
}

/* Funzione generica privata che legge una stringa da una plist data una chiave */
+ (NSString *) readStringforKey:(NSString*)key inPList:(NSString *)PList
{
    /* Catturo il path del file Votes.plist dove si manterranno le votazioni effettuate */
    NSString *path = [[[NSBundle mainBundle] pathForResource:PList ofType:@"plist"] mutableCopy];
    
    /* Cattura del file Votes.plist in un dizionario */
    NSMutableDictionary *votesPList = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    return [votesPList objectForKey:key];
}

/* Funzione che ritorna tutte le chiavi da una plist */
+ (NSArray *) getAllKeysinPList:(NSString *)PList
{
    /* Catturo il path del file Votes.plist dove si manterranno le votazioni effettuate */
    NSString *path = [[[NSBundle mainBundle] pathForResource:PList ofType:@"plist"] mutableCopy];
    
    /* Cattura del file Votes.plist in un dizionario */
    NSMutableDictionary *votesPList = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    return [votesPList allKeys];
}

@end