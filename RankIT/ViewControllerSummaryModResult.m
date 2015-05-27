//
//  ViewControllerSummaryModResult.m
//  RankIT
//
//  Created by Giulio  Salierno on 27/05/15.
//  Copyright (c) 2015 Giulio Salierno. All rights reserved.
//

#import "ViewControllerSummaryModResult.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormImageSelectorCell.h"
#import "ConnectionToServer.h"
#import "Candidate.h"
#import "File.h"


@interface ViewControllerSummaryModResult ()

@end


@implementation ViewControllerSummaryModResult
{

    XLFormDescriptor *modSummaryForm;
    XLFormSectionDescriptor *modSummarySection;
    XLFormRowDescriptor *modSummaryRow;
    XLFormDescriptor *modSummaryformDescriptor;
}

@synthesize oldPoll,candidates,mSummaryResult,mPollDescResult;



- (id) Initalize {
    
    NSString *pollName = mSummaryResult[@"kPollName"];
    NSString *pollDesc = mSummaryResult[@"kPollDesc"];
    NSMutableArray *candidates = mSummaryResult[@"textFieldRow"];
    NSDate *deadLine =  mSummaryResult[@"kPollDeadLine"];
    
    /* Date Formatter forshowing date */
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    /* Initializing view */
    modSummaryForm = [XLFormDescriptor formDescriptorWithTitle:@"Riepilogo "];
    
    /* Prima Sezione */
    modSummarySection = [XLFormSectionDescriptor formSection];
    modSummarySection.footerTitle = [NSString stringWithFormat:@"Scadenza: %@",[dateFormat stringFromDate:deadLine]];
    
    [modSummaryForm addFormSection:modSummarySection];
    
    /* PollName */
    modSummaryForm = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollName" rowType:XLFormRowDescriptorTypeTwitter title:@"Nome Poll: "];
    modSummaryForm.disabled = @YES;
    modSummaryRow.value = pollName;
    [modSummarySection addFormRow:modSummaryRow];
    
    /* Descrizione */
    modSummaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollDesc" rowType:XLFormRowDescriptorTypeTwitter title:@"Descrizione: "];
    modSummaryRow.disabled =@YES;
    modSummaryRow.value = pollDesc;
    [modSummarySection addFormRow:modSummaryRow];
    
    /* Seconda Sezione Dinamica Candidate + Desc Candidate Not editable *
     * MultivaluedSection section                                       */
    
    /* Tag identificativo unico per riconoscimento righe */
    int countRow = 0;
    
    for( NSString * candidate in candidates) {
        
        /* Creiamo una nuova Sezione */
        modSummarySection = [XLFormSectionDescriptor formSectionWithTitle:@"" sectionOptions:XLFormSectionOptionNone];
        
        [modSummaryForm addFormSection:modSummarySection];
        
        /* Creiamo una nuova row per l'aggiunta di una foto del candidate *
         * Image Poll Row                                                 */
        
        modSummaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormImageSelectorCellCustom];
        [modSummarySection addFormRow:modSummaryRow];
        
        /* Creiamo una nuova riga corrispondente alla risposta */
        modSummaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandName %d",countRow] rowType:XLFormRowDescriptorTypeTwitter title:@"Risposta: "];
        
        [[modSummaryRow cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        modSummaryRow.value = [candidate copy];
        modSummaryRow.disabled=@YES;
        [modSummarySection addFormRow:modSummaryRow];
        
        /* Creiamo una nuova riga per poter permettere l'aggiunta di una eventuale descrizione all'utente */
        modSummaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandDesc %d",countRow] rowType:XLFormRowDescriptorTypeTextView];
        
        [modSummaryRow.cellConfigAtConfigure setObject:@"Aggiungi una descrizione..." forKey:@"textView.placeholder"];
        [modSummarySection addFormRow:modSummaryRow];
        
        countRow++;
        
    }
    
    self.form = modSummaryForm;
    return [super initWithForm:modSummaryForm];
    
}


/* Handler per la gestione delle action da intraprendere in seguito al tap del invio del form */
- (IBAction) send:(id)sender {
    
    /* Recuperiamo i dati dal form */
    NSMutableDictionary *formValues =  [self getFormValues];
    
    /* Creiamo un nuovo poll */
    Poll *newPoll = [self createPoll:formValues];
    
    [self postPoll:newPoll];
    
}

/* Il metodo  si occupa di estrarre i dati dal form */
- (NSMutableDictionary *) getFormValues {
    
    mPollDescResult =   [NSMutableDictionary dictionary];
    
    for(XLFormSectionDescriptor * section in self.form.formSections) {
        
        if(!section.isMultivaluedSection){
            
            for(XLFormRowDescriptor * row in section.formRows) {
                
                if(row.tag && ![row.tag isEqualToString:@""])
                    [mPollDescResult setObject:(row.value ?: [NSNull null]) forKey:row.tag];
            }
            
        }
        
        else {
            
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            
            for(XLFormRowDescriptor * row in section.formRows) {
                
                if(row.value)
                    [multiValuedValuesArray addObject:row.value];
                
            }
            
            [mPollDescResult setObject:multiValuedValuesArray forKey:section.multivaluedTag];
            
        }
        
    }
    
    return mPollDescResult;
    
}


/* Il metodo si occupa di creare un nuovo Poll dato un Dictionary contenente i dati per popolarlo */
- (Poll *) createPoll:(NSMutableDictionary *) dataInput {
    
    /* Estrazione dati dal dictionary passato in input */
    NSString *pollName = mSummaryResult[@"kPollName"];
    NSString *pollDesc = mSummaryResult[@"kPollDesc"];
    NSDate *deadLine = mSummaryResult[@"kPollDeadLine"];
    BOOL private = (mSummaryResult[@"kPollDeadLine"] == false || mSummaryResult[@"kPollDeadLine"] == (id)[NSNull null]  ? false : true);
    NSMutableArray *pollCand =  [self createCandidate:dataInput]; //creazione di un array di candidates del poll con CandName - CandDesc
    
    
    /* Creazione nuovo Poll */
    
    _poll = [[Poll alloc] initPollWithUserID:[File getUDID] withName:pollName withDescription:pollDesc withDeadline:deadLine withPrivate:private withCandidates:pollCand];
    
    return _poll;
    
}


/* Il metodo si occupa dell'invio del poll al server */
- (NSString *) postPoll:(Poll*) newPoll {
    
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    return [conn addPollWithPoll:newPoll];
    
}

- (void) viewDidLoad {
    
    [self Initalize];
    [super viewDidLoad];
    
}


/* Il metodo si occupa di creare un array di candidates costituenti il poll */

- (NSMutableArray *) createCandidate:(NSMutableDictionary *)inputCandidates {
    
    /* Array candidates poll */
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    
    /* Iteriamo su tutte le chiavi della collezione */
    
    for( NSString *key in inputCandidates.allKeys) {
        
        /* Se abbiamo trovato un nome di un candidate */
        
        if([key rangeOfString:@"CandName"].location != NSNotFound) {
            
            /* Recupero CandName */
            NSString *name = [inputCandidates objectForKey:key];
            
            /* Split per recuperare l'id del tag */
            NSArray *arrayWithTwoStrings = [key componentsSeparatedByString:@" "];
            
            /* Creazione key per recupero Desc */
            NSString *descKey = [NSString stringWithFormat: @"CandDesc %@",arrayWithTwoStrings[1]];
            
            /* Recupero descrizione */
            NSString *desc = [inputCandidates objectForKey:descKey];
            
            /* Creazione nuovo candidate */
            Candidate *cand = [[Candidate alloc] initCandicateWithChar:@"" andName:name andDescription:(desc == (id)[NSNull null] ? @"" : desc)];
            [candidates addObject:cand];
            
        }
        
    }
    
    return candidates;
    
}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
