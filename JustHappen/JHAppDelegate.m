//
//  JHAppDelegate.m
//  JustHappen
//
//  Created by Ray Wenderlich on 2/16/12.
//  Copyright (c) 2012 Tontanii-Studio. All rights reserved.
//

#import "JHAppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
#import "DataManager.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#import "MapViewController.h"
#import "TilesController.h"
#import "CreateEventViewController.h"
#import "AccountViewController.h"
#import "SearchUserViewController.h"
#import "UserListViewController.h"
#import "CommentViewController.h"

#import "RevealController.h"
#import "MyTabBarViewController.h"
#import "RearViewController.h"

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "NotificationViewController.h"

#import "SCLoginViewController.h"

#import "GDataXMLNode.h"
#import "DVSlideViewController.h"

#import "ManageAccountViewController.h"

#import "iTellAFriend.h"

#import "JHNavController.h"

NSString *const SCSessionStateChangedNotification = @"com.facebook.JustHappen:SCSessionStateChangedNotification";

#define GET_USER_INFO_BY_ID           @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getuserinfo_byuserid.php"
#define GET_USER_INFO               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getuserinfo.php"
#define UPDATE_USER_INFO            @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/updateuserinfo.php"
#define GET_ENTRY_LIST              @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getentrylist.php"
#define ADD_NEW_ENTRY               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/addnewentry.php"
#define GET_CATEGORY                @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getcategory.php"
#define GET_POPULAR                 @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getpopular.php"
#define GET_FOLLOWER                @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getfollower.php"
#define GET_FOLLOWING               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getfollowing.php"
#define GET_USER_ENTRY_LIST         @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getuserentry.php"
#define GET_FOLLOWING_ENTRY_LIST    @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getfollowingentrylist.php"
#define ADD_FOLLOWING               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/addfollowing.php"
#define SEARCH_USER                 @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/searchuser.php"
#define SEARCH_PLACE                @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/searchplace.php"
#define SEARCH_ENTRY                @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/searchentry.php"
#define USER_INDEX                  @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/userindex.php"
#define PLACE_INDEX                 @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/placeindex.php"
#define ENTRY_INDEX                 @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/entryindex.php"
#define ADD_COMMENT_ENTRY           @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/commententry.php"
#define LIKE_ENTRY                  @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/likeentry.php"
#define GET_ADMIN_MESSAGE           @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getadminmessage.php"
#define GET_MEDAL                   @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getmedal.php"
#define GET_COMMENT_ENTRY           @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/getCommentEntry.php"

#define SHARE_ENTRY                 @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/shareentry.php"
#define UNFOLLOW_USER               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/unfollow.php"
#define IS_LIKE_ENTRY               @"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/isLike.php"

enum{
    kGET_USER_INFO = 1,
    kUPDATE_USER_INFO,
    kGET_ENTRY_LIST,
    kADD_NEW_ENTRY,
    kGET_CATEGORY,
    kGET_POPULAR,
    kGET_FOLLOWER,
    kGET_FOLLOWING,
    kGET_USER_ENTRY_LIST,
    kGET_FOLLOWING_ENTRY_LIST,
    kADD_FOLLOWING,
    kSEARCH_USER,
    kSEARCH_PLACE,
    kSEARCH_ENTRY,
    kUSER_INDEX,
    kPLACE_INDEX,
    kENTRY_INDEX,
    kADD_COMMENT_ENTRY,
    kLIKE_ENTRY,
    kGET_ADMIN_MESSAGE,
    kGET_MEDAL,
    kGET_COMMENT_ENTRY,
    
    kSHARE_ENTRY,
    kUNFOLLOW_USER,
    kIS_LIKE_ENTRY,
};

@interface JHAppDelegate ()
{
    int _loggingIn;
    UIViewController* _targetViewController;
}

@end

@implementation JHAppDelegate

@synthesize revealViewController = _revealViewController;

@synthesize navController = _navController;
@synthesize myTabBarController = _myTabBarController;
@synthesize settingViewController = _settingViewController;
@synthesize aboutViewController = _aboutViewController;
@synthesize manageAccountViewController = _manageAccountViewController;
@synthesize notificationViewController = _notificationViewController;
@synthesize hud = _hud;
@synthesize window = _window;

#pragma mark -

- (BOOL)isNotGregorian{
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSArray *values = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues];
    for (int i = 0; i < keys.count; i++) {
        NSLog(@"%@: %@", [keys objectAtIndex:i], [values objectAtIndex:i]);
    }
    
    NSString* appLocale = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLocale"];
    NSLog(@"AppleLocale %@",appLocale);

    NSArray *listItems = [appLocale componentsSeparatedByString:@"@"];
    if (listItems==0) return NO;
    
    if (listItems.count > 1) {
        NSLog(@"olo");
    }
    else {
        NSString* str = [listItems objectAtIndex:0];
        if ([str isEqualToString:@"th_TH"]) {
            
            return YES;
        }
    }
    
    return NO;
}

