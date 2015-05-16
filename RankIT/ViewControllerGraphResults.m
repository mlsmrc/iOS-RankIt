//
//  ViewControllerGraphResults.m
//  RankIT
//
//  Created by Marco Mulas on 05/05/15.
//  Copyright (c) 2015 Marco Mulas. All rights reserved.
//

#import "ViewControllerGraphResults.h"
#import "ConnectionToServer.h"
#import "Votazione.h"
#import "CPTPlotSpace.h"

@interface ViewControllerGraphResults ()


@end

@implementation ViewControllerGraphResults

@synthesize tiesPlot,notiesPlot,poll,optimalData,optimalNotiesData,selectedPlot;
@synthesize grafico,classifica,votedBy,dizionarioVotazioni,selectedIndex;


-(void) viewDidLoad
{
    selectedIndex=-1;
    classifica.hidden=true;
    votedBy.hidden=true;
    self.scrittaClassifica.hidden=true;
    self.scrittaVoted.hidden=true;
    
    
}

-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    
    
    
    //inseriamo i primi  valori random in modo da tarare automaticamente il grafico su quei valori
    
    [self inizializzaArrays];
    
    // settaggio del grafico e visualizzazione
    [self initPlot];
    
    //inizio delle rilevazioni

    [super viewDidAppear:animated];
    
    self.scrittaClassifica.hidden=false;
    self.scrittaVoted.hidden=false;
    
    
}

#pragma mark - Chart behavior
-(void)initPlot {
    
    
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    
    
    
    //self.numberArray = [[NSMutableArray alloc] init];
    
}

-(void)configureHost {
    CGFloat graficoWidth = grafico.bounds.size.width;
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, graficoWidth, graficoWidth)];
    //self.grafico = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 60, 320, 460)];
    //self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 80, 320, 420)];
    // self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.grafico addSubview:self.hostView];
}


