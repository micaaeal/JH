//
//  DataManager.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/13/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import "DataManager.h"

@interface  DataManager()
{
    NSMutableArray* _evnets;
}

@end

@implementation DataManager


/*
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
 kCOMMENT_ENTRY,
 kLIKE_ENTRY,
 kGET_ADMIN_MESSAGE,
 kGET_MEDAL
 */

@synthesize user = _user;

@synthesize entryList = _entryList;
@synthesize categoryList = _categoryList;
@synthesize popularList = _popularList;
@synthesize followerList = _followerList;
@synthesize followingList = _followingList;
@synthesize userEntryList = _userEntryList;
@synthesize followingEntryList = _followingEntryList;
@synthesize commentEntryList = _commentEntryList;
@synthesize likeEntryList = _likeEntryList;
@synthesize medalList = _medalList;
@synthesize placeList = _placeList;
@synthesize dateList = _dateList;
@synthesize adminMessage = _adminMessage;

@synthesize selectedCategory = _selectedCatagory;
@synthesize selectedDate = _selectedDate;
@synthesize selectedPlace = _selectedPlace;
@synthesize autoPost = _autoPost;

static DataManager* _sharedGameManager = nil; 

+(DataManager*)sharedDataManager {
    @synchronized([DataManager class])                             
    {
        if(!_sharedGameManager)                                  
            _sharedGameManager = [[self alloc] init]; 
        return _sharedGameManager;                                 
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([DataManager class])                         
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Data Manager singleton"); 
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                
    }
    return nil;  
}

+(NSDate*)convNSStringToNSDateOnlyDate:(NSString*)str{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter dateFromString:str];
}

+ (NSString*)convNSDateToNSStringOnlyDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

+(NSDate*)convNSStringToNSDate:(NSString*)str{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    return [dateFormatter dateFromString:str];
}

+ (NSString*)convNSDateToNSString:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

