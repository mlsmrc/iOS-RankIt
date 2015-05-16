//
//  Votazione.h
//  RankIT
//
//  Created by Marco Mulas on 05/05/15.
//  Copyright (c) 2015 Marco Mulas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Votazione : NSObject

@property(readwrite) float mu;
@property(readwrite) float sigma;
@property(readwrite) NSString * pattern;
@property(readwrite) float votedby;

- (id) initWithPattern:(NSString*)pattern
                 AndMu:(float)mu
              AndSigma:(float)sigma
            AndVotedBy:(float)votedBy;
@end