-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
//    [graph applyTheme:[CPTTheme themeNamed:kCPT]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    //NSString *title = @"sigma";
    // graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    // 2 - Create the three plots
    plotSpace.delegate = self;
    tiesPlot = [[CPTScatterPlot alloc] init];
    tiesPlot.dataSource = self;
    tiesPlot.identifier =@"TIES";
    CPTColor *tiesColor = [CPTColor blackColor];
    [graph addPlot:tiesPlot toPlotSpace:plotSpace];
    notiesPlot = [[CPTScatterPlot alloc] init];
    notiesPlot.dataSource = self;
    notiesPlot.identifier = @"NOTIES";
    CPTColor *notiesColor = [CPTColor redColor];
    [graph addPlot:notiesPlot toPlotSpace:plotSpace];
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:tiesPlot, notiesPlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.yRange = yRange;
    // 4 - Create styles and symbols
    
    CPTMutableLineStyle *tiesLineStyle = [tiesPlot.dataLineStyle mutableCopy];
    tiesLineStyle.lineWidth = 0.0;
    tiesLineStyle.lineColor = tiesColor;
    tiesPlot.dataLineStyle = tiesLineStyle;
    CPTMutableLineStyle *tiesSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    tiesSymbolLineStyle.lineColor = tiesColor;
    CPTPlotSymbol *tiesSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    tiesSymbol.fill = [CPTFill fillWithColor:tiesColor];
    tiesSymbol.lineStyle = tiesSymbolLineStyle;
    tiesSymbol.size = CGSizeMake(6.0f, 6.0f);
    tiesPlot.plotSymbol = tiesSymbol;
    CPTMutableLineStyle *notiesLineStyle = [notiesPlot.dataLineStyle mutableCopy];
    notiesLineStyle.lineWidth = 0.0;
    notiesLineStyle.lineColor = notiesColor;
    notiesPlot.dataLineStyle = notiesLineStyle;
    CPTMutableLineStyle *notiesSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    notiesSymbolLineStyle.lineColor = notiesColor;
    CPTPlotSymbol *notiesSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    notiesSymbol.fill = [CPTFill fillWithColor:notiesColor];
    notiesSymbol.lineStyle = notiesSymbolLineStyle;
    notiesSymbol.size = CGSizeMake(6.0f, 6.0f);
    notiesPlot.plotSymbol = notiesSymbol;
    notiesPlot.plotSymbolMarginForHitDetection=6.0f;
    tiesPlot.plotSymbolMarginForHitDetection=6.0f;
    tiesPlot.delegate=self;
    notiesPlot.delegate=self;
    // 1 - Get graph and plot space
    
    // 2 - Create the three plots
    /*optimalPlot = [[CPTScatterPlot alloc] init];
    optimalPlot.dataSource = self;
   optimalPlot.identifier =@"TIES";
    CPTColor *xColor = [CPTColor blackColor];
    [graph addPlot:optimalPlot toPlotSpace:plotSpace];
    
    
    optimalTiesPlot = [[CPTScatterPlot alloc] init];
    optimalTiesPlot.dataSource = self;
    optimalTiesPlot.identifier = @"NOTIES";
    CPTColor *yColor = [CPTColor redColor];
    [graph addPlot:optimalPlot toPlotSpace:plotSpace];
    
    
       // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:optimalPlot,optimalTiesPlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
   
    
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *optimalLineStyle = [optimalPlot.dataLineStyle mutableCopy];
    optimalLineStyle.lineWidth = 0.0;
    
   
    
   
    optimalPlot.dataLineStyle = optimalLineStyle;
    
    
    CPTMutableLineStyle *xSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    xSymbolLineStyle.lineColor = xColor;
    CPTPlotSymbol *xSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    xSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    xSymbol.lineStyle = xSymbolLineStyle;
    xSymbol.size = CGSizeMake(6.0f,6.0f);
    optimalPlot.plotSymbol = xSymbol;
    
    
    
    CPTMutableLineStyle *optimalTiesLineStyle = [optimalTiesPlot.dataLineStyle mutableCopy];
    optimalTiesLineStyle.lineWidth = 0.0;

    optimalTiesPlot.dataLineStyle = optimalTiesLineStyle;
    CPTMutableLineStyle *ySymbolLineStyle = [CPTMutableLineStyle lineStyle];
    ySymbolLineStyle.lineColor = yColor;
    CPTPlotSymbol *ySymbol = [CPTPlotSymbol ellipsePlotSymbol];
    ySymbol.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    ySymbol.lineStyle = ySymbolLineStyle;
    ySymbol.size = CGSizeMake(6.0f,6.0f);
    optimalTiesPlot.plotSymbol = ySymbol;*/
    
    }

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Ultralight";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Ultralight";
    axisTextStyle.fontSize = 12.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 0.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 0.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    CPTXYAxis *x = axisSet.xAxis;
    
    NSString *tit = [NSString stringWithFormat: @"mu"];
    
    x.title = tit;
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 2.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 8.0f;
    x.tickDirection = CPTSignNegative;
    
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:30];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:30];
   /*
    for(int i=0;i<[optimalData count];i++)
    {
        
        [xLocations addObject:[NSNumber numberWithFloat:i]];
        
    }*/
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    CGFloat xMax = 5.0f;
    NSInteger majorIncrement = 1;
    NSInteger minorIncrement = 1;
    NSMutableSet *xMajorLocations = [NSMutableSet set];
    NSMutableSet *xMinorLocations = [NSMutableSet set];
    for (NSInteger j = -xMax; j <= xMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:x.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -x.majorTickLength - x.labelOffset;
            if (label) {
                [xLabels addObject:label];
            }
            [xMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [xMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    
    x.axisLabels = xLabels;
    x.majorTickLocations = xMajorLocations;
    x.minorTickLocations =  xMinorLocations;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    x.tickDirection=CPTSignPositive;
    /* // Define some custom labels for the data elements
     x.labelRotation = M_PI/3;
     x.labelingPolicy = CPTAxisLabelingPolicyNone;
     
     
     
     
     
     NSUInteger labelLocation = 0;
     NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
     for (NSNumber *tickLocation in customTickLocations)
     {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
     newLabel.tickLocation = [tickLocation decimalValue];
     newLabel.offset = x.labelOffset + x.majorTickLength;
     newLabel.rotation = M_PI/4;
     [customLabels addObject:newLabel];
     }*/
    
    
    // 4 - Configure y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.title = @"sigma";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -20.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    
    CGFloat yMax = 5.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    
    
    for (NSInteger j = -yMax; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    if ([plot.identifier isEqual:@"TIES"] == YES) {
        
        return [self.optimalData count];
        
        
        //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
    }
    
    if ([plot.identifier isEqual:@"NOTIES"] == YES) {
        
         return [self.optimalNotiesData count];
        
        
        //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
    }
    
    return 0;
    
    
    //return [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    
    
    
    
  
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if ([plot.identifier isEqual:@"TIES"] == YES) {
                NSLog(@"%f e indice %lu",[[self.optimalData objectAtIndex:index]mu],(unsigned long)index);
                return [NSNumber numberWithFloat:[[self.optimalData objectAtIndex:index]mu]];
                
                
                //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
            }
            
            if ([plot.identifier isEqual:@"NOTIES"] == YES) {
                 NSLog(@"noties");
                return [NSNumber numberWithFloat:[[self.optimalNotiesData objectAtIndex:index]mu]];
                
                
                //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
            }
            
            break;
            
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"TIES"] == YES) {
                
                return [NSNumber numberWithFloat:[[self.optimalData objectAtIndex:index]sigma]];
                
                
                //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
            }
            
            if ([plot.identifier isEqual:@"NOTIES"] == YES) {
                
                return [NSNumber numberWithFloat:[[self.optimalNotiesData objectAtIndex:index]sigma]];
                
                
                //[[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolx] objectAtIndex:index];
            }
        
            
            
    }
    return NULL;
}




