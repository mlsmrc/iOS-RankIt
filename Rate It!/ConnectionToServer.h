#import <Foundation/Foundation.h>
#import "APIurls.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

FOUNDATION_EXPORT NSString *SERVER_UNREACHABLE;
FOUNDATION_EXPORT NSString *EMPTY_POLLS_LIST;

- (NSMutableDictionary*)getDizionarioPolls;
- (void)scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;

@end