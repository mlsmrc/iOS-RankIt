//
//  ViewController.m
//  RateIt
//
//  Created by Valentina Pizzo on 19/03/15.
//  Copyright (c) 2015 DFMPSS_2015. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *imageHome = [UIImage imageWithContentsOfFile:@"RateIt/Images/home-50.png"];
    if(imageHome==nil)
        NSLog(@"L'oggetto è null");
    self.Home.selectedImage = imageHome;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
