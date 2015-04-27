#import <Foundation/Foundation.h>
#import "APIurls.h"
#import "Poll.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

FOUNDATION_EXPORT NSString *SERVER_UNREACHABLE;
FOUNDATION_EXPORT NSString *EMPTY_POLLS_LIST;
FOUNDATION_EXPORT NSString *EMPTY_VOTED_POLLS_LIST;

- (NSMutableDictionary*) getDizionarioPolls;
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;
- (NSMutableArray*) getCandidatesWithPollId:(NSString*)pollId;
- (void) submitRankingWithPollId:(NSString*)pollId andUserId:(NSString*)userId andRanking:(NSString*) ranking;
- (NSString *) addPollWithPoll:(Poll*)newpoll;
- (int) getVotiPollWithPollId:(NSString*)pollId;
- (NSMutableDictionary*) getDizionarioPollsVotati;
- (void) resetPollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId;
- (void) deletePollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId;


@end