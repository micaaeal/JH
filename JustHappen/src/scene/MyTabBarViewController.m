//
//  MyTabBarViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/10/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "MyTabBarViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setupNavBar{

    UIViewController* par = self.navigationController.parentViewController;
    NSLog(@"Parent is %@",[par class]);
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && 
        [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController 
                                                                                                            action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        // Create a containing view to position the button
        {
            UIImage* barButtonImage = [UIImage imageNamed:@"button_menu_b.png"];
            float offsetX = 5;
            UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barButtonImage.size.width + offsetX, barButtonImage.size.height)];
            
            // Create a custom button with the image
            UIButton *barUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [barUIButton setImage:barButtonImage forState:UIControlStateNormal];
            barUIButton.frame = CGRectMake(offsetX, 0, barButtonImage.size.width, barButtonImage.size.height);
            [barUIButton addTarget:self.navigationController.parentViewController  
                            action:@selector(revealToggle:) 
                  forControlEvents:UIControlEventTouchUpInside];
            
            [containingView addSubview:barUIButton];
            
            // Create a container bar button
            UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:containingView];
            
            // Add the container bar button
            self.navigationItem.rightBarButtonItem = containingBarButton;
        }

	}
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

@end
