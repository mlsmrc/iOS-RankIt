#import "Poll.h"
#import "Candidate.h"
#import <Foundation/Foundation.h>

// CLASSE PER ORA MAI USATA
@implementation Poll

const NSString *POLL_DESCRIPTION = @"{\"pollid\": \"\",\"pollname\": \"_POLL_NAME_\",\"polldescription\": \"_POLL_DESCRIPTION_\",\"pollimage\": \"_POLL_IMAGE_\",\"deadline\": \"_DEADLINE_\",\"userid\": \"_USER_ID_\",\"candidates\": [_CANDIDATES_STRING_]}";


// synthesize tutti gli attributi
@synthesize pollId,pollName,pollDescription,resultsType,userID,pvtPoll,dataUpdate,candidates,mine;

-(id)initPollWithUserID: (NSString *)ID
               withName: (NSString *)Name
        withDescription: (NSString *)Description
         withResultType: (int)rType     // è da inserire nel JSON il resultType??
         withCandidates: (NSMutableArray *)cand
{
    self = [super init];
    if(self)
    {
        [self setUserID:ID];
        [self setPollName:Name];
        pollDescription=Description;
        [self setResultsType:rType];
        [self setCandidates:cand];
        
        // lettura UDID dal file Info.plist
        //NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        //NSString *customUDID = [infoDict objectForKey:UDID_IN_INFO_PLIST];
        NSString *customUDID = @"prova";

        [self setUserID:customUDID];
    }
    return self;
}
- (void)setPollName:(NSString *)Name
{
    pollName=Name;
}
- (void)setPollDescription:(NSString *)Description
{
    pollDescription=Description;
}
- (void) setResultsType:(int)rType
{
    resultsType=rType;
}
- (void) setUserID:(NSString *)usrID
{
    userID = usrID;
}
- (void) setPvt:(BOOL)pvt
{
    pvtPoll = pvt;
}
- (void) setCandidates:(NSMutableArray *)cand
{
    candidates = cand;
}

/* crea una stringa utile per creare il JSON per l'aggiunta del poll */
- (NSString *) toJSON
{
    NSString *descr = [POLL_DESCRIPTION  stringByReplacingOccurrencesOfString:@"_POLL_NAME_" withString:[NSString stringWithFormat:@"%@",pollName]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_POLL_DESCRIPTION_" withString:[NSString stringWithFormat:@"%@",pollDescription]];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_POLL_IMAGE_" withString:@""];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_DEADLINE_" withString:@"2020-06-06 10:47:00"];
    descr = [descr  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:[NSString stringWithFormat:@"%@",userID]];
    
    NSMutableString *cands = [[NSMutableString alloc] init];
    [cands setString:@""];
    
    int i=1;
    /* crea una stringa parziale JSON di tutti i candidati */
    for(Candidate *cand in candidates)
    {
        NSString *description = [cand descriptionForAddPoll];
        [cands appendString:description];
        
        /* riga di separazione fra una candidate e l'altro */
        if(i<[candidates count])
            [cands appendString:@","];
        i++;
    }
    descr = [descr  stringByReplacingOccurrencesOfString:@"_CANDIDATES_STRING_" withString:[NSString stringWithFormat:@"%@",cands]];
    
    return descr;
}

@end