- (void)startLoginWithFacebookId:(NSString*)facebookId
                            name:(NSString*)name
                         surname:(NSString*)surname
                         country:(NSString*)country
                           email:(NSString*)email
                           photo:(NSString*)photo
                  viewController:(UIViewController*)viewController{
    
    if (_loggingIn==0) {
        
       // [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; //DISABLE ALL INPUT
        
        [self ASIHttpRequest_GetUserInfoWithFacebookId:facebookId 
                                                  name:name 
                                               surname:surname 
                                               country:country 
                                                 email:email 
                                                 photo:photo 
                                        viewController:viewController];
        
        _loggingIn = 4;
        [self checkLoginProcess:viewController];
    }
}

- (void)checkLoginProcess:(UIViewController*)viewController{
    
    switch (_loggingIn) {
        case 0:
        {
            //[[UIApplication sharedApplication] endIgnoringInteractionEvents]; //ENABLE ALL INPUT
            
            NSLog(@"Prepare data finish.");
            
            AccountViewController* accountCtrl = (AccountViewController*)viewController;
            if ([accountCtrl isKindOfClass:[AccountViewController class]]) {
                accountCtrl.user = [DataManager sharedDataManager].user;
                [accountCtrl.tableView reloadData];
            }
            
            [viewController performSelector:@selector(requestComplete:) withObject:nil];
        }
            break;
            
        case 1:[self ASIHttpRequest_GetCategoryViewController:viewController];
            break;
            
        case 2:[self ASIHttpRequest_GetAdminMessageViewController:viewController];
            break;
            
        case 3:[self ASIHttpRequest_GetMedalViewController:viewController];
            break;
    }
    _loggingIn--;
}

#pragma mark - ASIHttpRequest

