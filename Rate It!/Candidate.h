#import <Foundation/Foundation.h>

@interface Candidate : NSObject
@property NSString *candChar;
@property NSString *candName;
@property NSString *candDescription;

- (void) setCandicateWithChar:(NSString *)candChar andName:(NSString*) candName andDescription:(NSString*)description ;
- (NSString *) descriptionForAddPoll;
- (NSString*)description;

@end