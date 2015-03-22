//
//  ConnectionToServer.m
//  RateIt
//
//  Created by lorenzo on 22/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#import "ConnectionToServer.h"

@implementation ConnectionToServer

-(void) scaricaPolls

{

    NSString *url=URLGETPOLLS;
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dizionario;

    if(response!=nil)
    {
        dizionario= [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }

    response=nil;
    
    
    
    for(NSString *pollid in dizionario)
    {

        NSArray *results = [dizionario valueForKey:pollid];

        NSLog([results valueForKey:@"pollname"]);
        
    }
    
}

@end
