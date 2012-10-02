//
//  AccountViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/29/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"

#import <FacebookSDK/FacebookSDK.h>

#import "DataManager.h"
#import "DataModel.h"
#import "JHAppDelegate.h"
#import "UserListViewController.h"
#import "TilesController.h"
#import "RevealController.h"
#import "DVSlideViewController.h"
#import "SearchUserViewController.h"

@interface AccountViewController ()
{
    JHAppDelegate* _JHAppDelegate;
}

@property (nonatomic,retain) NSString* fbPhotoLink;
@property (nonatomic,retain) NSString* fbPlaceName;
@property (strong, nonatomic) IBOutlet UILabel *userAddress;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userInAppPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnFollow;
@property (strong, nonatomic) IBOutlet UILabel *lblMedal;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowing;
@property (strong, nonatomic) IBOutlet UILabel *lblFollower;

@end

@implementation AccountViewController

@synthesize fbPhotoLink = _fbPhotoLink;
@synthesize fbPlaceName = _fbPlaceName;
@synthesize segment = _segment;
@synthesize user = _user;
@synthesize userAddress = _userAddress;
@synthesize userName = _userName;
@synthesize userInAppPhoto = _userInAppPhoto;
@synthesize btnFollow;

#pragma mark -

- (void)populateUserDetails {
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 self.userName.text = user.name;
                 
                 if (user.location) {
                     id<FBGraphPlace> place = user.location;
                     
                     if (![place.id isEqualToString:@""]) {
                         self.fbPlaceName = place.name;
                         self.userAddress.text = place.name;
                     }
                 }

                 self.fbPhotoLink = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",user.username];

                 [_JHAppDelegate startLoginWithFacebookId:user.id 
                                                     name:user.first_name 
                                                  surname:user.last_name 
                                                  country:_fbPlaceName
                                                    email:user.username 
                                                    photo:_fbPhotoLink
                                           viewController:self];
                 
                 [_JHAppDelegate hideHud]; 
             }
             
         }];      
    }
}

#pragma mark -

-(void)setButtonText:(UIButton*)button text:(NSString*)text{
    
    if ([text isEqualToString:@"Follow"]) {
        [button setBackgroundImage:[UIImage imageNamed:@"button_follow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_follow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_follow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_follow_a.png"] forState:UIControlStateNormal];
    }else{
        
        [button setBackgroundImage:[UIImage imageNamed:@"button_unfollow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_unfollow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_unfollow_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_unfollow_a.png"] forState:UIControlStateNormal];
    }
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button setTitle:text forState:UIControlStateDisabled];
    [button setTitle:text forState:UIControlStateSelected];
    
    button.titleLabel.textAlignment = UITextAlignmentCenter;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_user==nil) {
        
        // LOGIN FIRST TIME
        _user = [DataManager sharedDataManager].user;
 
        if (FBSession.activeSession.isOpen) {
            [_JHAppDelegate showHud]; 
            [self populateUserDetails];
        }

        //No follow button if yourself
        [btnFollow removeFromSuperview];
    }
    else{
        
        if ([_user.userId isEqualToNumber:[DataManager sharedDataManager].user.userId]) {
    
            // ALREADY LOGIN - UPDATE IT!
            _user = [DataManager sharedDataManager].user;
        }
        else{

            if ([DataManager isUser:_user InUserList:[DataManager sharedDataManager].followingList]) {


                [self setButtonText:btnFollow text:@"Unfollow"];
                
            }else {

                [self setButtonText:btnFollow text:@"Follow"];
            }
        }
    }
    
    if (_user){
        
        self.userName.text = _user.name;
        self.userAddress.text = _user.country;
        
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_user.photoLink]]];
        
        if (img) {
            
            self.userInAppPhoto.image = img;
        }
        
        self.lblMedal.text = [NSString stringWithFormat:@"%d",_user.medal.count];
        self.lblFollower.text = [NSString stringWithFormat:@"%d",_user.follower.intValue];
        self.lblFollowing.text = [NSString stringWithFormat:@"%d",_user.following.intValue];
        
        [self getUserEntryListWithUserId:_user.userId.stringValue];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];   
}

