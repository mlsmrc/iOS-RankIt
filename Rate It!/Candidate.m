#import "Candidate.h"

@implementation Candidate

const NSString *CANDIDATE = @"{\"candname\": \"_CAND_NAME_\",\"canddescription\": \"_CAND_DESCR_\",\"candimage\": \"_CAND_IMAGE_\"}";

- (void) setCandicateWithChar:(NSString *)Char andName:(NSString *)Name andDescription:(NSString *)description
{

    [self setCandChar:Char];
    [self setCandDescription:description];
    [self setCandName:Name];
}

-(NSString*)description
{
    return [self candName];
}

/* crea una stringa utile per creare il JSON per l'aggiunta del poll    *
 * (usata in descriptionAddPoll in Poll.m)                              */
-(NSString *) descriptionForAddPoll
{
    NSString *desc = [CANDIDATE  stringByReplacingOccurrencesOfString:@"_CAND_NAME_" withString:[NSString stringWithFormat:@"%@",[self candName]]];
    desc = [desc  stringByReplacingOccurrencesOfString:@"_CAND_DESCR_" withString:[NSString stringWithFormat:@"%@",[self candDescription]]];
    desc = [desc  stringByReplacingOccurrencesOfString:@"_CAND_IMAGE_" withString:[NSString stringWithFormat:@""]];
    return desc;
}

@end