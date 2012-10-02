//
//  CommentViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/3/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "JHAppDelegate.h"
#import "DataManager.h"
#import "DataModel.h"

@interface CommentViewController ()
{
    JHAppDelegate* _JHAppDelegate;
    NSMutableArray* _commentList;
}
@end

@implementation CommentViewController
@synthesize commentTextField = _commentTextField;

@synthesize entry = _entry;


- (IBAction)addButtonTouchUpInside:(id)sender {
    NSLog(@"Add New Comment!");
    
    if (_commentTextField.text.length > 0) {
        User* user = [DataManager sharedDataManager].user;
        [_JHAppDelegate ASIHttpRequest_CommentEntryWithUserId:user.userId.stringValue entry_id:_entry.entryId.stringValue comment:_commentTextField.text viewController:self];
    }
    
}

#pragma mark - TableViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        _commentList = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)reloadCommentList{

    [_JHAppDelegate ASIHttpRequest_GetCommentEntryWithEntryId:_entry.entryId.stringValue viewController:self];
}

- (void)addCommentComplete{
    [self reloadCommentList];
}

- (void)downLoadCommentComplete:(NSArray*)commentList{
    
    if (_commentList != commentList) {
        [_commentList removeAllObjects];
        [_commentList addObjectsFromArray:commentList];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self reloadCommentList];
}

- (void)viewDidUnload
{
    [self setCommentTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return _commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.section==0) {
        
        //Input cell
        static NSString *CellIdentifier = @"InputCommentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.commentTextField = (UITextField*)[cell viewWithTag:1];

        return cell;
    }
    else {
        
        //Comment cell
        static NSString *CellIdentifier = @"CommentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        Comment* comment = [_commentList objectAtIndex:indexPath.row];
        cell.textLabel.text = comment.detail;
        cell.detailTextLabel.text = comment.commentName;
        
        return cell;
    }
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