- (void)viewDidUnload{
    
    [self setUserName:nil];
    [self setUserAddress:nil];
    
    [self setUserInAppPhoto:nil];
    [self setBtnFollow:nil];
    [self setSegment:nil];
    [self setLblMedal:nil];
    [self setLblFollowing:nil];
    [self setLblFollower:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"viewUserSegue"]) {
        
        NSLog(@"test");
        
        UserListViewController *followerView = (UserListViewController*)[segue destinationViewController];
        followerView.user = self.user;
        followerView.userList = (NSArray*)sender;
        
        //Set title depend on Section selected
        switch (self.segment.selectedSegmentIndex) {

            case 1:
                followerView.title = @"Follower";
                break;
                
            case 2:
                followerView.title = @"Following";
                break;
                
            default:
                break;
        }
    }
    else if([segue.identifier isEqualToString:@"SearchUserSegue"]){
        
        NSString* searchString = (NSString*)sender; 
        
        SearchUserViewController *searchView = (SearchUserViewController*)[segue destinationViewController];
        
        [searchView performSelector:@selector(searchWithKey:)withObject:searchString];
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Button

- (void)requestComplete:(id)data{

    //For follower,following list
    if ([data isKindOfClass:[NSArray class]]) {

        NSArray* userList = (NSArray*)data;
        
        if (userList.count == 0)return;
        if ([[userList objectAtIndex:0] isKindOfClass:[User class]]) {

            [self performSegueWithIdentifier:@"viewUserSegue" sender:userList];
            return;
        }
    }
    
    //For startLoginWithFacebook
    if ([data isKindOfClass:[User class]]) {
        
        User* user = (User*)data;
        [DataManager sharedDataManager].user = user;
        

        
        if (user.photoLink.length < 5 && _fbPhotoLink)
        {
            UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_fbPhotoLink]]];
            
            if (img) {
                
                self.userInAppPhoto.image = img;
            }
            
            [_JHAppDelegate ASIHttpRequest_UpdateUserInfoWithFacebookId:user.facebookId 
                                                                   name:user.name 
                                                                surname:user.surname 
                                                                country:_fbPlaceName
                                                                  email:user.email 
                                                                  photo:self.userInAppPhoto.image
                                                         viewController:self];
        }
        else{
            UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.photoLink]]];
            
            if (img) {
                
                self.userInAppPhoto.image = img;
            }
        }
        
        self.lblMedal.text = [NSString stringWithFormat:@"%d",user.medal.count];
        self.lblFollower.text = [NSString stringWithFormat:@"%d",user.follower.intValue];
        self.lblFollowing.text = [NSString stringWithFormat:@"%d",user.following.intValue];
        
        return;
    }

    //For display tiles...
    if ([DataManager sharedDataManager].user==_user) {
        NSLog(@"ME");
        
        if (!data) {
            [super getUserEntryListWithUserId:[DataManager sharedDataManager].user.userId.stringValue];
        }
        else {
            [super requestComplete:data];
        }
    }
    else {
        NSLog(@"Other...");
        
        if (!data) {
            [super getUserEntryListWithUserId:_user.userId.stringValue];
        }
        else {
            [super requestComplete:data];
        }
    }
}

- (IBAction)btnFollowTouchUpInside:(id)sender {

    UIButton* button = (UIButton*)sender;
    NSLog(@"Button label = %@",button.titleLabel.text);
    
    if ([button.titleLabel.text isEqualToString:@"Follow"]) {
        
        //Follow
        [_JHAppDelegate ASIHttpRequest_AddFollowingWithUserId:[DataManager sharedDataManager].user.userId.stringValue 
                                                 following_id:_user.userId.stringValue
                                               viewController:self];
        
        [DataManager addFollowingByUser:_user];
        [[DataManager sharedDataManager].followingList addObject:_user];
    }
    else {
        
        //Unfollow
        [_JHAppDelegate ASIHttpRequest_UnfollowerWithUserId:[DataManager sharedDataManager].user.userId.stringValue 
                                                follower_id:_user.userId.stringValue
                                             viewController:self];
        
        [DataManager removeFollowingByUserId:_user.userId.stringValue];
    }
    
    if ([btnFollow.titleLabel.text isEqualToString:@"Follow"]) {
        [self setButtonText:btnFollow text:@"Unfollow"];
    }
    else {
        [self setButtonText:btnFollow text:@"Follow"];
    }
}

#pragma mark - 

- (IBAction)segmentValueChanged:(UISegmentedControl *)segment {
    
    NSLog(@"%d",segment.selectedSegmentIndex);
    
    if (segment.selectedSegmentIndex==0) {
        
        [self performSegueWithIdentifier:@"viewMedalSegue" sender:self];
    }
    
    if (segment.selectedSegmentIndex==2) {
        
        [_JHAppDelegate ASIHttpRequest_GetFollowerWithUserId:_user.userId.stringValue viewController:self];
    }
    
    if (segment.selectedSegmentIndex==1) {
        
        [_JHAppDelegate ASIHttpRequest_GetFollowingWithUserId:_user.userId.stringValue viewController:self];
    }
    
    [segment setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(void)searchBeginWithKey:(NSString*)key{
    [self performSegueWithIdentifier:@"SearchUserSegue" sender:key];
}

#pragma mark - Open new page

-(void)openPageForUser:(User*)user{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
     AccountViewController *controller = (AccountViewController*)[mainStoryboard 
                                                       instantiateViewControllerWithIdentifier: @"TileAccountController"];
    controller.user = user;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