- (double)randomFloatBetween:(double)smallNumber andBig:(double)bigNumber {
    double diff = bigNumber - smallNumber;
    return (((double) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(CGPoint)randomPoint{
    return CGPointMake(-80+[self randomFloatBetween:1 andBig:160], -80+[self randomFloatBetween:1 andBig:160]);
}

-(id)init {                                                      
    self = [super init];
    if (self != nil) {
        
        // Game Manager initialized
        NSLog(@"Data Manager Singleton, init");
        
        
        self.entryList      = [[NSMutableArray alloc]init];
        self.categoryList   = [[NSMutableArray alloc]init];
        self.popularList    = [[NSMutableArray alloc]init];
        self.followerList   = [[NSMutableArray alloc]init];
        self.followingList  = [[NSMutableArray alloc]init];
        self.userEntryList  = [[NSMutableArray alloc]init];
        self.followingEntryList = [[NSMutableArray alloc]init];
        self.commentEntryList   = [[NSMutableArray alloc]init];
        self.likeEntryList  = [[NSMutableArray alloc]init];
        self.medalList      = [[NSMutableArray alloc]init];
        self.placeList      = [[NSMutableArray alloc]init];
        self.dateList       = [[NSMutableArray alloc]init];
        
        self.selectedDate = 1; //Today
        self.selectedCategory = 0; //All
        
        
        long timeHours = 60*60;
        MyDate* myDate;
        
        myDate = [[MyDate alloc]initWithName:@"now"
                                        date:[NSDate dateWithTimeIntervalSinceNow:0]];
        [_dateList addObject:myDate];
        
        myDate = [[MyDate alloc]initWithName:@"today" 
                                        date:[NSDate dateWithTimeIntervalSinceNow:-timeHours*24]];
        [_dateList addObject:myDate];
        
        myDate = [[MyDate alloc]initWithName:@"this week" 
                                        date:[NSDate dateWithTimeIntervalSinceNow:-timeHours*24*7]];
        [_dateList addObject:myDate];
        
        myDate = [[MyDate alloc]initWithName:@"this month" 
                                        date:[NSDate dateWithTimeIntervalSinceNow:-timeHours*24*30]];
        [_dateList addObject:myDate];
        
        myDate = [[MyDate alloc]initWithName:@"this year" 
                                        date:[NSDate dateWithTimeIntervalSinceNow:-timeHours*24*365]];
        [_dateList addObject:myDate];
        
        myDate = [[MyDate alloc]initWithName:@"all time" 
                                        date:[NSDate dateWithTimeIntervalSince1970:0]];
        [_dateList addObject:myDate];


           
      
    }
    
    return self;
}

+(BOOL)isUser:(User*)user InUserList:(NSArray*)userList{
    for (User* userA in userList) {
        if ([userA.userId isEqualToNumber:user.userId]) {
            return YES;
        }
    }
    return NO;
}
+(BOOL)isUserId:(NSString*)userId InUserList:(NSArray*)userList{
   
    for (User* userA in userList) {
        if ([userA.userId.stringValue isEqualToString:userId]) {
            return YES;
        }
    }
    return NO;
}
+(NSMutableArray*)removeDuplicatePlace:(NSArray*)placeList{
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    
    if (![placeList count] == 0) {
        for (Place *a1 in placeList) {
            copy = YES;
            for (Place *a2 in filterResults) {
                if ([a1.placeId isEqualToNumber:a2.placeId]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    return filterResults;
}

+(NSMutableArray*)removeDuplicateUser:(NSArray*)userList{
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    
    if (![userList count] == 0) {
        for (User *a1 in userList) {
            copy = YES;
            for (User *a2 in filterResults) {
                if ([a1.facebookId isEqualToString:a2.facebookId]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    return filterResults;
}

+(NSMutableArray*)removeDuplicateEntry:(NSArray*)entryList{
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    
    if (![entryList count] == 0) {
        for (Entry *a1 in entryList) {
            copy = YES;
            for (Entry *a2 in filterResults) {
                if ([a1.entryId isEqualToNumber:a2.entryId]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    return filterResults;
}

-(BOOL)dateIsOut:(NSDate*)outDate myDate:(NSDate*)myDate{
    
    
    double val1 = [outDate timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    double val2 = [myDate timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    if (val2 > val1) {
        return YES;
    }
    return NO;
}

-(void)addPlaceList:(NSArray*)placeList{
    
    [_placeList addObjectsFromArray:placeList];
}

-(void)addPlace:(Place*)place{
    
    for (Place* thePlace in _placeList) {
        if ([thePlace.placeId isEqualToNumber:place.placeId]) {
            return;
        }
    }
    
    NSLog(@"add new place %d %@ (%.2f,%.2f)",place.placeId.intValue,place.name,place.lati.floatValue,place.longi.floatValue);
    [_placeList addObject:place];
}


-(Place*)getPlaceByPlaceId_NSString:(NSString*)placeId{
    
    for (Place* place in _placeList) {
        if ([placeId isEqualToString:place.placeId.stringValue] || 
            [placeId isEqualToString:place.facebookPlaceId]) {
            return place;
        }
    }
    
    return nil;
}

-(Place*)getPlaceByPlaceId_NSNumber:(NSNumber*)placeId{
    
    for (Place* place in _placeList) {
        if ([placeId isEqualToNumber:place.placeId] ||
            [placeId.stringValue isEqualToString:place.facebookPlaceId]) {
            return place;
        }
    }
    
    return nil;
}

+(CLLocationCoordinate2D)coordinateFromEntry:(Entry*)entry{
    Place* place = [[DataManager sharedDataManager]getPlaceByPlaceId_NSString:entry.placeId];
    return CLLocationCoordinate2DMake(place.lati.doubleValue, place.longi.doubleValue);
}

+(UIImage*)loadImageFromStrURL:(NSString*)strURL
{
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL error:NULL];
    return [UIImage imageWithData:data];
}

+(Entry*)getEntryByEntryId:(NSString*)entryId{
    for (Entry* entry in [DataManager sharedDataManager].entryList) {
        if ([entry.entryId.stringValue isEqualToString:entryId]) return entry;
    }
    return nil;
}

+(void)updateEntryList:(NSArray*)entryList{
    [[DataManager sharedDataManager].entryList removeAllObjects];
    [[DataManager sharedDataManager].entryList addObjectsFromArray:entryList];
}

+(NSDate*)getSelectedDate{
    NSArray* dateList = [DataManager sharedDataManager].dateList;
    int idx = [DataManager sharedDataManager].selectedDate;
    
    MyDate* myDate = [dateList objectAtIndex:idx];
    return myDate.date;
}

+(NSString*)getPlaceCategoryNameById:(int)idx{
    switch (idx) {
        case 0:
            return @"near current";
            break;
        case 1:
            return @"town";
            break;
        case 2:
            return @"city";
            break;
        case 3:
            return @"province";
            break;
        case 4:
            return @"country";
            break;
        default:
            break;
    }
    return @"world";
}

+(int)getPlaceCategoryDistantById:(int)idx{
    switch (idx) {
        case 0:
            return 1;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 100;
            break;
        case 4:
            return 500;
            break;
        default:
            break;
    }
    return 9000;
}

+(void)addFollowingByUser:(User*)user{
    
    if ([DataManager isUser:user InUserList:[DataManager sharedDataManager].followingList]) {
        return;
    }
    
    [[DataManager sharedDataManager].followingList addObject:user];
    NSNumber *number = [DataManager sharedDataManager].user.following;
    [DataManager sharedDataManager].user.following = [NSNumber numberWithInt:[number intValue] + 1];
}
+(void)removeFollowingByUserId:(NSString*)userId{
    
    NSLog(@"Following = %d",[DataManager sharedDataManager].followingList.count);
    
    for (User* user in [DataManager sharedDataManager].followingList) {
        if ([user.userId.stringValue isEqualToString:userId]) {
            [[DataManager sharedDataManager].followingList removeObject:user];
            NSLog(@"Following = %d",[DataManager sharedDataManager].followingList.count);
            
            NSNumber *number = [DataManager sharedDataManager].user.following;
            [DataManager sharedDataManager].user.following = [NSNumber numberWithInt:[number intValue] - 1];
            return;
        }
    }
}

+(Category*)getCategoryById:(NSString*)categoryId{
    
    for (Category* catagory in [DataManager sharedDataManager].categoryList) {
        if ([catagory.categoryId.stringValue isEqualToString:categoryId]) {
            return catagory;
        }
    }
    return [DataManager getCategoryById:@"13"]; //Default return all
}

+(UIImage*)getCategoryImageById:(NSString*)categoryId{
    
    NSString* picFileName = NULL;
    switch (categoryId.intValue) {
   
        case 12:
            //Top secret
            picFileName = @"category_icon_secret.png";
            break;
          
        case 11:
            //Mysteries
            picFileName = @"category_icon_mystery.png";
            break;
            
        case 10:
            //Gallery
            picFileName = @"category_icon_gallery.png";
            break;
            
        case 9:
            //Universities
            picFileName = @"category_icon_school.png";
            break;
            
        case 8:
            //Hot Deals
            picFileName = @"category_icon_deal.png";
            break;
            
        case 7:
            //Events
            picFileName = @"category_icon_event.png";
            break;
            
        case 6:
            //Auto
            picFileName = @"category_icon_auto.png";
            break;
            
        case 5:
            //Travel
            picFileName = @"category_icon_travel.png";
            break;
            
        case 4:
            //Foods
            picFileName = @"category_icon_food.png";
            break;
            
        case 3:
            //Sports
            picFileName = @"category_icon_sport.png";
            break;
            
        case 2:
            //News
            picFileName = @"category_icon_news.png";
            break;
            
        case 1:
            //SOS
            picFileName = @"category_icon_sos.png";
            break;

        default:
            picFileName = @"category_icon_all.png";
            break;
    }
    
    if (picFileName) {
        return [UIImage imageNamed:picFileName];
    }
    return NULL;
}

+(UIColor*)getCategoryColorById:(NSString*)categoryId{
    
    switch (categoryId.intValue) {
            
        case 12:
            //Top secret
            return [UIColor colorWithRed:28.0/255 green:27.0/255 blue:25.0/255 alpha:1];
            break;
            
        case 11:
            //Mysteries
           return [UIColor colorWithRed:119.0/255 green:117.0/255 blue:120.0/255 alpha:1];
            break;
            
        case 10:
            //Gallery
            return [UIColor colorWithRed:151.0/255 green:110.0/255 blue:255.0/255 alpha:1];
            break;
            
        case 9:
            //Universities
            return [UIColor colorWithRed:233.0/255 green:193.0/255 blue:69.0/255 alpha:1];
            break;
            
        case 8:
            //Hot Deals
            return [UIColor colorWithRed:233.0/255 green:69.0/255 blue:131.0/255 alpha:1];
            break;
            
        case 7:
            //Events
            return [UIColor colorWithRed:140.0/255 green:198.0/255 blue:63.0/255 alpha:1];
            break;
            
        case 6:
            //Auto
            return [UIColor colorWithRed:39.0/255 green:62.0/255 blue:234.0/255 alpha:1];
            break;
            
        case 5:
            //Travel
            return [UIColor colorWithRed:139.0/255 green:78.0/255 blue:52.0/255 alpha:1];
            break;
            
        case 4:
            //Foods
            return [UIColor colorWithRed:253.0/255 green:154.0/255 blue:12.0/255 alpha:1];
            break;
            
        case 3:
            //Sports
            return [UIColor colorWithRed:9.0/255 green:183.0/255 blue:255.0/255 alpha:1];
            break;
            
        case 2:
            //News
            return [UIColor colorWithRed:63.0/255 green:198.0/255 blue:155.0/255 alpha:1];
            break;
            
        case 1:
            //SOS
            return [UIColor colorWithRed:255.0/255 green:48.0/255 blue:7.0/255 alpha:1];
            break;
    }
    
    return [UIColor colorWithRed:159.0/255 green:219.0/255 blue:78.0/255 alpha:1];
}
+(Category*)getSelectedCategory{
    return [DataManager getCategoryById:[NSString stringWithFormat:@"%d",[DataManager sharedDataManager].selectedCategory]];
}

+(JHAppDelegate*)getDelegate{
    return (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(UIImage*)imageFromLink:(NSString*)urlStr{
    
    //THIS FUNCTION BOMB!?
    return [UIImage imageWithContentsOfFile:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
}
@end
