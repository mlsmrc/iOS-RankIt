#ifndef Poll_h

#import <Foundation/Foundation.h>
#define Poll_h

FOUNDATION_EXPORT NSString *POLL_JSON;
/* const NSString *UDID_IN_INFO_PLIST = @"CustomUDID"; */

@interface Poll : NSObject {
    
    int pollId;
    NSString *pollName;
    NSString *pollDescription;
    
    /* "0" per Short ed "1" per Full */
    int resultsType;
    
    NSDate *deadline;
    NSString *userID;
    BOOL pvtPoll;
    NSDate *lastUpdate;
    int *mine;
    int votes;
    NSMutableArray *candidates;
    
    /* Utile per la formattazione della NSDate                          *
     * Per trasformare una NSDate in stringa usarlo in questa maniera:  *
     * [dateFormatter stringFromDate:date]                              */
    NSDateFormatter *dateFormatter;
}

@property (readonly,nonatomic) int pollId;
@property (readwrite,nonatomic) NSString *pollName;
@property (readwrite,nonatomic) NSString *pollDescription;
@property (readonly,nonatomic) int resultsType;
@property (readwrite,nonatomic) NSDate *deadline;
@property (readonly,nonatomic) NSString *userID;
@property (readwrite,nonatomic) BOOL pvtPoll;
@property (readonly,nonatomic) NSDate *lastUpdate;
@property (readwrite,nonatomic) int votes;
@property (readonly,nonatomic) int *mine;
@property (readwrite,nonatomic) NSMutableArray *candidates;

/* Costruttore per l'aggiunta di un nuovo Poll */
-(id)initPollWithUserID: (NSString *) ID
               withName: (NSString *) Name
        withDescription: (NSString *) Description
           withDeadline: (NSDate *) Deadline
            withPrivate: (BOOL) Private
         withCandidates: (NSMutableArray *) cand;

/* Costruttore per creare un oggetto Poll da visualizzare in Home */
- (id)initPollWithPollID: (int) PollID
                withName: (NSString *) Name
         withDescription: (NSString *) Description
         withResultsType: (int) rType
            withDeadline: (NSDate *) Deadline
          withLastUpdate: (NSDate *) LastUpdate
          withCandidates: (NSMutableArray *) cand
               withVotes:(int)Votes;

- (NSString *) toJSON;
- (void) setLastUpdate;
+ (NSDateFormatter*) getDateFormatter;
+ (int) compareDate:(NSDate *)first WithDate:(NSDate *)second;

@end

#endif