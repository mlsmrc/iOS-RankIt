#import "ViewControllerSummaryPoll.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormImageSelectorCell.h"
#import "ConnectionToServer.h"
#import "Candidate.h"
#import "File.h"

@implementation ViewControllerSummaryPoll {
    
    XLFormDescriptor *summaryForm;
    XLFormSectionDescriptor *summarySection;
    XLFormRowDescriptor *summaryRow;
    XLFormDescriptor *summaryformDescriptor;
    NSArray *candWithChar;
    NSString *serverResult;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
}

@synthesize summaryResult,pollDescResult,isModified,oldCandidates,pollId;

/* Tag riconoscimento row Nome Poll */
NSString *const keyPollName = @"kPollName";

/* Tag riconoscimento row Descrizione Poll */
NSString *const keyPollDesc = @"kPollDesc";

/* Tag riconoscimento row visibilità Poll */
NSString *const keyPollPrivate = @"kPrivate";

/* Tag riconoscimento row scadenza */
NSString *const keyPollDeadLine = @"kPollDeadLine";

/* Tag riconoscimento row candidates */
NSString *const keyPollCandidates = @"textFieldRow";

- (id) Initalize {
    
    
    candWithChar = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",nil];

    NSString *pollName = summaryResult[keyPollName];
    NSString *pollDesc = summaryResult[keyPollDesc];
    NSMutableArray *candidates = summaryResult[keyPollCandidates];
    NSDate *deadLine =  summaryResult[keyPollDeadLine];
    
    /* Date Formatter for showing date */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    /* Initializing view */
    summaryForm = [XLFormDescriptor formDescriptorWithTitle:@"Riepilogo "];
    
    /* Prima Sezione */
    summarySection = [XLFormSectionDescriptor formSection];
    summarySection.footerTitle = [NSString stringWithFormat:@"Scadenza: %@",[dateFormat stringFromDate:deadLine]];
    [summaryForm addFormSection:summarySection];
    
    /* PollName */
    summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollName" rowType:XLFormRowDescriptorTypeTwitter title:@"Nome Poll: "];
    summaryRow.disabled = @YES;
    summaryRow.value = pollName;
    [summarySection addFormRow:summaryRow];
    
    /* Descrizione */
    summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"PollDesc" rowType:XLFormRowDescriptorTypeTwitter title:@"Descrizione: "];
    summaryRow.disabled =@YES;
    summaryRow.value = pollDesc;
    [summarySection addFormRow:summaryRow];
    
    /* Seconda Sezione Dinamica Candidate + Desc Candidate Not editable *
     * MultivaluedSection section                                       */
    
    /* Tag identificativo unico per riconoscimento righe */
    int countRow = 0;
    
    
    for(NSString *candidate in candidates) {
        
        /* Creiamo una nuova Sezione */
        summarySection = [XLFormSectionDescriptor formSectionWithTitle:@"" sectionOptions:XLFormSectionOptionNone];
        
        [summaryForm addFormSection:summarySection];
        
        /* Creiamo una nuova row per l'aggiunta di una foto del candidate *
         * Image Poll Row                                                 */
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormImageSelectorCellCustom];
        [summarySection addFormRow:summaryRow];
        
        /* Creiamo una nuova riga corrispondente alla risposta */
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandName %d",countRow] rowType:XLFormRowDescriptorTypeTwitter title:@"Risposta: "];
        
        [[summaryRow cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        summaryRow.value = [candidate copy];
        summaryRow.disabled=@YES;
        [summarySection addFormRow:summaryRow];
        
        /* Creiamo una nuova riga per poter permettere l'aggiunta di una eventuale descrizione all'utente */
        summaryRow = [XLFormRowDescriptor formRowDescriptorWithTag:[NSString stringWithFormat: @"CandDesc %d",countRow] rowType:XLFormRowDescriptorTypeTextView];
        
        summaryRow.value = [self getDescrByCand:candidate];
        [summaryRow.cellConfigAtConfigure setObject:@"Aggiungi una descrizione..." forKey:@"textView.placeholder"];
        [summarySection addFormRow:summaryRow];
        
        countRow++;
        
    }
    
    self.form = summaryForm;
    return [super initWithForm:summaryForm];
    
}

/* Handler per la gestione delle action da intraprendere in seguito al tap del invio del form */
- (IBAction) send:(id)sender {
    
    /* Recuperiamo i dati dal form */
    NSMutableDictionary *formValues =  [self getFormValues];
    
    /* Creiamo un nuovo poll */
    Poll *newPoll = [self createPoll:formValues];
    
    serverResult =  [self postPoll:newPoll];
    
    [self connectionHandler:self.isModified];
    
}

