//
//  PopularListViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/13/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "PopularListViewController.h"
#import "DataModel.h"
#import "DataManager.h"
#import "AccountViewController.h"

@interface PopularListViewController ()

@end

@implementation PopularListViewController

@synthesize popularList;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Create a containing view to position the button
    {
        UIImage* barButtonImage = [UIImage imageNamed:@"button_menu_b.png"];
        float offsetX = 5;
        UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barButtonImage.size.width + offsetX, barButtonImage.size.height)];
        
        // Create a custom button with the image
        UIButton *barUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [barUIButton setImage:barButtonImage forState:UIControlStateNormal];
        barUIButton.frame = CGRectMake(offsetX, 0, barButtonImage.size.width, barButtonImage.size.height);
        [barUIButton addTarget:self
                        action:@selector(revealToggle:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [containingView addSubview:barUIButton];
        
        // Create a container bar button
        UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:containingView];
        
        // Add the container bar button
        self.navigationItem.rightBarButtonItem = containingBarButton;
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
    }
    //	}
}

- (void)revealToggle:(id)sender
{
    NSLog(@"reveal toggle");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REVEAL_MENU" object:Nil];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return popularList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    User* user = [popularList objectAtIndex:indexPath.row];
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.photoLink]]];
    cell.imageView.image = image;
    cell.textLabel.text = user.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"seguePopularListAccount" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"seguePopularListAccount"]) {
        NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow; 
        AccountViewController *accountCtrl = (AccountViewController*)[segue destinationViewController];
        User* user = [self.popularList objectAtIndex:indexPath.row];
        accountCtrl.user = user;
    }
}
@end
