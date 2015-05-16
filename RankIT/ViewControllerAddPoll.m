//
//  XLViewController.m
//  Rate It!
//
//  Created by Giulio  Salierno on 22/04/15.
//  Copyright (c) 2015 Marco Finocchi. All rights reserved.
//

#import "ViewControllerAddPoll.h"
#import "XLFormImageSelectorCell.h"
#import "XLFormSectionDescriptor.h"


NSString * const kPollName = @"kPollName"; //tag riconoscimento row Nome Poll
NSString * const kPollDesc = @"kPollDesc"; //tag riconoscimento row Descrizione Poll
NSString * const kPollPrivate = @"kPrivate"; //tag riconoscimento row visibilità Poll
NSString * const kPollDeadLine = @"kPollDeadLine"; // tag riconoscimento row scadenza
NSString * const kPollCandidates = @"textFieldRow"; // tag riconoscimento row candidates

XLFormSectionDescriptor *multivaluedSection; //section contenente i candidates

@implementation ViewControllerAddPoll



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self Initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self Initialize];
    }
    return self;
}




-(id) Initialize
{
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    form = [XLFormDescriptor formDescriptorWithTitle:@"Crea Poll"];
    
    // First section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    //Image Poll Row
  
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormImageSelectorCellCustom];

    [section addFormRow:row];
    
    // Aggiunto alla root section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    
    
    // Nome Poll Row
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPollName rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Nome Poll" forKey:@"textField.placeholder"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"At least 6, max 21 characters" regex:@".{6,21}$"]]; // binding regex validazione input

    [section addFormRow:row];
    
    // Aggiunto alla root section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    
    //Terza Row Descrizione Poll
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPollDesc rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Descrizione Poll" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    

    
    // Scadenza Poll Row
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPollDeadLine rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Scadenza"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
    
    // isPrivate
    row = [XLFormRowDescriptor  formRowDescriptorWithTag:kPollPrivate rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Privato"];
    [section addFormRow:row];
    section.footerTitle =@"Nota: Rendendo il poll privato non sarà visibile sulla bacheca di Rate It";

    
    
    //Sezione dedicata all'aggiunta di candidates dinamica
    multivaluedSection = [XLFormSectionDescriptor  formSectionWithTitle:@"Candidates"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                             sectionInsertMode:XLFormSectionInsertModeButton];
    
    
    multivaluedSection.multivaluedAddButton.title = @"Aggiungi una risposta";
    
    
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPollCandidates rowType:XLFormRowDescriptorTypeText];

    [[row cellConfig] setObject:@"Risposta" forKey:@"textField.placeholder"];
    
     multivaluedSection.multivaluedTag = @"textFieldRow";
    
     multivaluedSection.multivaluedRowTemplate = row;
    
     [form addFormSection:multivaluedSection];
    
    
    
        self.form = form;
    

        return [super initWithForm:form];

    

}

/**
 * Override dell'handler per la gestione della aggiunta delle righe rappresentanti candidates imponendo vincoli
 */
-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    
    [super formRowHasBeenAdded:formRow atIndexPath:indexPath];
    
    
    if(multivaluedSection.formRows.count == 6) //se abbiamo aggiunto 5 righe disabilitiamo l'add
    {
        
        //change properties
        multivaluedSection.multivaluedAddButton.title = @"Poll Completo";
        multivaluedSection.multivaluedAddButton.disabled=@YES;

      
        [super reloadFormRow:multivaluedSection.multivaluedAddButton ]; //refresh view;
    

    }
}


/**
 * Override per il ripristino dell'add candidates in caso di eliminazione row
*/

-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [super formRowHasBeenRemoved:formRow atIndexPath:indexPath];

    
    if(multivaluedSection.formRows.count < 6) //se il numero di candidates residui è < 4 riabilitiamo l'add
    {
        //changing properties
        multivaluedSection.multivaluedAddButton.title = @"Aggiungi una risposta";
        multivaluedSection.multivaluedAddButton.disabled=@NO;
        
        [super reloadFormRow:multivaluedSection.multivaluedAddButton ]; //refresh view;

        
    }
}

/*
    Utilizzata per validare l'input inserito dall'utente
 */


-(BOOL)validateForm
{
    __block BOOL isValidName = true;
    __block BOOL isValidDesc = true;
    
    NSArray * array = [self formValidationErrors];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        if ([validationStatus.rowDescriptor.tag isEqualToString:kPollName])
        {
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor redColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
            
             isValidName = false;
             [self animateCell:cell];
        }
        else if ([validationStatus.rowDescriptor.tag isEqualToString:kPollCandidates]){
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


-(void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}

/**
 * Il metodo  si occupa di estrarre i dati dal form
*/

-(NSMutableDictionary * ) getFormValues
{
    _result =   [NSMutableDictionary dictionary];

    for (XLFormSectionDescriptor * section in self.form.formSections) {
        if (!section.isMultivaluedSection){
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.tag && ![row.tag isEqualToString:@""]){
                    [_result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
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
            [_result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
        }
    }
    
    //NSLog(@"%@",_result[kPollPrivate]);
    
    return _result;

}




-(void)viewDidLoad
{

    [super viewDidLoad];


}

-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        if([[segue identifier] isEqualToString:(@"summary")])
        {
            [self getFormValues];
        
            ViewControllerSummaryPoll *vc = (ViewControllerSummaryPoll*) [segue destinationViewController ];
        
                
            vc.summaryResult = _result;
        
        
        }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"summary"] && [self validateForm])
    {
        return YES;
    }
    return NO;
}


@end
