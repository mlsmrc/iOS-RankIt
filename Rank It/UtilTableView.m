#import <Foundation/Foundation.h>
#import "UtilTableView.h"



@implementation UtilTableView: NSObject

/* Stringa per la search bar */
NSString *NO_RESULTS = @"Nessun risultato trovato";

/* Stringhe per il pulsante di ritorno schermata */
NSString *SEARCH = @"Cerca";
NSString *BACK = @"Home";

/* Funzione utile per scalare la grandezza di un immagine */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end