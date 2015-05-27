//
//  ViewControllerModPoll.m
//  
//
//  Created by Giulio  Salierno on 27/05/15.
//
//

#import "ViewControllerModPoll.h"

@interface ViewControllerModPoll ()

@end

/* Tag riconoscimento row Nome Poll */
NSString *const TPollName = @"kPollName";

/* Tag riconoscimento row Descrizione Poll */
NSString *const TPollDesc = @"kPollDesc";

/* Tag riconoscimento row visibilità Poll */
NSString *const TPollPrivate = @"kPrivate";

/* Tag riconoscimento row scadenza */
NSString *const TPollDeadLine = @"kPollDeadLine";

/* Tag riconoscimento row candidates */
NSString *const TPollCandidates = @"textFieldRow";

/* Section contenente i candidates */
XLFormSectionDescriptor *mMultivaluedSection;

XLFormDescriptor *mForm;
XLFormSectionDescriptor *mSection;
XLFormRowDescriptor *mRow;
XLFormDescriptor *mFormDescriptor;


@implementation ViewControllerModPoll
@synthesize p,candidates;

- (instancetype) initWithCoder:(NSCoder *)coder
{
    
    self = [super initWithCoder:coder];
    if(self)
        [self Initialize];
    
    return self;
    
}

- (instancetype) init {
    
    self = [super init];
    
    if(self)
        [self Initialize];
    
    return self;
    
}

- (id) Initialize {
    
    mFormDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    mForm = [XLFormDescriptor formDescriptorWithTitle:@"Modifica Poll"];
    
    /* First section */
    mSection = [XLFormSectionDescriptor formSection];
    [mForm addFormSection:mSection];
    
    /* Image Poll Row */
    mRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormImageSelectorCellCustom];
    
    [mSection addFormRow:mRow];
    
    /* Aggiunto alla root section */
    mSection = [XLFormSectionDescriptor formSection];
    [mForm addFormSection:mSection];
    
    /* Nome Poll Row */
    mRow = [XLFormRowDescriptor formRowDescriptorWithTag:TPollName rowType:XLFormRowDescriptorTypeText];
    [mRow.cellConfigAtConfigure setObject:@"Nome Poll" forKey:@"textField.placeholder"];
    mRow.value = p.pollName;
    mRow.required = YES;
    
    /* Binding regex validazione input */
    [mRow addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"At least 6, max 21 characters" regex:@".{6,21}$"]];
    [mSection addFormRow:mRow];
    
    /* Aggiunto alla root section */
    mSection = [XLFormSectionDescriptor formSection];
    [mForm addFormSection:mSection];
    
    /* Terza Row Descrizione Poll */
    mRow = [XLFormRowDescriptor formRowDescriptorWithTag:TPollDesc rowType:XLFormRowDescriptorTypeTextView];
    [mRow.cellConfigAtConfigure setObject:@"Descrizione Poll" forKey:@"textView.placeholder"];
    mRow.value = p.pollDescription;
    [mSection addFormRow:mRow];
    
    /* Scadenza Poll Row */
    mRow = [XLFormRowDescriptor formRowDescriptorWithTag:TPollDeadLine rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Scadenza"];
    mRow.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [mSection addFormRow:mRow];
    
    /* isPrivate */
    mRow = [XLFormRowDescriptor  formRowDescriptorWithTag:TPollPrivate rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Privato"];
    
    if(p.pvtPoll == true) //Se il pool è privato switch su ON
        mRow.value =@YES;
    
    
    [mSection addFormRow:mRow];
    mSection.footerTitle =@"Nota: Rendendo il sondaggio privato non sarà visibile sulla Home di RankIT";
    
    
    /* Sezione dedicata all'aggiunta di candidates dinamica */
    mMultivaluedSection = [XLFormSectionDescriptor  formSectionWithTitle:@"Candidates"
                                                         sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                                      sectionInsertMode:XLFormSectionInsertModeButton];
    
    mMultivaluedSection.multivaluedAddButton.title = @"Aggiungi una risposta";
    
    /* Set up the row template */
    mRow = [XLFormRowDescriptor formRowDescriptorWithTag:TPollCandidates rowType:XLFormRowDescriptorTypeText];
    [[mRow cellConfig] setObject:@"Risposta" forKey:@"textField.placeholder"];
    mMultivaluedSection.multivaluedTag = @"textFieldRow";
    
    /* Adding exsisting row representing candidates */
    
    
    for(NSString *cand in candidates)
    {
    
        mRow = [XLFormRowDescriptor formRowDescriptorWithTag:TPollCandidates rowType:XLFormRowDescriptorTypeText];
        [[mRow cellConfig] setObject:@"Risposta" forKey:@"textField.placeholder"];
    
        mRow.value = [[NSString alloc] initWithFormat:@"%@", cand] ;
        
        [mMultivaluedSection addFormRow:mRow];
    
        /* End Adding existing row representing candidates */
    
        mMultivaluedSection.multivaluedRowTemplate = mRow;
        [mForm addFormSection:mMultivaluedSection];
    }
    
        self.form = mForm;
    
        return [super initWithForm:mForm];
    
}

/* Override dell'handler per la gestione della aggiunta delle righe rappresentanti candidates imponendo vincoli */
-(void) formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
    
    [super formRowHasBeenAdded:formRow atIndexPath:indexPath];
    
    /* Se abbiamo aggiunto 5 righe disabilitiamo l'add */
    if(mMultivaluedSection.formRows.count == 6) {
        
        /* Change properties */
        mMultivaluedSection.multivaluedAddButton.title = @"Poll Completo";
        mMultivaluedSection.multivaluedAddButton.disabled=@YES;
        
        /* refresh view */;
        [super reloadFormRow:mMultivaluedSection.multivaluedAddButton ];
        
    }
    
}

