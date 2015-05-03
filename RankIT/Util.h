#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UTIL_H

#define UTIL_H

/* Altezza della cella */
#define CELL_HEIGHT 75

/* Utile per convertire un colore da esadecimale a "colore Obj-C" */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/* Utile per ViewControllerDettagli per capire il flusso da dove proviene */
#define FROM_VOTATI 0
#define FROM_HOME 1
#define FROM_MY_POLL 2

#endif

@interface Util : NSObject

/* Stringa per la search bar */
FOUNDATION_EXPORT NSString *NO_RESULTS;

/* Stringhe per il pulsante di ritorno schermata */
FOUNDATION_EXPORT NSString *SEARCH;
FOUNDATION_EXPORT NSString *BACK;
FOUNDATION_EXPORT NSString *BACK_TO_HOME;
FOUNDATION_EXPORT NSString *BACK_TO_VOTED;
FOUNDATION_EXPORT NSString *BACK_TO_MY_POLL;
FOUNDATION_EXPORT NSString *BACK_TO_RANKING;

/* Spaziatura voti per diversi IPhone */
FOUNDATION_EXPORT int IPHONE_4_4S_5_5S;
FOUNDATION_EXPORT int IPHONE_6;
FOUNDATION_EXPORT int IPHONE_6Plus;
FOUNDATION_EXPORT int X_FOR_VOTES;

/* Larghezza degli schermi di IPhone6 e IPhone6+ */
FOUNDATION_EXPORT float IPHONE_6_WIDTH;
FOUNDATION_EXPORT float IPHONE_6Plus_WIDTH;

+ (NSDateFormatter*) getDateFormatter;
+ (int) compareDate:(NSDate *)first WithDate:(NSDate *)second;
+ (NSString *) toStringUserFriendlyDate:(NSString *) data;

@end