-(void) connectionHandler:(BOOL) modified
{
    NSString *addOk =@"Sondaggio creato con successo!";
    NSString *modifiedOk=@"Sondaggio modificato correttamente!";
    
    /* Popup per voto sottomesso */
    UIAlertView *alert = [UIAlertView alloc];
    alert.tag = 1;
    
    if(!modified)
    {
    alert = [alert initWithTitle:@"Esito Aggiunta" message:(serverResult != (id)[NSNull null] ? addOk : SERVER_UNREACHABLE_2) delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    }else
        alert = [alert initWithTitle:@"Esito Modifica" message:(serverResult != (id)[NSNull null] ? modifiedOk : SERVER_UNREACHABLE_2) delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
    
}

/* Funzione delegate per i Popup della view */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* Titolo del bottone cliccato */
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    /* L'alert view conseguente ad una votazione effettuata */
    if(alertView.tag == 1)
    {
        
        if([title isEqualToString:@"Ok"] && serverResult != (id)[NSNull null] )
        {
             [FLAGS removeAllObjects];
            
            if(self.isModified)
            {
               
                [FLAGS addObject:@"MYPOLL"];
            
            }
            else
            {
                [FLAGS addObject:@"HOME"];
        
        
            }
            
            
            /* Vai alla Home */
         
            [File writeOnReload:@"0" ofFlags:FLAGS];

            [self.navigationController popToRootViewControllerAnimated:TRUE];
            
        
    }
    
    

    }

}
/* Il metodo  si occupa di estrarre i dati dal form */
- (NSMutableDictionary *) getFormValues {
    
    pollDescResult =   [NSMutableDictionary dictionary];
    
    for(XLFormSectionDescriptor * section in self.form.formSections)
    {
        
        if(!section.isMultivaluedSection)
        {
            
            for(XLFormRowDescriptor * row in section.formRows)
            {
                
                if(row.tag && ![row.tag isEqualToString:@""])
                    [pollDescResult setObject:(row.value ?: [NSNull null]) forKey:row.tag];

            }
            
        }
        
    }
    
    return pollDescResult;
    
}

/* Il metodo si occupa di creare un nuovo Poll dato un Dictionary contenente i dati per popolarlo */
- (Poll *) createPoll:(NSMutableDictionary *) dataInput {
    
    /* Estrazione dati dal dictionary passato in input */
    NSString *pollName = summaryResult[keyPollName];
    NSString *pollDesc = summaryResult[keyPollDesc];
    NSDate *deadLine = summaryResult[keyPollDeadLine];
    BOOL private = false;
    
    if(summaryResult[keyPollPrivate] != (id)[NSNull null])
        private = [summaryResult[keyPollPrivate] boolValue];
    

    NSMutableArray *pollCand =  [self createCandidate:dataInput]; //creazione di un array di candidates del poll con CandName - CandDesc
    
    /* Creazione nuovo Poll */
    _poll = [[Poll alloc] initPollWithUserID:[File getUDID] withName:pollName withDescription:(pollDesc == (id)[NSNull null] ? @"" : pollDesc) withDeadline:deadLine withPrivate:private withCandidates:pollCand];
    
    return _poll;
    
}

/* Il metodo si occupa dell'invio del poll al server */
- (NSString *) postPoll:(Poll*) newPoll {
    
    ConnectionToServer *conn = [[ConnectionToServer alloc]init];
    
    /* Se stiamo modificando un pool eliminiamo il vecchio */
    if(isModified)
        [self removeOldPoll:pollId];
    
    return [conn addPollWithPoll:newPoll];
    
}

- (void) viewDidLoad
{
    
    [self Initalize];
    [super viewDidLoad];
    FLAGS = [[NSMutableArray alloc]init];
    
}

/* Il metodo si occupa di creare un array di candidates costituenti il poll */
- (NSMutableArray *) createCandidate:(NSMutableDictionary *)inputCandidates {
    
    int candidateWithChar = 0; //cand char associato al candidate
    
    /* Array candidates poll */
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    
    /*Sorting keys */
    NSArray *sortedKeys = [[inputCandidates allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    /* Iteriamo su tutte le chiavi della collezione */
    for( NSString *key in sortedKeys) {
        
        /* Se abbiamo trovato un nome di un candidate */
        if([key rangeOfString:@"CandName"].location != NSNotFound) {
            
            /* Recupero CandName */
            NSString *name = [inputCandidates objectForKey:key];
            
            NSLog(@"%@",name);

            
            /* Split per recuperare l'id del tag */
            NSArray *arrayWithTwoStrings = [key componentsSeparatedByString:@" "];
            
            /* Creazione key per recupero Desc */
            NSString *descKey = [NSString stringWithFormat: @"CandDesc %@",arrayWithTwoStrings[1]];
            
            /* Recupero descrizione */
            NSString *desc = [inputCandidates objectForKey:descKey];
            
            /* Creazione nuovo candidate */
            Candidate *cand = [[Candidate alloc] initCandicateWithChar:candWithChar[candidateWithChar] andName:name andDescription:(desc == (id)[NSNull null] ? @"" : desc)];
            [candidates addObject:cand];
            
            candidateWithChar++;
            
        }
        
    }
    
    return candidates;
    
}

/*Dato un candidates il metodo restituisce la descrizion in caso di modifica poll*/
- (NSString *)getDescrByCand:(NSString *)candid {
    
    for(Candidate *cand in oldCandidates) {
        
        if([cand.candName isEqualToString:candid])
            return cand.candDescription;
        
    }
    
    return @"";
}

/* Hiding done Bar */
- (UIView *) inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return nil;
    
}

/* Il metodo si occupa di eliminare i poll vecchi in modifica*/
- (int) removeOldPoll:(int) pollid {
    
    ConnectionToServer *conn = [[ConnectionToServer alloc] init];
    return [conn deletePollWithPollId:[NSString stringWithFormat:@"%d",pollid] AndUserID:[File getUDID]];
    
}

@end