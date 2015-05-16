//
//  XLViewController.h
//  Rate It!
//
//  Created by Giulio  Salierno on 22/04/15.
//  Copyright (c) 2015 Marco Finocchi. All rights reserved.
//

#import "XLFormViewController.h"
#import "ViewControllerSummaryPoll.h"
#import "XLForm.h"
#import <UIKit/UIKit.h>


XLFormDescriptor * form;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;
XLFormDescriptor * formDescriptor;



@interface ViewControllerAddPoll : XLFormViewController

@property (strong,nonatomic) NSMutableDictionary * result; // conterrà i dati ottenuti dalla compilazione del form

@end



