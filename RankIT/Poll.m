#import <Foundation/Foundation.h>
#import "Poll.h"
#import "Candidate.h"
#import "ConnectionToServer.h"
#import "File.h"
#import "Util.h"

@implementation Poll

NSString *POLL_JSON = @"{\"pollid\":\"_POLL_ID_\",\"pollname\":\"_POLL_NAME_\",\"polldescription\":\"_POLL_DESCRIPTION_\",\"pollimage\":\"\",\"deadline\":\"_DEADLINE_\",\"userid\":\"_USER_ID_\",\"unlisted\":\"_PVT_FLAG_\",\"candidates\":[_CANDIDATES_STRING_]}";

@synthesize pollId,pollName,pollDescription,resultsType,deadline,userID,pvtPoll,lastUpdate,votes,mine,candidates;

/* Costruttore per l'aggiunta di un nuovo Poll */
- (id)initPollWithUserID: (NSString *) ID
                withName: (NSString *) Name
         withDescription: (NSString *) Description
            withDeadline: (NSDate *) Deadline
             withPrivate: (BOOL) Private
          withCandidates: (NSMutableArray *) cand;
{
    
    self = [super init];
    
    if(self) {
        
        pollId = 0;
        userID = ID;
        pollName = Name;
        pollDescription = Description;
        deadline = Deadline;
        pvtPoll = Private;
        candidates = cand;
        
        /* Inserimento data al momento della creazione dell'oggetto */
        lastUpdate = [[NSDate alloc ]init];
        
        /* Inizializzazione formattatore date */
        dateFormatter = [Util getDateFormatter];
  
    }
    
    return self;
}

/* Costruttore per creare un oggetto Poll da visualizzare in Home */
- (id)initPollWithPollID: (int) PollID
                withName: (NSString *) Name
         withDescription: (NSString *) Description
         withResultsType: (int) rType
            withDeadline: (NSDate *) Deadline
             withPrivate: (BOOL) Private
          withLastUpdate: (NSDate *) LastUpdate
                withMine: (int) Mine
          withCandidates: (NSMutableArray *) cand
               withVotes:(int)Votes
{
    self = [super init];
    
    if(self) {
        
        pollId = PollID;
        pollName = Name;
        pollDescription = Description;
        resultsType = rType;
        deadline = Deadline;
        lastUpdate = LastUpdate;
        mine = Mine;
        candidates = cand;
        pvtPoll = Private;
        votes = Votes;

        /* Inizializzazione formattatore date */
        dateFormatter = [Util getDateFormatter];
        
    }
    
    return self;
    
}

/* Crea una stringa utile per creare il JSON per l'aggiunta del poll */
- (NSString *) toJSON {
    
    NSString *descr = [POLL_JSON  stringByReplacingOccurrencesOfString:@"_POLL_NAME_" withString:[NSString stringWithFormat:@"%@",pollName]];
    
    descr = [descr  stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat:@"%d",pollId]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_POLL_DESCRIPTION_" withString:[NSString stringWithFormat:@"%@",pollDescription]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_DEADLINE_" withString:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:deadline]]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:[NSString stringWithFormat:@"%@",userID]];
    
    if(pvtPoll == true)
        descr = [descr  stringByReplacingOccurrencesOfString:@"_PVT_FLAG_" withString:[NSString stringWithFormat:@"1"]];
    
    else descr = [descr  stringByReplacingOccurrencesOfString:@"_PVT_FLAG_" withString:[NSString stringWithFormat:@"0"]];
        
    
    NSMutableString *cands = [[NSMutableString alloc]init];
    [cands setString:@""];
    
    int i=1;
    
    /* Crea una stringa parziale JSON di tutti i candidati */
    for(Candidate *cand in candidates) {
        
        NSString *description = [cand descriptionForAddPoll];
        [cands appendString:description];
        
        /* Riga di separazione fra una candidate e l'altro */
        if(i<[candidates count])
            [cands appendString:@","];
        
        i++;
        
    }
    
    descr = [descr  stringByReplacingOccurrencesOfString:@"_CANDIDATES_STRING_" withString:[NSString stringWithFormat:@"%@",cands]];
    return descr;
}

- (void) setLastUpdate {
    
    /* Aggiornamento data */
   lastUpdate = [[NSDate alloc]init];

}

@end