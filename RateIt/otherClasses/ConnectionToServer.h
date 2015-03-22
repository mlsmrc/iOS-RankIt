//
//  ConnectionToServer.h
//  RateIt
//
//  Created by lorenzo on 22/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiUrls.h"

@interface ConnectionToServer : NSObject <NSURLConnectionDelegate>

- (NSMutableDictionary*) getDizionarioPolls;
-(void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*) start;

@end
