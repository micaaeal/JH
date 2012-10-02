//
//  NotificationViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/3/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "NotificationViewController.h"
#import "JHAppDelegate.h"
#import "DataManager.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] &&
        [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
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
            self.navigationItem.leftBarButtonItem = containingBarButton;
        }
	}  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [DataManager sharedDataManager].adminMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray* data = [[DataManager sharedDataManager].adminMessage objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [data objectAtIndex:0];
    cell.detailTextLabel.text = [data objectAtIndex:1];
    
//    // Configure the cell...
//    switch (indexPath.row) {
//        case 0:
//        {
//            cell.textLabel.text = @"Thank you ,Welcome to JustHappen again!!";
//            cell.detailTextLabel.text = @"14 December 2012 (24:24:24)";
//        }
//            break;
//            
//        case 1:
//        {
//            cell.textLabel.text = @"We will close server for maintanen today 22.00 to 24.00";
//            cell.detailTextLabel.text = @"13 December 2012 (12:13:14)";
//        }
//            break;
//            
//        case 2:
//        {
//            cell.textLabel.text = @"Welcome to JustHappen!!";
//            cell.detailTextLabel.text = @"12 December 2012 (12:12:12)";
//        }
//            break;
//            
//        default:
//            break;
//    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
