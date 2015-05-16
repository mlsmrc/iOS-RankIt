//
//  ViewControllerGraphResults.h
//  RankIT
//
//  Created by Marco Mulas on 05/05/15.
//  Copyright (c) 2015 Marco Mulas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerGraphResults.h"
#import "CPTPlot.h"
#import "CPTXYGraph.h"
#import "CPTGraphHostingView.h"
#import "CPTGraph.h"
#import "Poll.h"
#import "CorePlot-CocoaTouch.h"

@interface ViewControllerGraphResults : UIViewController <CPTPlotDataSource,CPTPlotSpaceDelegate,CPTScatterPlotDelegate,CPTScatterPlotDataSource>
@property (strong, nonatomic) IBOutlet UIView *grafico;

@property CPTScatterPlot *tiesPlot;
@property CPTScatterPlot *notiesPlot;
@property NSMutableString * selectedPlot;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property NSMutableArray* optimalData;
@property NSMutableArray* optimalNotiesData;
@property NSMutableDictionary * dizionarioVotazioni;
@property Poll *poll;
@property (weak, nonatomic) IBOutlet UILabel *scrittaClassifica;
@property (weak, nonatomic) IBOutlet UILabel *scrittaVoted;
@property NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *classifica;
@property (weak, nonatomic) IBOutlet UILabel *votedBy;

@end