- (void)pasteDataByRequestTag:(int)tag andData:(NSData*)xmlData viewController:(UIViewController*)viewController{
    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
                                                           options:0 error:&error];
    if (doc == nil){
        NSLog(@"GDataXMLDocument is empty!");
        return;
    }
    
    NSLog(@"XML DATA > [ %@ ] <", doc.rootElement);   
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    switch (tag) {
            
        case kGET_USER_INFO:
        {
            GDataXMLElement* theUser = doc.rootElement;
            
            NSArray* medal = [theUser elementsForName:@"medal"];
            NSMutableArray* myMedals = [[NSMutableArray alloc]init];
            
            for (GDataXMLElement* theMedal in medal) {
                Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[theMedal attributeForName:@"id"].stringValue]
                                                     name:[theMedal attributeForName:@"name"].stringValue image:[theMedal attributeForName:@"image"].stringValue];
                [myMedals addObject:myMedal];
            }
            
            User* myUser = [[User alloc]initWithFacebookId:[theUser attributeForName:@"facebook_id"].stringValue 
                                                    userId:[f numberFromString:[theUser attributeForName:@"user_id"].stringValue] 
                                                      name:[theUser attributeForName:@"name"].stringValue
                                                   surname:[theUser attributeForName:@"surname"].stringValue
                                                   country:[theUser attributeForName:@"country"].stringValue 
                                                     email:[theUser attributeForName:@"email"].stringValue 
                                                  follower:[f numberFromString:[theUser attributeForName:@"follower"].stringValue]  
                                                 following:[f numberFromString:[theUser attributeForName:@"following"].stringValue]  
                                                 photoLink:[theUser attributeForName:@"photo"].stringValue 
                                                     medal:myMedals];

            [viewController performSelector:@selector(requestComplete:) withObject:myUser];
            
        }break;
            
        case kUPDATE_USER_INFO:
        {
            GDataXMLElement* theUser = doc.rootElement;
            
            NSArray* medal = [theUser elementsForName:@"medal"];
            NSMutableArray* myMedals = [[NSMutableArray alloc]init];
            
            for (GDataXMLElement* theMedal in medal) {
                Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[theMedal attributeForName:@"id"].stringValue]
                                                     name:[theMedal attributeForName:@"name"].stringValue image:[theMedal attributeForName:@"image"].stringValue];
                [myMedals addObject:myMedal];
            }
            
            User* myUser = [[User alloc]initWithFacebookId:[theUser attributeForName:@"facebook_id"].stringValue 
                                                    userId:[f numberFromString:[theUser attributeForName:@"user_id"].stringValue] 
                                                      name:[theUser attributeForName:@"name"].stringValue
                                                   surname:[theUser attributeForName:@"surname"].stringValue
                                                   country:[theUser attributeForName:@"country"].stringValue 
                                                     email:[theUser attributeForName:@"email"].stringValue 
                                                  follower:[f numberFromString:[theUser attributeForName:@"follower"].stringValue]  
                                                 following:[f numberFromString:[theUser attributeForName:@"following"].stringValue]  
                                                 photoLink:[theUser attributeForName:@"photo"].stringValue 
                                                     medal:myMedals];
            
            [DataManager sharedDataManager].user = myUser;
            
            [viewController performSelector:@selector(requestComplete:) withObject:myUser];
            
        }break;
            
        case kSEARCH_ENTRY:
        case kGET_ENTRY_LIST:
        case kGET_USER_ENTRY_LIST:
        {
            NSArray *list = [doc.rootElement elementsForName:@"entry"];
            NSMutableArray* myEntryList = [[NSMutableArray alloc]init];
            NSMutableArray* placeList = [[NSMutableArray alloc]init];
            for (GDataXMLElement* element in list) {
                
                GDataXMLNode*  entry_id = [element attributeForName:@"entry_id"];
                GDataXMLNode*  owner_id = [element attributeForName:@"owner_id"];
                GDataXMLNode*  category_id = [element attributeForName:@"category_id"];
                GDataXMLNode*  photo = [element attributeForName:@"photo"];
                GDataXMLNode*  detail = [element attributeForName:@"detail"];
                GDataXMLNode*  datetime = [element attributeForName:@"datetime"];
                GDataXMLNode*  place_facebook_id = [element attributeForName:@"place_facebook_id"];
                
                NSArray* places = [element elementsForName:@"place"];
                
                for (GDataXMLElement* placeNode in places) {
                    
                    GDataXMLNode*  place_id = [placeNode attributeForName:@"id"];
                    GDataXMLNode*  facebook_id = [placeNode attributeForName:@"facebook_id"];
                    GDataXMLNode*  name = [placeNode attributeForName:@"name"];
                    GDataXMLNode*  lati = [placeNode attributeForName:@"lat"];
                    GDataXMLNode*  longi = [placeNode attributeForName:@"long"];
                    
                    Place* place = [[Place alloc]initWithId:[f numberFromString:place_id.stringValue] 
                                            facebookPlaceId:facebook_id.stringValue
                                                       name:name.stringValue
                                                       lati:[f numberFromString:lati.stringValue] 
                                                      longi:[f numberFromString:longi.stringValue]];
                    [placeList addObject:place];
                    
                }
                
                Entry* myEntry = [[Entry alloc]initWithOwnerId:[f numberFromString:owner_id.stringValue]
                                                    categoryId:[f numberFromString:category_id.stringValue]  
                                                       entryId:[f numberFromString:entry_id.stringValue]  
                                                     photoLink:photo.stringValue
                                                        detail:detail.stringValue
                                                      dateTime:[DataManager convNSStringToNSDate:datetime.stringValue] 
                                                       placeId:place_facebook_id.stringValue ];
                

                [myEntryList addObject:myEntry];
            }
            
            [[DataManager sharedDataManager] addPlaceList:placeList];
            [viewController performSelector:@selector(requestComplete:) withObject:myEntryList];
            
        }break;
            
        case kADD_NEW_ENTRY:
        {   
            GDataXMLElement* element = doc.rootElement;
            NSString* link = [element attributeForName:@"reserved"].stringValue;
            
            
            
            [viewController performSelector:@selector(uploadEntryFinished:) withObject:link];
            
        }break;
            
        case kGET_CATEGORY:
        {
            if ([DataManager sharedDataManager].categoryList.count==0) {
                
                NSArray *list = [doc.rootElement elementsForName:@"category"];
                
                for (GDataXMLElement* element in list) {
                    
                    Category* myCategory = [[Category alloc]initWithId:[f numberFromString:[element attributeForName:@"id"].stringValue]
                                                                  name:[element attributeForName:@"name"].stringValue];
                    [[DataManager sharedDataManager].categoryList addObject:myCategory];
                }
            }
            
        }break;
            
        case kGET_POPULAR:
        {
            
            NSMutableArray* popularCategories = [[NSMutableArray alloc]init];
            NSArray *popularList = [doc.rootElement elementsForName:@"popular_category"];
            
            for (GDataXMLElement* popularElement in popularList) {
                
                NSString* categoryId = [popularElement attributeForName:@"category_id"].stringValue;
                NSLog(@"category_id = %@",categoryId);
                
                NSArray *list = [popularElement elementsForName:@"user"];
                NSMutableArray* userList = [[NSMutableArray alloc]init];
                
                for (GDataXMLElement* element in list) {
                    
                    
                    
                    NSArray* medal = [element elementsForName:@"medal"];
                    NSMutableArray* myMedals = [[NSMutableArray alloc]init];
                    
                    for (GDataXMLElement* theMedal in medal) {
                        Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[theMedal attributeForName:@"id"].stringValue]
                                                             name:[theMedal attributeForName:@"name"].stringValue image:[theMedal attributeForName:@"image"].stringValue];
                        [myMedals addObject:myMedal];
                    }
                    
                    User* theUser = [[User alloc]initWithFacebookId:[element attributeForName:@"facebook_id"].stringValue 
                                                             userId:[f numberFromString:[element attributeForName:@"user_id"].stringValue] 
                                                               name:[element attributeForName:@"name"].stringValue
                                                            surname:[element attributeForName:@"surname"].stringValue
                                                            country:[element attributeForName:@"country"].stringValue 
                                                              email:[element attributeForName:@"email"].stringValue 
                                                           follower:[f numberFromString:[element attributeForName:@"follower"].stringValue]  
                                                          following:[f numberFromString:[element attributeForName:@"following"].stringValue]  
                                                          photoLink:[element attributeForName:@"photo"].stringValue 
                                                              medal:myMedals];
                    
                    [userList addObject:theUser];
                }
                
                PopularCategory* popCat = [[PopularCategory alloc]initWithCategoryId:categoryId userList:userList];
                [popularCategories addObject:popCat];
            }
            
            [viewController performSelector:@selector(requestComplete:) withObject:popularCategories];
            
        
        }break;
            
        case kGET_FOLLOWER:
        case kGET_FOLLOWING:
        {
            NSMutableArray* userList = [[NSMutableArray alloc]init];
            NSArray *list = [doc.rootElement elementsForName:@"user"];
            
            for (GDataXMLElement* element in list) {
                
                NSArray* medal = [element elementsForName:@"medal"];
                NSMutableArray* myMedals = [[NSMutableArray alloc]init];
                
                for (GDataXMLElement* theMedal in medal) {
                    Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[theMedal attributeForName:@"id"].stringValue]
                                                         name:[theMedal attributeForName:@"name"].stringValue image:[theMedal attributeForName:@"image"].stringValue];
                    [myMedals addObject:myMedal];
                }
                
                
                User* theUser = [[User alloc]initWithFacebookId:[element attributeForName:@"facebook_id"].stringValue 
                                                         userId:[f numberFromString:[element attributeForName:@"user_id"].stringValue] 
                                                           name:[element attributeForName:@"name"].stringValue
                                                        surname:[element attributeForName:@"surname"].stringValue
                                                        country:[element attributeForName:@"country"].stringValue 
                                                          email:[element attributeForName:@"email"].stringValue 
                                                       follower:[f numberFromString:[element attributeForName:@"follower"].stringValue]  
                                                      following:[f numberFromString:[element attributeForName:@"following"].stringValue]  
                                                      photoLink:[element attributeForName:@"photo"].stringValue 
                                                          medal:myMedals];
                
                [userList addObject:theUser];
            }
            
            // Remove same user id
            userList = [DataManager removeDuplicateUser:userList];
            
            if (tag==kGET_FOLLOWER) {
                [[DataManager sharedDataManager].followerList removeAllObjects];
                [[DataManager sharedDataManager].followerList addObjectsFromArray:userList];
            }
            else{
                [[DataManager sharedDataManager].followingList removeAllObjects];
                [[DataManager sharedDataManager].followingList addObjectsFromArray:userList];
            }
            
            [viewController performSelector:@selector(requestComplete:) withObject:userList];
            
        }break;
            
        case kGET_FOLLOWING_ENTRY_LIST:
        {
            
        }break;
        case kADD_FOLLOWING:
        {
            [viewController performSelector:@selector(requestComplete:) withObject:nil];
        }break;
        case kSEARCH_USER:
        {
            NSMutableArray* userList = [[NSMutableArray alloc]init];
            NSArray *list = [doc.rootElement elementsForName:@"user"];
            
            for (GDataXMLElement* element in list) {
                
                NSArray* medal = [element elementsForName:@"medal"];
                NSMutableArray* myMedals = [[NSMutableArray alloc]init];
                
                for (GDataXMLElement* theMedal in medal) {
                    Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[theMedal attributeForName:@"id"].stringValue ]
                                                         name:[theMedal attributeForName:@"name"].stringValue image:[theMedal attributeForName:@"image"].stringValue];
                    [myMedals addObject:myMedal];
                }

                User* user = [[User alloc]initWithFacebookId:[element attributeForName:@"facebook_id"].stringValue 
                                                      userId:[f numberFromString:[element attributeForName:@"user_id"].stringValue] 
                                                        name:[element attributeForName:@"name"].stringValue
                                                     surname:[element attributeForName:@"surname"].stringValue
                                                     country:[element attributeForName:@"country"].stringValue 
                                                       email:[element attributeForName:@"email"].stringValue 
                                                    follower:[f numberFromString:[element attributeForName:@"follower"].stringValue]  
                                                   following:[f numberFromString:[element attributeForName:@"following"].stringValue]  
                                                   photoLink:[element attributeForName:@"photo"].stringValue
                                                       medal:myMedals];
                
                //Not ME!
                if ([user.facebookId isEqualToString:[DataManager sharedDataManager].user.facebookId]==NO) {
                    [userList addObject:user];
                }
                
            }
            
            [viewController performSelector:@selector(requestComplete:) withObject:userList];
            
        }break;
        case kSEARCH_PLACE:
        {
            
        }break;
            
        case kUSER_INDEX:
        {
            
        }break;
        case kPLACE_INDEX:
        {
            
        }break;
        case kENTRY_INDEX:
        {
            
        }break;
            
        case kLIKE_ENTRY:
        {
            //Need to change XML from server to return LIKE ,DISLIKE
            [viewController performSelector:@selector(requestComplete:) withObject:@"LIKE"];
        }break;
            
        case kGET_ADMIN_MESSAGE:
        {
            NSArray *list = [doc.rootElement elementsForName:@"message"];

            NSMutableArray* adminMessage = [[NSMutableArray alloc]initWithCapacity:20];
            for (GDataXMLElement* element in list) {
                
                NSString* msg = [element attributeForName:@"message"].stringValue;
                NSString* date = [element attributeForName:@"datetime"].stringValue;
                
                [adminMessage addObject:[NSArray arrayWithObjects:msg,date, nil]];
            }
            
            [DataManager sharedDataManager].adminMessage = adminMessage;
        }break;
            
        case kGET_MEDAL:
        {
            if ([DataManager sharedDataManager].categoryList.count==0) {
                
                NSArray *list = [doc.rootElement elementsForName:@"medal"];
                
                for (GDataXMLElement* element in list) {
                    
                    Medal* myMedal = [[Medal alloc]initWithId:[f numberFromString:[element attributeForName:@"id"].stringValue]
                                                         name:[element attributeForName:@"name"].stringValue image:[element attributeForName:@"image"].stringValue];
                    [[DataManager sharedDataManager].medalList addObject:myMedal];
                    
                    [myMedal LoadImage];
                }
            }
        }break;
            
        case kADD_COMMENT_ENTRY:
        {
            CommentViewController* theViewController = (CommentViewController*)viewController;
            if ([theViewController isKindOfClass:[CommentViewController class]]) {
                [theViewController addCommentComplete];
            }
        }break;
            
        case kGET_COMMENT_ENTRY:
        {
            NSArray *list = [doc.rootElement elementsForName:@"comment"];
            NSMutableArray* commentList = [[NSMutableArray alloc]init];
            
            for (GDataXMLElement* element in list) {
                
                NSLog(@"%@",[element attributeForName:@"comment_name"].stringValue);
                Comment* comment = [[Comment alloc]initWithEntryId:[f numberFromString:[element attributeForName:@"entry_id"].stringValue] 
                                                         commentId:[f numberFromString:[element attributeForName:@"comment_id"].stringValue] 
                                                       commentName:[element attributeForName:@"comment_name"].stringValue
                                                            userId:[f numberFromString:[element attributeForName:@"user_id"].stringValue] 
                                                            detail:[element attributeForName:@"detail"].stringValue 
                                                          dateTime:[DataManager convNSStringToNSDate:[element attributeForName:@"datetime"].stringValue]];
                [commentList addObject:comment];
            }
            
            CommentViewController* theViewController = (CommentViewController*)viewController;
            if ([theViewController isKindOfClass:[CommentViewController class]]) {
                [theViewController downLoadCommentComplete:commentList];
            }
        }
            break;
            
        case kSHARE_ENTRY:
        {
            
        }
            break;
            
        case kUNFOLLOW_USER:
        {
            [viewController performSelector:@selector(requestComplete:) withObject:nil];
        }
            break;
            
        case kIS_LIKE_ENTRY:
        {
            GDataXMLElement* element = doc.rootElement;
            NSString* txt = [element attributeForName:@"result"].stringValue;
            [viewController performSelector:@selector(requestComplete:) withObject:txt];
        }
            break;
            
        default:
            break;
    }
}

