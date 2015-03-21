//
//  ViewController.h
//  RateIt
//
//  Created by Valentina Pizzo on 19/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    __weak IBOutlet UITableView *TableView;
    __weak IBOutlet UITabBarItem *Home;
    __weak IBOutlet UITabBarItem *MieiSondaggi;
    __weak IBOutlet UITabBarItem *Votati;
    __weak IBOutlet UITabBarItem *Impostazioni;
    __weak IBOutlet UIBarButtonItem *AddPoll;
}

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *Home;
@property (weak, nonatomic) IBOutlet UITabBarItem *MieiSondaggi;
@property (weak, nonatomic) IBOutlet UITabBarItem *Votati;
@property (weak, nonatomic) IBOutlet UITabBarItem *Impostazioni;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddPoll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *CheckingInternet;
@property (weak, nonatomic) IBOutlet UILabel *WarningInternet;

@end

