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
