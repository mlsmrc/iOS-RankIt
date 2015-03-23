#import "Poll.h"
#import <Foundation/Foundation.h>

// CLASSE PER ORA MAI USATA
@implementation Poll


// synthesize tutti gli attributi
@synthesize pollId,pollName,pollDescription,resultsType,userID,pvtPoll,dataUpdate,mine;

-(id)initPollWithID: (int)ID
           withName: (NSString *)Name
    withDescription: (NSString *)Description
     withResultType: (int)resultType
    withPvtSettings: (BOOL)PvtSettings
{
    self = [super init];
    if(self)
    {
        [self setPollId:ID];
        [self setPollName:Name];
        [self setPollDescription:Description];
        [self setResultsType:resultsType];
        [self setPvt:PvtSettings];
        
        // lettura UDID dal file Info.plist
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *customUDID = [infoDict objectForKey:UDID_IN_INFO_PLIST];

        [self setUserID:customUDID];
    }
    return self;
}

- (void)setPollId:(int)Id
{
    pollId=Id;
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
    usrID=userID;
}
- (void) setPvt:(BOOL)pvt
{
    pvtPoll=pvt;
}

@end