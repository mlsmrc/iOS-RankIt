#import "AppDelegate.h"
#import "ViewControllerDettagli.h"
#import "ConnectionToServer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

/* Funzione che gestisce i parametri della url scheme */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /* Gestione dell'input */
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    
    /* Parsing dei parametri */
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    
    /* Caricamento poll */
    ConnectionToServer *conn = [ConnectionToServer new];
    [conn scaricaPollsWithPollId:[dict valueForKey:@"id"] andUserId:@"" andStart:@""];
    NSMutableDictionary *d = [conn getDizionarioPolls];
    NSString *value = [d objectForKey:[dict valueForKey:@"id"]];
    Poll *p = [[Poll alloc]initPollWithPollID:[[value valueForKey:@"pollid"] intValue]
                                     withName:[value valueForKey:@"pollname"]
                              withDescription:[value valueForKey:@"polldescription"]
                              withResultsType:([[value valueForKey:@"results"] isEqual:@"full"]? 1:0 )
                                 withDeadline:[value valueForKey:@"deadline"]
                                  withPrivate:([[value valueForKey:@"unlisted"] isEqual:@"1"]? true:false)
                               withLastUpdate:[value valueForKey:@"updated"]
                                     withMine:[[value valueForKey:@"mine"] intValue]
                               withCandidates:nil
                                    withVotes:(int)[[value valueForKey:@"votes"] integerValue]];
    NSLog(@"%d",p.pollId);

    
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    ViewControllerDettagli * vc = [ViewControllerDettagli new];
    vc.p = p;
    [navigationController presentViewController: vc animated:YES completion:nil];
    
    return YES;
}

/* Funzione di parse dei parametri della query della url scheme */
- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    


}

/* Funzione che apre */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"QUIQUI");
    
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
    
    
}

@end