- (void)ASIHttpRequestStartRequest:(ASIFormDataRequest*)theRequest viewController:(UIViewController*)viewController{
    
    [_hud show:YES];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[theRequest setShouldContinueWhenAppEntersBackground:YES];
#endif
    [theRequest setDelegate:self];
    
    __unsafe_unretained ASIFormDataRequest* __request = theRequest;
	[theRequest setCompletionBlock:^
     {
         if (theRequest.responseStatusCode == 200) {
             
             NSData * theData = [__request responseData];
             
             [self pasteDataByRequestTag:theRequest.tag andData:theData viewController:viewController];
             
         }else {
             
             //Alert
             [self showAlertMessage:@"Error" subMessage:@"Invalid request response code."];
         }
         
         [_hud hide:YES];
         [self checkLoginProcess:viewController];
         
     }];
    
	[theRequest setFailedBlock:^
     {
         //Alert
         [self showAlertMessage:@"Error" subMessage:@"Connection fail."];
         
         [_hud hide:YES];
         [self checkLoginProcess:viewController];
     }];
    
	[theRequest startAsynchronous];
}

- (void)ASIHttpRequest_GetUserInfoByUserId:(NSString*)userId viewController:(UIViewController *)viewController{

    NSURL *url = [NSURL URLWithString:GET_USER_INFO_BY_ID];
    ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_USER_INFO;
    [_request setPostValue:userId forKey:@"user_id"];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_GetUserInfoWithFacebookId:(NSString*)facebookId
                                            name:(NSString*)name
                                         surname:(NSString*)surname
                                         country:(NSString*)country
                                           email:(NSString*)email
                                           photo:(NSString*)photo
                                  viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_USER_INFO];
    ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_USER_INFO;
    [_request setPostValue:facebookId forKey:@"facebook_id"];
    [_request setPostValue:name forKey:@"name"];
    [_request setPostValue:surname forKey:@"surname"];
    [_request setPostValue:country forKey:@"country"];
    [_request setPostValue:email forKey:@"email"];
    [_request setPostValue:photo forKey:@"photo"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_UpdateUserInfoWithFacebookId:(NSString*)facebookId
                                               name:(NSString*)name
                                            surname:(NSString*)surname
                                            country:(NSString*)country
                                              email:(NSString*)email
                                              photo:(UIImage*)photo
                                     viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:UPDATE_USER_INFO];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kUPDATE_USER_INFO;
    [_request setPostValue:facebookId forKey:@"facebook_id"];
    [_request setPostValue:name forKey:@"name"];
    [_request setPostValue:surname forKey:@"surname"];
    [_request setPostValue:country forKey:@"country"];
    [_request setPostValue:email forKey:@"email"];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[_request setShouldContinueWhenAppEntersBackground:YES];
