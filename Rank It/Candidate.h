#import <Foundation/Foundation.h>

@interface Candidate : NSObject

FOUNDATION_EXPORT NSString *CANDIDATE_JSON;

@property NSString *candChar;
@property NSString *candName;
@property NSString *candDescription;

- (id) initCandicateWithChar:(NSString *)Char andName:(NSString *)Name andDescription:(NSString *)description;
- (NSString*) descriptionForAddPoll;
- (NSString*) description;

@end