#import "XLFormViewController.h"
#import "XLFormImageModSelectorCell.h"
#import "ViewControllerSummaryPoll.h"
#import "XLForm.h"
#import "Poll.h"
#import <UIKit/UIKit.h>

@interface ViewControllerModPoll : XLFormViewController

/* Conterrà i dati ottenuti dalla compilazione del form */
@property (strong,nonatomic) NSMutableDictionary *result;

/*Conterrà il Poll da modificare proveniente dalla view precedente*/
@property (strong,nonatomic) Poll *p;

/*Conterrà i candidates per il poll passato */
@property(strong,nonatomic) NSMutableArray *candidates;

@end