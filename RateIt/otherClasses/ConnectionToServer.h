#import <Foundation/Foundation.h>
#import "ApiUrls.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

- (NSMutableDictionary*) getDizionarioPolls;
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;

@end