-(void) viewWillDisappear:(BOOL)animated{
    
 
    
    
}


-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    classifica.hidden=false;
    votedBy.hidden=false;
   
    selectedIndex=index;
    Votazione *votazione;
    //CGPoint point=[plot plotAreaPointOfVisiblePointAtIndex:index];
   
     if ([plot.identifier isEqual:@"TIES"] == YES)
     {
         votazione=[optimalData objectAtIndex:index];
         selectedPlot=[NSMutableString stringWithFormat:@"TIES"];
         [tiesPlot reloadData];
         
         
         }
    if ([plot.identifier isEqual:@"NOTIES"] == YES)
    {
       votazione=[optimalNotiesData objectAtIndex:index];
       selectedPlot=[NSMutableString stringWithFormat:@"NOTIES"];
         [notiesPlot reloadData];
    }
    votedBy.text=[NSString stringWithFormat:@"%f",[votazione votedby]];
    classifica.text=[votazione pattern];
   
[self symbolForScatterPlot:plot recordIndex:index];
    [tiesPlot reloadData];
   
[notiesPlot reloadData];
}

- (CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    
    
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
   
 
   
  

    
  
    if ([plot.identifier isEqual:@"TIES"] == YES&&index==selectedIndex&&[selectedPlot isEqualToString:@"TIES"])
    {
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill=[CPTFill fillWithColor:[CPTColor whiteColor]];
        plotSymbol.lineStyle=lineStyle;
        plot.plotSymbol=plotSymbol;
        return plotSymbol;
       
    }
    
    else if ([plot.identifier isEqual:@"TIES"] == YES&&index!=selectedIndex)
    {
        
    
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill=[CPTFill fillWithColor:[CPTColor blackColor]];
        plotSymbol.lineStyle=lineStyle;
        plot.plotSymbol=plotSymbol;
        return plotSymbol;
    }
    else if ([plot.identifier isEqual:@"NOTIES"] == YES&&index==selectedIndex&&[selectedPlot isEqualToString:@"NOTIES"])
        
    {
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill=[CPTFill fillWithColor:[CPTColor whiteColor]];
        plotSymbol.lineStyle=lineStyle;
        plot.plotSymbol=plotSymbol;
        return plotSymbol;
        
    }
    
    else  if ([plot.identifier isEqual:@"NOTIES"] == YES&&index!=selectedIndex)
        
    {
    
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill=[CPTFill fillWithColor:[CPTColor redColor]];
        plotSymbol.lineStyle=lineStyle;
        plot.plotSymbol=plotSymbol;
        return plotSymbol;
    }
    
    return nil;
}



-(void) inizializzaArrays{
    
    optimalData = [[NSMutableArray alloc] init];
    optimalNotiesData = [[NSMutableArray alloc] init];

    dizionarioVotazioni=[[NSMutableDictionary alloc]init];
    
    ConnectionToServer *connection=[[ConnectionToServer alloc]init];
    NSMutableDictionary* results=[connection getResultsOfPoll:poll];
    
    NSMutableDictionary * optimalNotiesclassifiche=[results valueForKey:@"optimalnotiesdata"];
    NSMutableDictionary * optimalclassifiche=[results valueForKey:@"optimaldata"];
    
    for(id key in optimalclassifiche )
    {
        Votazione *votazione=[[Votazione alloc] initWithPattern:[key valueForKey:@"pattern"] AndMu:[[key valueForKey:@"mu"]floatValue]AndSigma:[[key valueForKey:@"sigma"]floatValue] AndVotedBy:[[key valueForKey:@"votedby"]floatValue]];
        
        [optimalData addObject:votazione];
      
        
        
        
       // [dizionarioVotazioni setObject:votazione forKey:[NSString stringWithFormat:@"%f;%f",punto.x,punto.y]];
    }
    
    
    for(id key in optimalNotiesclassifiche )
    {
        Votazione *votazione=[[Votazione alloc] initWithPattern:[key valueForKey:@"pattern"] AndMu:[[key valueForKey:@"mu"]floatValue]AndSigma:[[key valueForKey:@"sigma"]floatValue] AndVotedBy:[[key valueForKey:@"votedby"]floatValue]];
        
        [optimalNotiesData addObject:votazione];
        CGPoint punto= CGPointMake([votazione mu], [votazione sigma]);
        NSLog(@"%f",punto.x);
        [dizionarioVotazioni setObject:votazione forKey:[NSString stringWithFormat:@"%f;%f",punto.x,punto.y]];
    }
    

    
    NSLog(@"diz %@",optimalData);
   
    
    
    
}
/*

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    // Handle down eve
    
    NSLog(@"%f",point.x);
    return true;
}
*/

@end
