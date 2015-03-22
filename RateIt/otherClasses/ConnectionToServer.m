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

    NSString *url=URL_GET_POLLS;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dizionario;

    if(response!=nil)
    {
        dizionario = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }

    response=nil;
    
    for(NSDictionary *pollid in dizionario)
    {
        NSLog(@"%@",[pollid valueForKey:@"pollid"]);
        NSLog(@"%@",[pollid valueForKey:@"pollname"]);
    }
}

@end