/* Override per il ripristino dell'add candidates in caso di eliminazione row */
-(void) formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
    
    [super formRowHasBeenRemoved:formRow atIndexPath:indexPath];
    
    /* Se il numero di candidates residui è < 4 riabilitiamo l'add */
    if(mMultivaluedSection.formRows.count < 6) {
        
        /* Changing properties */
        mMultivaluedSection.multivaluedAddButton.title = @"Aggiungi una risposta";
        mMultivaluedSection.multivaluedAddButton.disabled=@NO;
        
        /* refresh view */;
        [super reloadFormRow:mMultivaluedSection.multivaluedAddButton];
        
    }
    
}



/* Utilizzata per validare l'input inserito dall'utente */
-(BOOL) validateForm {
    
    __block BOOL isValidName = true;
    __block BOOL isValidDesc = true;
    
    NSArray *array = [self formValidationErrors];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        
        if([validationStatus.rowDescriptor.tag isEqualToString:TPollName]) {
            
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor redColor];
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
            
            isValidName = false;
            [self animateCell:cell];
            
        }
        
        else if([validationStatus.rowDescriptor.tag isEqualToString:TPollCandidates]) {
            
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor redColor];
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
            
            isValidDesc = false;
            [self animateCell:cell];
            
        }
        
    }];
    
    return (isValidName && isValidDesc ? true : false);
    
}

- (void) animateCell:(UITableViewCell *)cell {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    [cell.layer addAnimation:animation forKey:@"shake"];
    
}

/* Il metodo  si occupa di estrarre i dati dal form */
-(NSMutableDictionary * ) getFormValues {
    
    _result =   [NSMutableDictionary dictionary];
    
    for(XLFormSectionDescriptor * section in self.form.formSections) {
        
        if(!section.isMultivaluedSection){
            
            for(XLFormRowDescriptor * row in section.formRows) {
                
                if(row.tag && ![row.tag isEqualToString:@""])
                    [_result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                
            }
            
        }
        
        else {
            
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            
            for(XLFormRowDescriptor * row in section.formRows) {
                
                if(row.value)
                    [multiValuedValuesArray addObject:row.value];
                
            }
            
            [_result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
            
        }
        
    }
    
    
    return _result;
    
}

- (void) viewDidLoad {
    
    [self Initialize];
    [super viewDidLoad];
    
}

- (UIView *) inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return nil;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:(@"modPollResult")]) {
        
        [self getFormValues];
        ViewControllerSummaryPoll *vc = (ViewControllerSummaryPoll*) [segue destinationViewController ];
        vc.summaryResult = _result;
        vc.isModified = true;
        vc.oldCandidates = candidates;
        vc.pollId = p.pollId;
        
    
        
        
    }
    
}


- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if([identifier isEqualToString:@"modPollResult"] && [self validateForm])
    {
        return YES;
    }
        return NO;
    
}




@end