#endif
    
    //Image data
	NSData *data = UIImageJPEGRepresentation(photo, 1.0);
    [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
	[_request appendPostData:data];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_GetEntryListWithLati:(NSString*)lati
                                      longi:(NSString*)longi
                               min_distance:(NSString*)min_distance
                               max_distance:(NSString*)max_distance
                                   min_date:(NSString*)min_date
                                   max_date:(NSString*)max_date
                                   category:(NSString*)category
                             viewController:(UIViewController*)viewController;{
    
    NSURL *url = [NSURL URLWithString:GET_ENTRY_LIST];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_ENTRY_LIST;

    if([self isNotGregorian]){
        
        NSDate *date = [DataManager convNSStringToNSDateOnlyDate:max_date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
        NSDateComponents *dateComponents = [gregorian components:( 
                                                                  NSDayCalendarUnit | 
                                                                  NSYearCalendarUnit | 
                                                                  NSMonthCalendarUnit ) fromDate:date];
        
        
        NSInteger year = [dateComponents year];
        NSInteger month = [dateComponents month];
        NSInteger day = [dateComponents day];
        
        max_date = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    }

    [_request setPostValue:lati forKey:@"lat"];
    [_request setPostValue:longi forKey:@"long"];
    [_request setPostValue:min_distance forKey:@"min_distance"];
    [_request setPostValue:max_distance forKey:@"max_distance"];
    [_request setPostValue:min_date forKey:@"min_date"];
    [_request setPostValue:max_date forKey:@"max_date"];
    [_request setPostValue:category forKey:@"category"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_NewEntryListWithUserId:(NSString*)user_id 
                                   categories:(NSString*)categories
                                       detail:(NSString*)detail
                                        photo:(UIImage*)photo
                               facebook_place:(NSString*)facebook_place
                                   place_name:(NSString*)place_name
                                         lati:(NSString*)lati
                                        longi:(NSString*)longi
                               viewController:(UIViewController*)viewController{

    NSURL *url = [NSURL URLWithString:ADD_NEW_ENTRY];
    
    ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kADD_NEW_ENTRY;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:categories forKey:@"categories"];
    [_request setPostValue:detail forKey:@"detail"];
    [_request setPostValue:facebook_place forKey:@"facebook_place"];
    [_request setPostValue:place_name forKey:@"place_name"];
    [_request setPostValue:lati forKey:@"lat"];
    [_request setPostValue:longi forKey:@"long"];    
    [_request setTimeOutSeconds:30];
    [_request setDelegate:self];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[_request setShouldContinueWhenAppEntersBackground:YES];
#endif

    //Image data
	NSData *data = UIImageJPEGRepresentation(photo, 1.0);
    [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
	[_request appendPostData:data];
   
    [self ASIHttpRequestStartRequest:_request viewController:viewController];

    [_hud show:YES];
}

- (void)ASIHttpRequest_GetCategoryViewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_CATEGORY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_CATEGORY;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetPopularViewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_POPULAR];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_POPULAR;
    [_request setTimeOutSeconds:10];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetFollowerWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_FOLLOWER];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_FOLLOWER;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setTimeOutSeconds:10];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetFollowingWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_FOLLOWING];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_FOLLOWING;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setTimeOutSeconds:10];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetUserEntryListWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_USER_ENTRY_LIST];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_USER_ENTRY_LIST;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetFollowingEntryListWithUserId:(NSString*)user_id viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_FOLLOWING_ENTRY_LIST];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_FOLLOWING_ENTRY_LIST;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_AddFollowingWithUserId:(NSString*)user_id following_id:(NSString*)following_id viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:ADD_FOLLOWING];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kADD_FOLLOWING;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:following_id forKey:@"following_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_SearchUserWithText:(NSString*)text viewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:SEARCH_USER];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kSEARCH_USER;
    [_request setPostValue:text forKey:@"text"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_SearchPlaceWithText:(NSString*)text viewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:SEARCH_PLACE];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kSEARCH_PLACE;
    [_request setPostValue:text forKey:@"text"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_SearchEntryWithText:(NSString*)text viewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:SEARCH_ENTRY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kSEARCH_ENTRY;
    [_request setPostValue:text forKey:@"text"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_UserIndexViewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:USER_INDEX];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kUSER_INDEX;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_PlaceIndexViewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:PLACE_INDEX];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kPLACE_INDEX;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_EntryIndexViewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:ENTRY_INDEX];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kENTRY_INDEX;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_CommentEntryWithUserId:(NSString*)user_id
                                     entry_id:(NSString*)entry_id
                                      comment:(NSString*)comment
                               viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:ADD_COMMENT_ENTRY];
    
    ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kADD_COMMENT_ENTRY;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:entry_id forKey:@"entry_id"];
    [_request setPostValue:comment forKey:@"comment"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_LikeEntryWithUserId:(NSString*)user_id
                                  entry_id:(NSString*)entry_id
                            viewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:LIKE_ENTRY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kLIKE_ENTRY;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:entry_id forKey:@"entry_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

- (void)ASIHttpRequest_GetAdminMessageViewController:(UIViewController*)viewController{
    NSURL *url = [NSURL URLWithString:GET_ADMIN_MESSAGE];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_ADMIN_MESSAGE;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
    
}
- (void)ASIHttpRequest_GetMedalViewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_MEDAL];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_MEDAL;
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_GetCommentEntryWithEntryId:(NSString*)entryId viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:GET_COMMENT_ENTRY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kGET_COMMENT_ENTRY;
    [_request setPostValue:entryId forKey:@"entry_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}
- (void)ASIHttpRequest_ShareEntryWithUserId:(NSString*)user_id
                                   entry_id:(NSString*)entry_id
                             viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:SHARE_ENTRY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kSHARE_ENTRY;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:entry_id forKey:@"entry_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
    
}
- (void)ASIHttpRequest_UnfollowerWithUserId:(NSString*)user_id
                                follower_id:(NSString*)follower_id
                             viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:UNFOLLOW_USER];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kUNFOLLOW_USER;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:follower_id forKey:@"follower_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
    
}
- (void)ASIHttpRequest_IsLikeWithUserId:(NSString*)user_id
                               entry_id:(NSString*)entry_id
                         viewController:(UIViewController*)viewController{
    
    NSURL *url = [NSURL URLWithString:IS_LIKE_ENTRY];
    
     ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:url];
    
    _request.tag = kIS_LIKE_ENTRY;
    [_request setPostValue:user_id forKey:@"user_id"];
    [_request setPostValue:entry_id forKey:@"entry_id"];
    [_request setTimeOutSeconds:30];
    
    [self ASIHttpRequestStartRequest:_request viewController:viewController];
}

