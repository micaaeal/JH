//
//  JH"JHJHAppDelegate.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/20/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class MBProgressHUD;
@class RevealController;
@class MyTabBarViewController;

extern NSString *const SCSessionStateChangedNotification;

@interface JHAppDelegate : UIResponder <UIApplicationDelegate>

// FBSample logic
// The app delegate is responsible for maintaining the current FBSession. The application requires
// the user to be logged in to Facebook in order to do anything interesting -- if there is no valid
// FBSession, a login screen is displayed.
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;


@property (nonatomic, retain) MBProgressHUD* hud;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RevealController *revealViewController;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) MyTabBarViewController *myTabBarController;
@property (strong, nonatomic) UIViewController *settingViewController;
@property (strong, nonatomic) UIViewController *aboutViewController;
@property (strong, nonatomic) UIViewController *manageAccountViewController;
@property (strong, nonatomic) UIViewController *notificationViewController;

- (void)startLoginWithFacebookId:(NSString*)facebookId
                            name:(NSString*)name
                         surname:(NSString*)surname
                         country:(NSString*)country
                           email:(NSString*)email
                           photo:(NSString*)photo
                  viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_GetUserInfoWithFacebookId:(NSString*)facebookId
                                            name:(NSString*)name
                                         surname:(NSString*)surname
                                         country:(NSString*)country
                                           email:(NSString*)email
                                           photo:(NSString*)photo
                                  viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_GetUserInfoByUserId:(NSString*)userId viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_UpdateUserInfoWithFacebookId:(NSString*)facebookId
                                               name:(NSString*)name
                                            surname:(NSString*)surname
                                            country:(NSString*)country
                                              email:(NSString*)email
                                              photo:(UIImage*)photo
                                     viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_GetEntryListWithLati:(NSString*)lati
                                      longi:(NSString*)longi
                               min_distance:(NSString*)min_distance
                               max_distance:(NSString*)max_distance
                                   min_date:(NSString*)min_date
                                   max_date:(NSString*)max_date
                                   category:(NSString*)category
                             viewController:(UIViewController*)viewController;


- (void)ASIHttpRequest_NewEntryListWithUserId:(NSString*)user_id
                                   categories:(NSString*)categories
                                       detail:(NSString*)detail
                                        photo:(UIImage*)photo
                               facebook_place:(NSString*)facebook_place
                                   place_name:(NSString*)place_name
                                         lati:(NSString*)lati
                                        longi:(NSString*)longi
                               viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_GetCategoryViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetPopularViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetFollowerWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetFollowingWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetUserEntryListWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetFollowingEntryListWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_AddFollowingWithUserId:(NSString*)user_id following_id:(NSString*)following_id viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_SearchUserWithText:(NSString*)text viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_SearchPlaceWithText:(NSString*)text viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_SearchEntryWithText:(NSString*)text viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_UserIndexViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_PlaceIndexViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_EntryIndexViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_CommentEntryWithUserId:(NSString*)user_id
                                     entry_id:(NSString*)entry_id
                                      comment:(NSString*)comment
                               viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_LikeEntryWithUserId:(NSString*)user_id
                                  entry_id:(NSString*)entry_id
                            viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetAdminMessageViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetMedalViewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_GetCommentEntryWithEntryId:(NSString*)entryId viewController:(UIViewController*)viewController;

- (void)ASIHttpRequest_ShareEntryWithUserId:(NSString*)user_id
                                   entry_id:(NSString*)entry_id
                             viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_UnfollowerWithUserId:(NSString*)user_id
                                follower_id:(NSString*)follower_id
                             viewController:(UIViewController*)viewController;
- (void)ASIHttpRequest_IsLikeWithUserId:(NSString*)user_id
                               entry_id:(NSString*)entry_id
                         viewController:(UIViewController*)viewController;

-(void)hideHud;
-(void)showHud;
@end
