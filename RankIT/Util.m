#import <Foundation/Foundation.h>
#import "Util.h"

/* Utile per convertire un colore da esadecimale a "colore Obj-C" */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Util: NSObject

/* Stringa per la search bar */
NSString *NO_RESULTS = @"Nessun risultato trovato";

/* Stringhe per il pulsante di ritorno schermata */
NSString *SEARCH = @"Cerca";
NSString *BACK = @"";
NSString *BACK_TO_HOME = @"Home";
NSString *BACK_TO_VOTED = @"Votati";

/* Spaziatura voti per diversi IPhone */
int IPHONE_4_4S_5_5S = 245;
int IPHONE_6 = 295;
int IPHONE_6Plus = 335;
int X_FOR_VOTES = 245;

/* Larghezza degli schermi di IPhone6 e IPhone6+ */
float IPHONE_6_WIDTH = 375;
float IPHONE_6Plus_WIDTH = 414;


/* Ritorna l'oggetto utile a formattare la data - funzione statica */
+(NSDateFormatter*) getDateFormatter {
    
    NSDateFormatter *DF = [[NSDateFormatter alloc] init];
    DF.timeStyle = NSDateFormatterNoStyle;
    DF.dateStyle = NSDateFormatterMediumStyle;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:language];
    [DF setLocale:usLocale];
    [DF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return DF;
    
}

/* Comparatore di date */
+(int) compareDate:(NSDate *)first WithDate:(NSDate *)second {
    
    NSString *f = [first description];
    NSString *s = [second description];
    return ([f compare:s]);
    
}

/* Ritorna la stringa data in maniera più user friendly, già pronta per stamparla a video */
+ (NSString *) toStringUserFriendlyDate:(NSString *) data
{
    NSDateFormatter *fd = [Util getDateFormatter];
    NSDateComponents *compToDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateComponents *compData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[fd dateFromString:data]];
    
    int yearToDay = (int)[compToDay year];
    int monthToDay = (int)[compToDay month];
    int dayToDay = (int)[compToDay day];
    int hourToDay = (int)[compToDay hour];
    int minuteToDay = (int)[compToDay minute];
    int yearData = (int)[compData year];
    int monthData = (int)[compData month];
    int dayData = (int)[compData day];
    int hourData = (int)[compData hour];
    int minuteData = (int)[compData minute];
    NSArray *monthStrings = [[NSArray alloc] initWithObjects:@"Gennaio", @"Febbraio", @"Marzo", @"Aprile", @"Maggio", @"Giugno", @"Luglio", @"Agosto", @"Settembre", @"Ottobre", @"Novembre", @"Dicembre", nil];
    
    if (yearToDay>yearData)
        return @"Scaduto";
    else if (yearToDay<yearData)
        return [NSString stringWithFormat:@"Scadrà nel %d",yearData];
    else
    {
        if (monthToDay < monthData)
            return [NSString stringWithFormat:@"Scadrà a %@",monthStrings[monthData-1]];
        else if (monthToDay > monthData)
            return @"Scaduto";
        else
        {
            if (dayToDay < dayData)
                return [NSString stringWithFormat:@"Scadrà il %d",dayData];
            else if (dayToDay > dayData)
                return @"Scaduto";
            else
            {
                if (hourToDay < hourData)
                    return [NSString stringWithFormat:@"Scadrà alle %d",hourData];
                else if (dayToDay > dayData)
                    return @"Scaduto";
                else
                {
                    if (minuteToDay < minuteData)
                        return [NSString stringWithFormat:@"Scadrà alle %d:%d",hourData,minuteData];
                    else if (minuteToDay > minuteData)
                        return @"Scaduto";
                    else
                        return @"Sta per scadere";
                }
            }
        }
    }
    

    return @"";
}

@end