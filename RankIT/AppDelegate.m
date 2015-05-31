#import "AppDelegate.h"
#import "ViewControllerDettagli.h"
#import "File.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
    
}

/* Funzione che gestisce i parametri della url scheme */
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    /* Parsing dei parametri */
    NSDictionary *dict = [self parseQueryString:[url query]];
    
    /* Passaggio di parametri */
    NSString *parameterID = [dict valueForKey:@"id"];
    [File writeParameterID:parameterID];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UINavigationController *linkvota = [sb instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = linkvota;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

/* Funzione di parse dei parametri della query della url scheme */
- (NSDictionary *) parseQueryString:(NSString *)query {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
        
    }
    
    return dict;
    
}

- (void) applicationWillResignActive:(UIApplication *)application {
    
    
    
}

- (void) applicationDidEnterBackground:(UIApplication *)application {

    
    
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    
    
}

- (void) applicationWillTerminate:(UIApplication *)application {
   
    
    
}

@end