#ifndef Poll_h

#import <Foundation/Foundation.h>
#define Poll_h

const NSString *POLL_DESCRIPTION;
/* const NSString *UDID_IN_INFO_PLIST = @"CustomUDID"; */

@interface Poll : NSObject
{
    int pollId;
    NSString *pollName;
    NSString *pollDescription;
    int resultsType;
    NSString *userID;
    BOOL pvtPoll;
    NSDate *dataUpdate;
    NSString *mine;
    NSMutableArray *candidates;
}

@property(readonly)int pollId;
@property(readonly)NSString *pollName;
@property(readonly)NSString *pollDescription;
@property(readonly)int resultsType;
@property(readonly)NSString *userID;
@property(readonly)BOOL pvtPoll;
@property(readwrite)NSDate *dataUpdate;
@property(nonatomic,readwrite)NSMutableArray *candidates;
@property(readwrite)NSString *mine;

- (void) setPollName:(NSString *)Name;
- (void) setPollDescription:(NSString *)Description;
- (void) setResultsType:(int)rType;
- (void) setUserID:(NSString *)usrID;
- (void) setCandidates:(NSMutableArray *)cand;
- (void) setPvt:(BOOL)pvt;
- (NSString *) toJSON;

-(id)initPollWithUserID: (NSString *)ID
               withName: (NSString *)Name
        withDescription: (NSString *)Description
         withResultType: (int)resultType
         withCandidates: (NSMutableArray *) cand;

@end

#endif