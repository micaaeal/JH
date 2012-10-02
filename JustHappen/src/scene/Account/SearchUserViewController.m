//
//  SearchUserViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "SearchUserViewController.h"
#import "JHAppDelegate.h"
#import "DataManager.h"
#import "DataModel.h"
#import "TilesController.h"
#import "AccountViewController.h"

#define kSearchTextKey @"Search Text"

@interface SearchUserViewController ()
{
    NSMutableArray* _userList;
    
    UISearchBar* _searchBar;
    NSTimer* _searchTimer;
    JHAppDelegate* _JHAppDelegate;

}
@end

@implementation SearchUserViewController

@synthesize searchString = _searchString;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _userList = [[NSMutableArray alloc]init];
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (cell) {
        User* user = [_userList objectAtIndex:indexPath.row];
        cell.textLabel.text =  user.name;
        cell.imageView.image = [user getPhoto];    
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hide the search display controller and reset the search results
    [self.searchDisplayController setActive:NO animated:YES];
    
    [self performSegueWithIdentifier:@"SearchAccountSegue" sender:nil];
}

#pragma mark - Storyboard Segure

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow; 
    if ([segue.identifier isEqualToString:@"SearchAccountSegue"]) {
        AccountViewController *accountCtrl = (AccountViewController*)[segue destinationViewController];
        accountCtrl.user = [_userList objectAtIndex:indexPath.row];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)requestComplete:(id)data{
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray* userList = (NSArray*)data;
        if (userList.count > 0 && [[userList objectAtIndex:0] isKindOfClass:[User class]]) {
            
            [_userList removeAllObjects];
            [_userList addObjectsFromArray:[DataManager removeDuplicateUser:userList]];
            
            [self.searchDisplayController.searchResultsTableView reloadData];
            [self.tableView reloadData];
        }
    }
}

- (void) searchResultFromTimer:(NSTimer *)timer {
    
    //Search engine here.
    [_JHAppDelegate ASIHttpRequest_SearchUserWithText:_searchString viewController:self];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    NSLog(@"search end");
    
    [self.tableView reloadData];
}

-(void)searchWithKey:(NSString*)key{

    [self searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:key];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{

    _searchString = searchString;
    
    // Use a timer to only start geocoding when the user stops typing
    if ([_searchTimer isValid])
        [_searchTimer invalidate];
    
    const NSTimeInterval kSearchDelay = .25;
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:searchString
                                                          forKey:kSearchTextKey];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                    target:self
                                                  selector:@selector(searchResultFromTimer:)
                                                  userInfo:userInfo
                                                   repeats:NO];
    return YES;
}


@end
