#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Reachability.h"

NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 0

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment) {
    
 #if kShouldPrintReachabilityFlags

 NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
       (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
       (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
       (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
       (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
       (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
       (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
       (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
       (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
       (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
       comment
       );

 #endif
    
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    #pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(__bridge NSObject*) info isKindOfClass: [Reachability class]], @"info was wrong class in ReachabilityCallback");

    Reachability* noteObject = (__bridge Reachability *)info;
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
    
}

#pragma mark - Reachability implementation

@implementation Reachability {
    
	BOOL _alwaysReturnLocalWiFiStatus;
	SCNetworkReachabilityRef _reachabilityRef;
    
}

+ (instancetype) reachabilityWithHostName:(NSString *)hostName {
    
	Reachability* returnValue = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	
    if(reachability != NULL) {
        
		returnValue= [[self alloc] init];
		
        if(returnValue != NULL) {
            
			returnValue->_reachabilityRef = reachability;
			returnValue->_alwaysReturnLocalWiFiStatus = NO;
		
        }
	
    }
	
    return returnValue;

}

+ (instancetype) reachabilityWithAddress:(const struct sockaddr_in *)hostAddress {
    
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
	Reachability* returnValue = NULL;

	if(reachability != NULL) {
        
		returnValue = [[self alloc] init];
		
        if(returnValue != NULL) {
            
			returnValue->_reachabilityRef = reachability;
			returnValue->_alwaysReturnLocalWiFiStatus = NO;
		
        }
	
    }
	
    return returnValue;

}

+ (instancetype) reachabilityForInternetConnection {
    
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
    
	return [self reachabilityWithAddress:&zeroAddress];
    
}


+ (instancetype) reachabilityForLocalWiFi {
    
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    Reachability* returnValue = [self reachabilityWithAddress: &localWifiAddress];
	
    if(returnValue != NULL)
		returnValue->_alwaysReturnLocalWiFiStatus = YES;
    
	return returnValue;
    
}

#pragma mark - Start and stop notifier

- (BOOL) startNotifier {
    
	BOOL returnValue = NO;
	SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

	if(SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        
		if(SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
			returnValue = YES;
        
	}
    
	return returnValue;
    
}


- (void) stopNotifier {
    
	if(_reachabilityRef != NULL)
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
}


- (void) dealloc {
    
	[self stopNotifier];
    
    if(_reachabilityRef != NULL)
		CFRelease(_reachabilityRef);
    
}

#pragma mark - Network Flag Handling

- (NetworkStatus) localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags {
    
	PrintReachabilityFlags(flags, "localWiFiStatusForFlags");
	NetworkStatus returnValue = NotReachable;

	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
		returnValue = ReachableViaWiFi;
    
	return returnValue;
    
}

- (NetworkStatus) networkStatusForFlags:(SCNetworkReachabilityFlags)flags {
    
	PrintReachabilityFlags(flags, "networkStatusForFlags");
	
    if((flags & kSCNetworkReachabilityFlagsReachable) == 0)
		return NotReachable;

    NetworkStatus returnValue = NotReachable;

	if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
		returnValue = ReachableViaWiFi;

	if((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {

        if((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
            returnValue = ReachableViaWiFi;
        
    }

	if((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        returnValue = ReachableViaWWAN;
    
	return returnValue;
        
}

- (BOOL) connectionRequired {
    
	NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;

	if(SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);

    return NO;
    
}

- (NetworkStatus) currentReachabilityStatus {
    
	NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
	NetworkStatus returnValue = NotReachable;
	SCNetworkReachabilityFlags flags;
    
	if(SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        
		if(_alwaysReturnLocalWiFiStatus)
			returnValue = [self localWiFiStatusForFlags:flags];
        
		else
			returnValue = [self networkStatusForFlags:flags];
        
	}
    
	return returnValue;

}

@end