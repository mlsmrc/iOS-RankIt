#import <Foundation/Foundation.h>

@interface Votazione : NSObject

@property(readwrite) float mu;
@property(readwrite) float sigma;
@property(readwrite) NSString *pattern;
@property(readwrite) float votedby;

- (id) initWithPattern:(NSString*)pattern
                 AndMu:(float)mu
              AndSigma:(float)sigma
            AndVotedBy:(float)votedBy;

@end