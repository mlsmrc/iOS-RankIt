//
//  ConnectionToServer.m
//  RateIt
//
//  Created by lorenzo on 22/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#import "ConnectionToServer.h"

@implementation ConnectionToServer

NSMutableDictionary *dizionarioPolls;



-(void) scaricaPollsWithPollId:(int)pollId andUserId:(NSString*) userId andStart:(int) start

{

    NSString * url=[URL_GET_POLLS  stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat:@"%d",pollId]];
    
 url=[url  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:userId];
   
    
    url=[url stringByReplacingOccurrencesOfString:@"_START_" withString:[NSString stringWithFormat:@"%d",start]];
    
    NSLog(@"URL RICHIESTA: %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict;
    
    dizionarioPolls= [[NSMutableDictionary alloc]init];

    if(response!=nil)
    {
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }

    response=nil;
    
    for(id key in dict)
    [dizionarioPolls setObject:key forKey:[key valueForKey:@"pollid"]];
     
        
    

    
    
   
   

}


- (NSMutableDictionary*) getDizionarioPolls{
    return dizionarioPolls;
}


@end
