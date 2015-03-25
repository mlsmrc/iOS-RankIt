#import <Foundation/Foundation.h>
#import "ApiUrls.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

FOUNDATION_EXPORT NSString *SERVER_UNREACHABLE;
FOUNDATION_EXPORT NSString *EMPTYPOLLSLIST;

- (NSMutableDictionary*) getDizionarioPolls;
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;

@end