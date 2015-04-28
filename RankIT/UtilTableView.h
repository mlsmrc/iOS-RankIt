#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UTIL_TABLE_VIEW_H

#define UTIL_TABLE_VIEW_H

/* Altezza della cella */
#define CELL_HEIGHT 75

#endif

@interface UtilTableView : NSObject

/* Stringa per la search bar */
FOUNDATION_EXPORT NSString *NO_RESULTS;

/* Stringhe per il pulsante di ritorno schermata */
FOUNDATION_EXPORT NSString *SEARCH;
FOUNDATION_EXPORT NSString *BACK;
FOUNDATION_EXPORT NSString *BACK_TO_HOME;
FOUNDATION_EXPORT NSString *BACK_TO_VOTED;

/* Spaziatura voti per diversi IPhone */
FOUNDATION_EXPORT NSString *IPHONE_4_4S_5_5S;
FOUNDATION_EXPORT NSString *IPHONE_6;
FOUNDATION_EXPORT NSString *IPHONE_6Plus;
FOUNDATION_EXPORT NSString *SPACE_FOR_VOTES;

/* Larghezza degli schermi di IPhone6 e IPhone6+ */
FOUNDATION_EXPORT float IPHONE_6_WIDTH;
FOUNDATION_EXPORT float IPHONE_6Plus_WIDTH;

@end