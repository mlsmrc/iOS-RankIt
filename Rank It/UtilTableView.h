#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UTIL_TABLE_VIEW_H
#define UTIL_TABLE_VIEW_H
/* Altezza della cella */
#define CELL_HEIGHT 75

/* Stringa di spazi da usare per inserire nella detailTextLabel quanti voti ha ricevuto il poll */
#define SPACES_FOR_VOTES "                              "
#define SPACES_FOR_VOTES_SCADUTO "                   "

#endif

@interface UtilTableView : NSObject

/* Stringa per la search bar */
FOUNDATION_EXPORT NSString *NO_RESULTS;

/* Stringhe per il pulsante di ritorno schermata */
FOUNDATION_EXPORT NSString *SEARCH;
FOUNDATION_EXPORT NSString *BACK;
FOUNDATION_EXPORT NSString *BACK_TO_HOME;
FOUNDATION_EXPORT NSString *BACK_TO_VOTED;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end