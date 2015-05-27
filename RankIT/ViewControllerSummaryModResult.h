//
//  ViewControllerSummaryModResult.h
//  RankIT
//
//  Created by Giulio  Salierno on 27/05/15.
//  Copyright (c) 2015 Giulio Salierno. All rights reserved.
//

#ifndef MOD_SUMMARY_POLL

#define MOD_SUMMARY_POLL

#import "XLFormViewController.h"
#import "Poll.h"
#import "XLForm.h"
#import <UIKit/UIKit.h>

#endif

@interface ViewControllerSummaryModResult : XLFormViewController

/*Conterrà il Poll da modificare proveniente dalla view precedente*/
@property (strong,nonatomic) Poll *oldPoll;

/* Nuovo poll da sottomettere */
@property (strong,nonatomic) Poll *poll;

/*Conterrà i candidates per il poll passato */
@property(strong,nonatomic) NSMutableArray *candidates;

/* Conterrà i dati ottenuti dalla compilazione del form della view precedente */
@property (strong,nonatomic) NSMutableDictionary *mSummaryResult;

/* Conterra i dati ottenuti dalla compilazione del form della view attuale */
@property (strong,nonatomic) NSMutableDictionary *mPollDescResult;

@end
