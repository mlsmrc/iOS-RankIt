//
//  ViewControllerSummaryPoll.m
//  Rate It!
//
//  Created by Giulio  Salierno on 28/04/15.
//  Copyright (c) 2015 Marco Finocchi. All rights reserved.
//

#import "ViewControllerSummaryPoll.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormImageSelectorCell.h"
#import "ConnectionToServer.h"
#import "Candidate.h"
#import "File.h"


@implementation ViewControllerSummaryPoll
{
    XLFormDescriptor * summaryForm;
    XLFormSectionDescriptor * summarySection;
    XLFormRowDescriptor * summaryRow;
    XLFormDescriptor * summaryformDescriptor;
}

@synthesize summaryResult,pollDescResult;


NSString * const keyPollName = @"kPollName"; //tag riconoscimento row Nome Poll
NSString * const keyPollDesc = @"kPollDesc"; //tag riconoscimento row Descrizione Poll
NSString * const keyPollPrivate = @"kPrivate"; //tag riconoscimento row visibilità Poll
NSString * const keyPollDeadLine = @"kPollDeadLine"; // tag riconoscimento row scadenza
NSString * const keyPollCandidates = @"textFieldRow"; // tag riconoscimento row candidates



-(id) Initalize
{
    
    NSString *pollName = summaryResult[keyPollName];
    NSString *pollDesc = summaryResult[keyPollDesc];
    NSMutableArray *candidates = summaryResult[keyPollCandidates];
    NSDate *deadLine =  summaryResult[keyPollDeadLine];
    

    /*Date Formatter For showing date */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];

    
    
    
    /* Initializing view */
    
    
    summaryForm = [XLFormDescriptor formDescriptorWithTitle:@"Riepilogo "];
    
    // Prima Sezione
    summarySection = [XLFormSectionDescriptor formSection];
    summarySection.footerTitle = [NSString stringWithFormat:@"Scadenza: %@",[dateFormat stringFromDate:deadLine]];
    
    [summaryForm addFormSection:summarySection];
    
    
    // PollName
    summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollName" rowType:XLFormRowDescriptorTypeTwitter title:@"Nome Poll: "];
    summaryRow.disabled = @YES;
    summaryRow.value = pollName;
    [summarySection addFormRow:summaryRow];
    
    //Descrizione
    summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollDesc" rowType:XLFormRowDescriptorTypeTwitter title:@"Descrizione: "];
    summaryRow.disabled =@YES;
    summaryRow.value = pollDesc;
    [summarySection addFormRow:summaryRow];
    
    
    // Seconda Sezione Dinamica Candidate + Desc Candidate Not editable
    // MultivaluedSection section
    
    
    int countRow = 0; //tag identificativo unico per riconoscimento righe
    
    for( NSString * candidate in candidates)
    {
        //Creiamo Una nuova Sezione
        summarySection = [XLFormSectionDescriptor formSectionWithTitle:@""
                                                        sectionOptions:XLFormSectionOptionNone];

        [summaryForm addFormSection:summarySection];
        
        //Creiamo una nuova row per l'aggiunta di una foto del candidate
        //Image Poll Row
        
        
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormImageSelectorCellCustom];
        
        
        [summarySection addFormRow:summaryRow];
        
        
        //Creiamo una nuova riga corrispondente alla risposta
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandName %d",countRow]
rowType:XLFormRowDescriptorTypeTwitter title:@"Risposta: "];
                      
        [[summaryRow cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        summaryRow.value = [candidate copy];
        summaryRow.disabled=@YES; //disabled
        [summarySection addFormRow:summaryRow];
        
        //Creiamo una nuova riga per poter permettere l'aggiunta di una eventuale descrizione all'utente
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandDesc %d",countRow]
 rowType:XLFormRowDescriptorTypeTextView];
        [summaryRow.cellConfigAtConfigure setObject:@"Aggiungi una descrizione..." forKey:@"textView.placeholder"];
        [summarySection addFormRow:summaryRow];
        
        countRow++;
    
    }
 

    
    self.form = summaryForm;
    
    
    return [super initWithForm:summaryForm];
    
    
}