#pragma mark -
#pragma mark SetupTile

- (void)setupTileView{
    
    //Re setup tile view
    //UINavigationController* navOfTileCtrl = (UINavigationController*)myTabBarCtrl.selectedViewController;
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        // load the storyboard by name
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        // either one of the two, depending on if your view controller is the initial one
        UINavigationController* nav = [storyboard instantiateInitialViewController];
        nav = [storyboard instantiateViewControllerWithIdentifier:@"NavTileViewController"];
        [viewControllers addObject:nav];
    }
    
    DVSlideViewController* dv = [[DVSlideViewController alloc] init];
    dv.viewControllers = viewControllers;
    dv.title = @"Hot Events";
    [self.myTabBarController addChildViewController:dv];
    
    NSMutableArray* mArray = [NSMutableArray arrayWithArray:_myTabBarController.viewControllers];
    [mArray exchangeObjectAtIndex:0 withObjectAtIndex:4];
    [mArray exchangeObjectAtIndex:1 withObjectAtIndex:4];
    [mArray exchangeObjectAtIndex:2 withObjectAtIndex:4];
    [mArray exchangeObjectAtIndex:3 withObjectAtIndex:4];
    
    [self.myTabBarController setViewControllers:mArray];
    UITabBarItem* tabbarItem = [self.myTabBarController.tabBar.items objectAtIndex:0];
    tabbarItem.image = [UIImage imageNamed:@"tabmenu_icon_event.png"];
    
    //Set hilight color of tabbar
    self.myTabBarController.tabBar.selectedImageTintColor = [UIColor orangeColor];
}

