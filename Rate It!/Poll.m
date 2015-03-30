#import "Poll.h"
#import "Candidate.h"
#import <Foundation/Foundation.h>

@implementation Poll

NSString *POLL_JSON = @"{\"pollid\":\"\",\"pollname\":\"_POLL_NAME_\",\"polldescription\":\"_POLL_DESCRIPTION_\",\"pollimage\":\"\",\"deadline\":\"_DEADLINE_\",\"userid\":\"_USER_ID_\",\"Unlisted\":_PVT_FLAG_,\"candidates\":[_CANDIDATES_STRING_]}";

@synthesize pollId, pollName, pollDescription, resultsType, deadline, userID, pvtPoll, lastUpdate, votes, mine, candidates;

/* Costruttore per l'aggiunta di un nuovo Poll */
- (id)initPollWithUserID: (NSString *) ID
                withName: (NSString *) Name
         withDescription: (NSString *) Description
            withDeadline: (NSDate *) Deadline
             withPrivate: (BOOL) Private
          withCandidates: (NSMutableArray *) cand; {
    
    self = [super init];
    
    if(self)
    {
        
        /* lettura UDID dal file Info.plist */
        /* NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary]; */
        /* NSString *UDID = [infoDict objectForKey:UDID_IN_INFO_PLIST]; */
        
        ID = @"prova";
        userID = ID;
        pollName = Name;
        pollDescription = Description;
        deadline = Deadline;
        pvtPoll = Private;
        candidates = cand;
        
        /* inserimento data al momento della creazione dell'oggetto */
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        lastUpdate = [DateFormatter gregorianStartDate];
        
    }
    
    return self;
}

/* Costruttore per creare un oggetto Poll da visualizzare in Home */
- (id)initPollWithPollID: (int) PollID
                withName: (NSString *) Name
         withDescription: (NSString *) Description
         withResultsType: (int) rType
            withDeadline: (NSDate *) Deadline
                withVote: (int) Votes
          withCandidates: (NSMutableArray *) cand;
{
    self = [super init];
    
    if(self)
    {
        pollId = PollID;
        pollName = Name;
        pollDescription = Description;
        resultsType = rType;
        deadline = Deadline;
        votes = Votes;
        candidates = cand;
    }
    
    return self;
    
}

/* Crea una stringa utile per creare il JSON per l'aggiunta del poll */
- (NSString *) toJSON
{
    NSString *descr = [POLL_JSON  stringByReplacingOccurrencesOfString:@"_POLL_NAME_" withString:[NSString stringWithFormat:@"%@",pollName]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_POLL_DESCRIPTION_" withString:[NSString stringWithFormat:@"%@",pollDescription]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_DEADLINE_" withString:[NSString stringWithFormat:@"%@",deadline]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:[NSString stringWithFormat:@"%@",userID]];
    
    if(pvtPoll == true)
        descr = [descr  stringByReplacingOccurrencesOfString:@"_PVT_FLAG_" withString:[NSString stringWithFormat:@"1"]];
    
    else descr = [descr  stringByReplacingOccurrencesOfString:@"_PVT_FLAG_" withString:[NSString stringWithFormat:@"0"]];
        
    
    NSMutableString *cands = [[NSMutableString alloc]init];
    [cands setString:@""];
    
    int i=1;
    
    /* Crea una stringa parziale JSON di tutti i candidati */
    for(Candidate *cand in candidates)
    {
        NSString *description = [cand descriptionForAddPoll];
        [cands appendString:description];
        
        /* Riga di separazione fra una candidate e l'altro */
        if(i<[candidates count])
            [cands appendString:@","];
        
        i++;
    }
    
    descr = [descr  stringByReplacingOccurrencesOfString:@"_CANDIDATES_STRING_" withString:[NSString stringWithFormat:@"%@",cands]];
    descr = [ descr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return descr;
}

- (void) setLastUpdate
{
    /* inserimento data al momento della creazione dell'oggetto */
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    lastUpdate = [DateFormatter gregorianStartDate];
}

@end