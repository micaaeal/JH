//
//  UserListViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/29/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "UserListViewController.h"
#import "JHAppDelegate.h"
#import "DataModel.h"
#import "DataManager.h"
#import "TilesController.h"
#import "RevealController.h"
#import "AccountViewController.h"

@interface UserListViewController ()
{
    JHAppDelegate* _JHAppDelegate;
    
}
@end

@implementation UserListViewController

@synthesize userList = _userList;
@synthesize user = _user;

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

- (void)requestComplete:(id)data{
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray* userList = (NSArray*)data;
        if (userList.count > 0 && [[userList objectAtIndex:0] isKindOfClass:[User class]]) {

            self.userList = [NSArray arrayWithArray:[DataManager removeDuplicateUser:userList]];
            
            [self.tableView reloadData];
        }
    }
}

- (void) downloadUserListFinished:(NSArray*)list {
    
    if (list && list.count > 0) {
        
        list = [DataManager removeDuplicateUser:list];

        self.userList = [NSArray arrayWithArray:list];
        
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"Title: %@",self.navigationController.title);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FollowerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    User* user = [_userList objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.imageView.image = [user getPhoto];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [_user.userId isEqualToNumber:[DataManager sharedDataManager].user.userId];
}
 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray* arr = [[NSMutableArray alloc]initWithArray:_userList];
        User* unfollowUser = [arr objectAtIndex:indexPath.row];
    
        [arr removeObjectAtIndex:indexPath.row];
        
        self.userList = arr;  

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //
        [_JHAppDelegate ASIHttpRequest_UnfollowerWithUserId:[DataManager sharedDataManager].user.userId.stringValue 
                                                follower_id:unfollowUser.userId.stringValue 
                                             viewController:self];
    }      
}

#pragma mark - Storyboard Segure

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow; 
    if ([segue.identifier isEqualToString:@"AccountSegue"]) {
        AccountViewController *accountCtrl = (AccountViewController*)[segue destinationViewController];
        accountCtrl.user = [_userList objectAtIndex:indexPath.row];
        
        if ([accountCtrl.user.userId isEqualToNumber:[DataManager sharedDataManager].user.userId]) {
            //Return to first 
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