#pragma mark -
#pragma mark Facebook Login Code

- (void)showLoginView {
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // FBSample logic
    // If the login screen is not already displayed, display it. If the login screen is displayed, then
    // getting back here means the login in progress did not successfully complete. In that case,
    // notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[SCLoginViewController class]]) {
        SCLoginViewController* loginViewController = [[SCLoginViewController alloc]initWithNibName:@"SCLoginViewController" 
                                                                                            bundle:nil];
        [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        SCLoginViewController* loginViewController = (SCLoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
}

- (void)sessionStateChanged:(FBSession *)session 
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    // FBSample logic
    // Any time the session is closed, we want to display the login controller (the user
    // cannot use the application unless they are logged in to Facebook). When the session
    // is opened successfully, hide the login controller and show the main UI.
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = [self.navController topViewController];
            if ([[topViewController modalViewController] isKindOfClass:[SCLoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
            
            if([_revealViewController.frontViewController isKindOfClass:[UINavigationController class]] && 
               ![((UINavigationController *)_revealViewController.frontViewController).topViewController isKindOfClass:[MyTabBarViewController class]])
            {
                [_revealViewController setFrontViewController:_navController animated:NO];
            }
            
            [_myTabBarController setSelectedIndex:3];
            [_revealViewController hideFrontView];
            [_revealViewController showFrontViewCompletely:YES];
            
            
            // FBSample logic
            // Pre-fetch and cache the friends for the friend picker as soon as possible to improve
            // responsiveness when the user tags their friends.
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // FBSample logic
            // Once the user has logged in, we want them to be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification 
                                                        object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [NSArray arrayWithObjects:@"user_photos", @"email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:
            ^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];

                                        
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {
    // FBSample logic
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url]; 
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{	
    // this means the user switched back to this app without completing a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        // BUG: for the iOS 6 preview we comment this line out to compensate for a race-condition in our
        // state transition handling for integrated Facebook Login; production code should close a
        // session in the opening state on transition back to the application; this line will again be
        // active in the next production rev
        //[FBSession.activeSession close]; // so we close our session and start over
    }	
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // BUG WORKAROUND:
    // Nib files require the type to have been loaded before they can do the
    // wireup successfully.  
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    [FBProfilePictureView class];

    [iTellAFriend sharedInstance].appStoreID = 408981381;
    
    //Initialization Data Manager
    [DataManager sharedDataManager];  
    
    //Setup Hud
    {
        UIView *view = self.window.rootViewController.view;
        self.hud = [[MBProgressHUD alloc] initWithView:view];
        //_hud.labelText = @"Doing funky stuff...";
        //_hud.detailsLabelText = @"Just relax";
        _hud.mode = MBProgressHUDModeIndeterminate;
        [view addSubview:_hud];
        
    }
    
    //+++ Split view
    
    //Main View
    {
        MyTabBarViewController* myTabBarCtrl =  (MyTabBarViewController*)self.window.rootViewController;
        JHNavController *navigationController = [[JHNavController alloc] initWithRootViewController:myTabBarCtrl]; 

        UIViewController *rearViewController = [[RearViewController alloc]init];
        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:myTabBarCtrl rearViewController:rearViewController];
        
        self.myTabBarController = myTabBarCtrl;
        self.revealViewController = revealController;
        self.navController = navigationController;
        
        [self setupTileView];
        
        self.window.rootViewController = self.revealViewController;
        [self.window makeKeyAndVisible];
        
        //[self.myTabBarController setupNavBar];
        
        //self.myTabBarController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
        
    }
    
    //Get storyboard
    UIStoryboard *storyboard = self.myTabBarController.storyboard;
    
    //ManageAccount view
    {
        ManageAccountViewController *theViewController = [storyboard instantiateViewControllerWithIdentifier:@"ManageAccount"];
        JHNavController *navigationController = [[JHNavController alloc] initWithRootViewController:theViewController];
        self.manageAccountViewController = navigationController;
        theViewController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
    }
    
    //About view
    {
        //AboutViewController *theViewController = [[AboutViewController alloc] init];
        AboutViewController *theViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        JHNavController *navigationController = [[JHNavController alloc] initWithRootViewController:theViewController];
        self.aboutViewController = navigationController;
        theViewController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
    }
    
    //Setting view
    {
        //SettingViewController *theViewController = [[SettingViewController alloc] init];
        SettingViewController *theViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        JHNavController *navigationController = [[JHNavController alloc] initWithRootViewController:theViewController];
        self.settingViewController = navigationController;
        theViewController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
    }
    
    //Notification view
    {
        //SettingViewController *theViewController = [[SettingViewController alloc] init];
        NotificationViewController *theViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        JHNavController *navigationController = [[JHNavController alloc] initWithRootViewController:theViewController];
        self.notificationViewController = navigationController;
        theViewController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navibar_justhappen.png"]];
    }
    
    // FBSample logic
    // See if we have a valid token for the current state.
    if (![self openSessionWithAllowLoginUI:NO]) {
        // No? Display the login page.
        [self showLoginView];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

#pragma mark - UIAlertViewDelegate methods

- (void)showAlertMessage:(NSString*)message subMessage:(NSString*)subMessage{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:subMessage
                                                   delegate:self 
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - HUD

-(void)hideHud{
    [_hud hide:YES];
}
-(void)showHud{
    [_hud show:YES];
    
}
@end