/**
 * Handler per la gestione delle action da intraprendere in seguito al tap del invio del form
 */
- (IBAction)send:(id)sender
{
    NSMutableDictionary *formValues =  [self getFormValues]; //recuperiamo i dati dal form
    
    Poll *newPoll = [self createPoll:formValues]; //creiamo un nuovo poll
    
    NSString *result =  [self postPoll:newPoll];
    
    NSLog(@"%@",[newPoll toJSON]);
    
    NSLog(@"%@",result);
    
    

}

/**
 * Il metodo  si occupa di estrarre i dati dal form
 */

-(NSMutableDictionary * ) getFormValues
{
    pollDescResult =   [NSMutableDictionary dictionary];
    
    for (XLFormSectionDescriptor * section in self.form.formSections) {
        if (!section.isMultivaluedSection){
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.tag && ![row.tag isEqualToString:@""]){
                    [pollDescResult setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                }
            }
        }
        else{
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.value){
                    [multiValuedValuesArray addObject:row.value];
                }
            }
            [pollDescResult setObject:multiValuedValuesArray forKey:section.multivaluedTag];
        }
    }
    
    
    
    return pollDescResult;
    
}


/**
 * Il metodo si occupa di creare un nuovo Poll dato un Dictionary contenente i dati per popolarlo
 */

-(Poll *) createPoll:(NSMutableDictionary *) dataInput
{
    /* estrazione dati dal dictionary passato in input */
    
    NSString *pollName = summaryResult[keyPollName];
    NSString *pollDesc = summaryResult[keyPollDesc];
    NSDate *deadLine = summaryResult[keyPollDeadLine];
    BOOL private = (summaryResult[keyPollPrivate] == false || summaryResult[keyPollPrivate] == (id)[NSNull null]  ? false : true);
    
    
    
   NSMutableArray *pollCand =  [self createCandidate:dataInput]; //creazione di un array di candidates del poll con CandName - CandDesc
    
    
    /*
     * Creazione nuovo Poll
     */
    _poll = [[Poll alloc] initPollWithUserID:[File getUDID] withName:pollName withDescription:pollDesc withDeadline:deadLine withPrivate:private withCandidates:pollCand];
    
    
    return _poll;

}


/**
 * Il metodo si occupa dell'invio del poll al server
 */

-(NSString *) postPoll:(Poll*) newPoll
{
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    return [conn addPollWithPoll:newPoll];
    
    
}

- (void)viewDidLoad
{

    [self Initalize];
    [super viewDidLoad];
    
}


/**
 * Il metodo si occupa di creare un array di candidates costituenti il poll
 */
-(NSMutableArray *) createCandidate:(NSMutableDictionary *)inputCandidates
{
    NSMutableArray *candidates = [[NSMutableArray alloc] init]; //array candidates poll
    
    
    for( NSString *key in inputCandidates.allKeys) //iteriamo su tutte le chiavi della collezione
    {
        if([key rangeOfString:@"CandName"].location != NSNotFound) //se abbiamo trovato un nome di un candidate
        {
            //Recupero CandName
            NSString *name = [inputCandidates objectForKey:key];
            
            //split per recuperare l'id del tag
            NSArray *arrayWithTwoStrings = [key componentsSeparatedByString:@" "];
            
            //creazione key per recupero Desc
            NSString *descKey = [NSString stringWithFormat: @"CandDesc %@",arrayWithTwoStrings[1]];
            
            //recupero descrizione
            NSString *desc = [inputCandidates objectForKey:descKey];
            
            //creazione nuovo candidate
            
            Candidate *cand = [[Candidate alloc] initCandicateWithChar:@"" andName:name andDescription:(desc == (id)[NSNull null] ? @"" : desc)];
            
            [candidates addObject:cand];
            

            
            
        }
        
    
    }
    
    
    
    return candidates;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
