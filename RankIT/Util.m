#import <Foundation/Foundation.h>
#import "Util.h"

@implementation Util: NSObject

/* Stringa per la search bar */
NSString *NO_RESULTS = @"Nessun risultato trovato";

/* Stringhe per il pulsante di ritorno schermata */
NSString *SEARCH = @"Cerca";
NSString *BACK = @"";
NSString *BACK_TO_HOME = @"Home";
NSString *BACK_TO_VOTED = @"Votati";
NSString *BACK_TO_MY_POLL = @"I Miei Sond.";
NSString *BACK_TO_RANKING = @"Classifica";

/* Stringhe per messaggio da stampare a video */
NSString *EMPTY_POLLS_LIST = @"Non sono presenti sondaggi.\nProva ad aggiornare la Home.";
NSString *EMPTY_VOTED_POLLS_LIST = @"Non sono presenti sondaggi votati.\nVai sulla Home ed inizia a votare!";
NSString *EMPTY_MY_POLLS_LIST = @"Non sono presenti sondaggi creati.\nVai sulla Home e crea il tuo primo sondaggio!";
NSString *NO_RANKING = @"Nessun risultato presente per il sondaggio selezionato.";

/* Spaziatura voti per diversi IPhone */
int IPHONE_4_4S_5_5S = 245;
int IPHONE_6 = 295;
int IPHONE_6Plus = 335;
int X_FOR_VOTES = 245;

/* Larghezza degli schermi di IPhone6,6+ */
float IPHONE_6_WIDTH = 375;
float IPHONE_6Plus_WIDTH = 414;

/* Spaziatura grafico per diversi IPhone */
int GRAFICO_IPHONE_4_4S = 55;
int GRAFICO_IPHONE_5_5S = -30;
int GRAFICO_IPHONE_6 = -80;
int GRAFICO_IPHONE_6Plus = -115;

/* Lunghezza degli schermi di tutti di IPhone5,5S,6,6+ */
float IPHONE_5_5S_HEIGHT = 568;
float IPHONE_6_HEIGHT = 667;
float IPHONE_6Plus_HEIGHT = 736;

/* Ritorna l'oggetto utile a formattare la data - funzione statica */
+ (NSDateFormatter*) getDateFormatter {
    
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
+ (int) compareDate:(NSDate *)first WithDate:(NSDate *)second {
    
    NSDateFormatter *fd = [Util getDateFormatter];
    
    NSDateComponents *First = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:first];
    
    NSDateComponents *Second = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[fd dateFromString:[second description]]];
    
    int yearFirst = (int)[First year];
    int monthFirst = (int)[First month];
    int dayFirst = (int)[First day];
    int hourFirst = (int)[First hour];
    int minuteFirst = (int)[First minute];
    int yearSecond = (int)[Second year];
    int monthSecond = (int)[Second month];
    int daySecond = (int)[Second day];
    int hourSecond = (int)[Second hour];
    int minuteSecond = (int)[Second minute];
    
    if(yearFirst > yearSecond)
        return 1;
    
    else if(yearFirst < yearSecond)
        return -1;
    
    else {
        
        if(monthFirst > monthSecond)
            return 1;
        
        else if(monthFirst < monthSecond)
            return -1;
        
        else {
            
            if(dayFirst < daySecond)
                return -1;
            
            else if(dayFirst > daySecond)
                return 1;
            
            else {
                
                if(hourFirst < hourSecond)
                    return -1;
                
                else if(hourFirst > hourSecond)
                    return 1;
                
                else {
                    
                    if(minuteFirst < minuteSecond)
                        return -1;
                    
                    else if(minuteFirst > minuteSecond)
                        return 1;
                    
                    else
                        return 0;
                    
                }
                
            }
            
        }
        
    }
    
}

/* Ritorna la stringa data in maniera più user friendly, già pronta per stamparla a video */
+ (NSString *) toStringUserFriendlyDate:(NSString *) data {
    
    NSDateFormatter *fd = [Util getDateFormatter];
    NSDateComponents *compToDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[[NSDate alloc]init]];
    
    NSDateComponents *compData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[fd dateFromString:data]];
    
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
    
    NSString *friendlyDate=@"";
    
    if(yearToDay>yearData)
        friendlyDate=@"Sondaggio scaduto!";
    
    else if(yearToDay<yearData)
        friendlyDate=[NSString stringWithFormat:@"Scadrà nel %d",yearData];
    
    else {
        
        if(monthToDay < monthData)
            friendlyDate=[NSString stringWithFormat:@"Scadrà a %@",monthStrings[monthData-1]];
        
        else if(monthToDay > monthData)
            friendlyDate=@"Sondaggio scaduto!";
        
        else {
            
            if(dayToDay < dayData)
                friendlyDate=[NSString stringWithFormat:@"Scadrà il %d",dayData];
            
            else if(dayToDay > dayData)
                friendlyDate=@"Sondaggio scaduto!";
            
            else {
                
                if(hourToDay < hourData)
                    friendlyDate=[NSString stringWithFormat:@"Scadrà alle %d circa",hourData];
                
                else if(hourToDay > hourData)
                    friendlyDate=@"Sondaggio scaduto!";
                
                else {
                    
                    if(minuteToDay < minuteData)
                        
                        friendlyDate=[NSString stringWithFormat:@"Scadrà fra %d minuti",(minuteData-minuteToDay)];
                    
                    else if(minuteToDay > minuteData)
                        friendlyDate=@"Sondaggio scaduto!";
                    
                    else
                        friendlyDate=@"In scadenza";
                
                }
                
            }
            
        }
        
    }
    
    return friendlyDate;
    
}

@end