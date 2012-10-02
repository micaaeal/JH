//
//  BeforeNewEventViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/19/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "BeforeNewEventViewController.h"
#import "CreateEventViewController.h"
#import "MapViewController.h"
#import "DataModel.h"
#import "DataManager.h"

@interface BeforeNewEventViewController ()

@end

@implementation BeforeNewEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{

    [self performSegueWithIdentifier:@"NewEventSegue" sender:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = segue.destinationViewController;
    
    CreateEventViewController* newController = [nav.viewControllers objectAtIndex:0];
    newController.delegate = self;
}

-(void)exitFromChild:(id)sender done:(BOOL)done{
    
    int selectedIndex = 1;
    
    UITabBarController* tab = (UITabBarController*)self.parentViewController;
    [tab setSelectedIndex:selectedIndex];
    
    UINavigationController* nav = (UINavigationController*)[tab.childViewControllers objectAtIndex:selectedIndex]; 
    MapViewController* mapControl = (MapViewController*)[nav.viewControllers objectAtIndex:0];
    
    if ([mapControl isKindOfClass:[MapViewController class]]) {
        
        if (done) {
            [mapControl reloadSearchResult];
        }
    }
}

@end
