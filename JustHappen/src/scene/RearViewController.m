/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "RearViewController.h"

#import <FacebookSDK/FacebookSDK.h>

#import "RevealController.h"
#import "MyTabBarViewController.h"

#import "AboutViewController.h"
#import "SettingViewController.h"
#import "NotificationViewController.h"
#import "AccountViewController.h"
#import "UserListViewController.h"

#import "JHAppDelegate.h"

#import "SearchUserViewController.h"

#import "ManageAccountViewController.h"

#import "DataManager.h"
#import "DataModel.h"

#define kSearchTextKey @"Search Text"

@interface RearViewController() <FBLoginViewDelegate>
{
    RevealController* _revealController;
    JHAppDelegate* _delegate;
    
    NSString* _searchString;
    NSTimer* _searchTimer;
}

@property (nonatomic,retain) NSArray* searchResultArray;

@end

@implementation RearViewController
@synthesize isSearching = _isSearching;
@synthesize searchResultArray = _searchResultArray;
@synthesize rearTableView = _rearTableView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // set up ivars and other stuff here.
        _isSearching = NO;
        self.searchResultArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)viewDidLoad{
    
    _delegate = (JHAppDelegate*)[UIApplication sharedApplication].delegate;
    
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    _revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    self.rearTableView.backgroundColor = [UIColor darkGrayColor];
}

#pragma marl - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearching && self.searchResultArray) {
        return 1;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearching && self.searchResultArray) {
        return self.searchResultArray.count;
    }
    
    if (section==0)return 1;
    if (section==1)return 2;
    if (section==2)return 2;
	return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}

    // Configure the cell...
    if (_isSearching) {
        if (cell) {
            User* user = [_searchResultArray objectAtIndex:indexPath.row];
            cell.textLabel.text =  user.name;
            cell.imageView.image = [user getPhoto];    
            
        }
        return cell;
    }

    if (_isSearching && self.searchResultArray) {
        return cell;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            User* user = [DataManager sharedDataManager].user;
            NSString* str = @"User name";
            
            if (user) {
                str = [NSString stringWithFormat:@"%@ %@",user.name,user.surname];
            }
            
            cell.textLabel.text = str;
            NSLog(@"user.photoLink = %@",user.photoLink);
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.photoLink]]];
        }

    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Manage Account";
            cell.imageView.image = [UIImage imageNamed:@"menu_icon_manage.png"];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Notification";
//            UISwitch* mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(180, 8, 30, 30)];
//            [cell addSubview:mSwitch];
            cell.imageView.image = [UIImage imageNamed:@"menu_icon_notification.png"];
        }

    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Setting";
            cell.imageView.image = [UIImage imageNamed:@"menu_icon_setting.png"];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Logout";
            cell.imageView.image = [UIImage imageNamed:@"menu_icon_logout.png"];
        }
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"About";
            cell.imageView.image = [UIImage imageNamed:@"menu_icon_about.png"];
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_box_a.png"]];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController.searchBar resignFirstResponder];
    
    if (_isSearching && tableView == self.searchDisplayController.searchResultsTableView) {
        
        //MAIN APP / PROFILE
        if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
            ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[MyTabBarViewController class]])
        {
            UINavigationController* navCtrl = _delegate.navController;
            [_revealController setFrontViewController:navCtrl animated:NO];
        }
        else
        {
            [_revealController revealToggle:self];
        }
        
        //Point to ProfileAccount..
        [_delegate.myTabBarController setSelectedIndex:3];
        UINavigationController* nav = (UINavigationController*)[_delegate.myTabBarController selectedViewController];
        AccountViewController* accView = (AccountViewController*)[nav.viewControllers objectAtIndex:0];
        [accView openPageForUser:[_searchResultArray objectAtIndex:indexPath.row]];

        return;
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            //MAIN APP / PROFILE
            if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
                ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[MyTabBarViewController class]])
            {
                UINavigationController* navCtrl = _delegate.navController;
                [_revealController setFrontViewController:navCtrl animated:NO];
            }
            else
            {
                [_revealController revealToggle:self];
            }
            
            //Point to ProfileAccount..
            [_delegate.myTabBarController setSelectedIndex:3];
        }
    }
    else  if (indexPath.section == 1) {
        if (indexPath.row == 0)
        {
            //MANAGE ACCOUNT
            if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
                ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[ManageAccountViewController class]])
            {
                UINavigationController* navCtrl = (UINavigationController*)_delegate.manageAccountViewController;
                [_revealController setFrontViewController:navCtrl animated:NO];
            }
            else
            {
                [_revealController revealToggle:self];
            }
        }
        else if (indexPath.row == 1)
        {
            //NOTIFICATION
            if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
                ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[NotificationViewController class]])
            {
                UINavigationController* navCtrl = (UINavigationController*)_delegate.notificationViewController;
                [_revealController setFrontViewController:navCtrl animated:NO];
            }
            else
            {
                [_revealController revealToggle:self];
            }
        }
    }
    else  if (indexPath.section == 2) {
        if (indexPath.row == 0)
        {
            //SETTING
            if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
                ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[SettingViewController class]])
            {
                UINavigationController* navCtrl = (UINavigationController*)_delegate.settingViewController;
                [_revealController setFrontViewController:navCtrl animated:NO];
            }
            else
            {
                [_revealController revealToggle:self];
            }
        }
        else if (indexPath.row == 1)
        {
            
            //SET TO NORMAL SCENE!!!
            if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
                ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[MyTabBarViewController class]])
            {
                UINavigationController* navCtrl = _delegate.navController;
                [_revealController setFrontViewController:navCtrl animated:NO];
            }
            else
            {
                [_revealController revealToggle:self];
            }
            
            //Point to ProfileAccount..
            [_delegate.myTabBarController setSelectedIndex:3];

            //LOGOUT
            NSLog(@"Logout!");
            [FBSession.activeSession closeAndClearTokenInformation];  
        }
    }else  if (indexPath.section == 3) {
        
        //ABOUT
        if ([_revealController.frontViewController isKindOfClass:[UINavigationController class]] && 
            ![((UINavigationController *)_revealController.frontViewController).topViewController isKindOfClass:[AboutViewController class]])
        {
            UINavigationController* navCtrl = (UINavigationController*)_delegate.aboutViewController;
            [_revealController setFrontViewController:navCtrl animated:NO];
        }
        else
        {
            [_revealController revealToggle:self];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    _isSearching = YES;
}

- (void)requestComplete:(id)data{
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray* userList = (NSArray*)data;
        if (userList.count > 0 && [[userList objectAtIndex:0] isKindOfClass:[User class]]) {
            
            self.searchResultArray = [DataManager removeDuplicateUser:userList];

            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }
}

- (void) searchResultFromTimer:(NSTimer *)timer {
    
    //Search engine here.
    [[DataManager getDelegate] ASIHttpRequest_SearchUserWithText:_searchString viewController:self];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    NSLog(@"search end");
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
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:searchString forKey:kSearchTextKey];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                    target:self
                                                  selector:@selector(searchResultFromTimer:)
                                                  userInfo:userInfo
                                                   repeats:NO];
    return YES;
}


#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    [_revealController hideFrontView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_revealController showFrontViewCompletely:NO];
    
    _isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

@end