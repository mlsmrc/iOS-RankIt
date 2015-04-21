#import <Foundation/Foundation.h>

@interface PList : NSObject

+ (BOOL)addOnPListRanking: (NSString*)ranking OfPoll:(NSString*)pollid;
+ (NSString*) getRankingOfPoll: (NSString*)pollid;

@end