#ifndef SUMMARY_POLL

#define SUMMARY_POLL
#import "XLFormViewController.h"
#import "XLForm.h"
#import <UIKit/UIKit.h>
#import "Poll.h"

#endif

@interface ViewControllerSummaryPoll : XLFormViewController

 /* Conterrà i dati ottenuti dalla compilazione del form della view precedente */
@property (strong,nonatomic) NSMutableDictionary *summaryResult;

/* Conterra i dati ottenuti dalla compilazione del form della view attuale */
@property (strong,nonatomic) NSMutableDictionary *pollDescResult;

/* Nuovo poll da sottomettere */
@property (strong,nonatomic) Poll *poll;

/* Se true siamo in una modifica */
@property BOOL isModified;

/* old pollID da eliminare */
@property int pollId;



/* Old Candidates */

@property (strong,nonatomic) NSMutableArray *oldCandidates;

@end