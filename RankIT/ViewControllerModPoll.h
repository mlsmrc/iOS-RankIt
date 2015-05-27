//
//  ViewControllerModPoll.h
//  
//
//  Created by Giulio  Salierno on 27/05/15.
//
//

#import "XLFormViewController.h"
#import "XLFormImageSelectorCell.h"
#import "XLForm.h"
#import "Poll.h"
#import <UIKit/UIKit.h>



@interface ViewControllerModPoll : XLFormViewController
/* Conterrà i dati ottenuti dalla compilazione del form */
@property (strong,nonatomic) NSMutableDictionary *result;

/*Conterrà il Poll da modificare proveniente dalla view precedente*/
@property (strong,nonatomic) Poll *p;

@end
