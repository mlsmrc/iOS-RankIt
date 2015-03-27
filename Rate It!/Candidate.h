//
//  Candidate.h
//  FunzioniServer
//
//  Created by lorenzo on 26/03/15.
//  Copyright (c) 2015 lorenzo. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Candidate : NSObject
@property NSString *candChar;
@property NSString *candName;
@property NSString *candDescription;



- (void) setCandicateWithChar:(NSString *)candChar andName:(NSString*) candName andDescription:(NSString*)description ;
-(NSString *) descriptionForAddPoll;




@end
