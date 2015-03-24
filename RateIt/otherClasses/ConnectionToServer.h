#import <Foundation/Foundation.h>
#import "ApiUrls.h"



@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

FOUNDATION_EXPORT NSString *CONNECTED;
FOUNDATION_EXPORT NSString *SERVER_UNREACHABLE;

- (NSMutableDictionary*) getDizionarioPolls;
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;

@end