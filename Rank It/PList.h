#import <Foundation/Foundation.h>

@interface PList : NSObject

FOUNDATION_EXPORT NSString *VOTES_PLIST;
FOUNDATION_EXPORT NSString *INFO_PLIST;
FOUNDATION_EXPORT NSString *CUSTOM_UDID;

/* Funzioni di scrittura */
+ (BOOL) writeOnPListRanking: (NSString*)ranking OfPoll:(NSString*)pollid;
+ (BOOL) writeUDID;

/* Funzioni di lettura */
+ (NSString*) getRankingOfPoll: (NSString*)pollid;
+ (NSString*) getUDID;
+ (NSArray *) getAllKeysinPList:(NSString *)PList;

@end