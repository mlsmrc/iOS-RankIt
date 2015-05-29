#import <Foundation/Foundation.h>

@interface File : NSObject

FOUNDATION_EXPORT NSString *VOTES_PLIST;
FOUNDATION_EXPORT NSString *INFO_PLIST;
FOUNDATION_EXPORT NSString *CUSTOM_UDID;
FOUNDATION_EXPORT NSString *SAVE_RANK;
FOUNDATION_EXPORT NSString *RELOAD;

/* Funzioni di scrittura */
+ (BOOL) writeOnPListRanking:(NSString *)ranking OfPoll:(NSString *)pollid;
+ (BOOL) writeUDID;
+ (BOOL) clearSaveRank;
+ (BOOL) SaveRank:(NSString *)rank OfPoll:(NSString *)pollId;
+ (BOOL) clearFile:(NSString *)File;
+ (void) writeOnReload:(NSString *)value ofFlags:(NSMutableArray *)FLAGS;

/* Funzioni di lettura */
+ (NSString *) getRankingOfPoll:(int)pollid;
+ (NSString *) getUDID;
+ (NSArray *) getAllKeysinPList:(NSString *)PList;
+ (NSString *) getSaveRankOfPoll:(NSString *)pollid;
+ (NSString *) readFromReload:(NSString *)key;

@end