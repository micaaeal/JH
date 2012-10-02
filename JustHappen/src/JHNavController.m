//
//  JHNavController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/17/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "JHNavController.h"

@interface JHNavController ()

@end

@implementation JHNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    //self.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navibar_bg.png"]];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    //[UIColor colorWithPatternImage:[UIImage imageNamed:@"navibar_bg.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
