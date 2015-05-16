//
//  ViewControllerSummaryPoll.h
//  Rate It!
//
//  Created by Giulio  Salierno on 28/04/15.
//  Copyright (c) 2015 Marco Finocchi. All rights reserved.
//
#ifndef SUMMARY_POLL
#define SUMMARY_POLL

#import "XLFormViewController.h"
#import "XLForm.h"
#import <UIKit/UIKit.h>
#import "Poll.h"



#endif


@interface ViewControllerSummaryPoll : XLFormViewController

@property (strong,nonatomic) NSMutableDictionary * summaryResult; // conterrà i dati ottenuti dalla compilazione del form della view precedente
@property(strong,nonatomic) NSMutableDictionary  *pollDescResult; // conterra i dati ottenuti dalla compilazione del form della view attuale
@property (strong,nonatomic) Poll *poll; //nuovo poll da sottomettere

@end


