#import "XLFormViewController.h"
#import "ViewControllerSummaryPoll.h"
#import "XLForm.h"
#import <UIKit/UIKit.h>

XLFormDescriptor *form;
XLFormSectionDescriptor *section;
XLFormRowDescriptor *row;
XLFormDescriptor *formDescriptor;

@interface ViewControllerAddPoll : XLFormViewController

/* Conterrà i dati ottenuti dalla compilazione del form */
@property (strong,nonatomic) NSMutableDictionary *result;

@end