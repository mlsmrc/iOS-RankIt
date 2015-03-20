//
//  Poll.h
//  RateIt
//
//  Created by Marco Mulas on 20/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#ifndef Poll_h

#import <Foundation/Foundation.h>
#define Poll_h

const NSString *UDID_IN_INFO_PLIST = @"CustomUDID";

@interface Poll : NSObject
{
    
    int pollId;
    NSString *pollName;
    NSString *pollDescription;
    int resultsType; // 0 Short - 1 Full
    NSString *userID;
    BOOL pvtPoll;
    NSDate *dataUpdate;
    NSString *mine;
}

@property(readonly)int pollId;
@property(readonly)NSString *pollName;
@property(readonly)NSString *pollDescription;
@property(readonly)int resultsType;
@property(readonly)NSString *userID;
@property(readonly)BOOL pvtPoll;
@property(readwrite)NSDate *dataUpdate;
@property(readwrite)NSString *mine;

- (void) setPollId:(int)Id;
- (void) setPollName:(NSString *)Name;
- (void) setPollDescription:(NSString *)Description;
- (void) setResultsType:(int)rType;
- (void) setUserID:(NSString *)usrID;
- (void) setPvt:(BOOL)pvt;
@end



#endif
