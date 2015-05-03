#import <Foundation/Foundation.h>
#import "APIurls.h"
#import "Poll.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

FOUNDATION_EXPORT NSString *SERVER_UNREACHABLE;

- (NSMutableDictionary*) getDizionarioPolls;
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;
- (NSMutableArray*) getCandidatesWithPollId:(NSString*)pollId;
- (void) submitRankingWithPollId:(NSString*)pollId andUserId:(NSString*)userId andRanking:(NSString*) ranking;
- (NSString *) addPollWithPoll:(Poll*)newpoll;
- (NSMutableDictionary*) getDizionarioPollsVotati;
- (BOOL) resetPollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId;
- (BOOL) deletePollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId;

- (NSMutableDictionary*) getResultsOfPoll:(Poll*)poll;
- (NSMutableArray *) getOptimalResultsOfPoll:(Poll*)poll;

@end