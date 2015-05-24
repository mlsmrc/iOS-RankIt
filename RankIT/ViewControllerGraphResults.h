#import <UIKit/UIKit.h>
#import "ViewControllerGraphResults.h"
#import "CPTPlot.h"
#import "CPTXYGraph.h"
#import "CPTGraphHostingView.h"
#import "CPTGraph.h"
#import "Poll.h"
#import "CorePlot-CocoaTouch.h"

@interface ViewControllerGraphResults : UIViewController <CPTPlotDataSource,CPTPlotSpaceDelegate,CPTScatterPlotDelegate,CPTScatterPlotDataSource>

@property (strong,nonatomic) IBOutlet UIView *grafico;
@property CPTScatterPlot *tiesPlot;
@property CPTScatterPlot *notiesPlot;
@property NSMutableString *selectedPlot;
@property (strong,nonatomic) CPTGraphHostingView *hostView;
@property NSMutableArray *optimalData;
@property NSMutableArray *optimalNotiesData;
@property NSMutableDictionary *dizionarioVotazioni;
@property Poll *poll;

@property NSUInteger selectedIndex;

@property NSArray * plotArray;
@property CPTPlotSpaceAnnotation *annotation;

@property (weak, nonatomic) IBOutlet UITextView *risposte;

@property NSMutableArray *candidates;

@end