//
//  DataManager.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/13/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "DataModel.h"

@class JHAppDelegate;

@interface DataManager : NSObject

@property (nonatomic,readwrite) User* user;

@property (nonatomic,retain) NSMutableArray* entryList;
@property (nonatomic,retain) NSMutableArray* categoryList;
@property (nonatomic,retain) NSMutableArray* popularList;
@property (nonatomic,retain) NSMutableArray* followerList;
@property (nonatomic,retain) NSMutableArray* followingList;
@property (nonatomic,retain) NSMutableArray* userEntryList;
@property (nonatomic,retain) NSMutableArray* followingEntryList;
@property (nonatomic,retain) NSMutableArray* commentEntryList;
@property (nonatomic,retain) NSMutableArray* likeEntryList;
@property (nonatomic,retain) NSMutableArray* medalList;
@property (nonatomic,retain) NSMutableArray* placeList;
@property (nonatomic,retain) NSMutableArray* dateList;
@property (nonatomic,copy) NSArray* adminMessage;

@property (assign) int selectedCategory;
@property (assign) int selectedDate;
@property (assign) int selectedPlace;
@property (assign) BOOL autoPost;

+(DataManager*)sharedDataManager;

+(BOOL)isUser:(User*)user InUserList:(NSArray*)userList;
+(BOOL)isUserId:(NSString*)userId InUserList:(NSArray*)userList;
+(NSMutableArray*)removeDuplicateUser:(NSArray*)userList;
+(NSMutableArray*)removeDuplicatePlace:(NSArray*)placeList;
+(NSMutableArray*)removeDuplicateEntry:(NSArray*)entryList;

-(void)addPlaceList:(NSArray*)placeList;
-(void)addPlace:(Place*)place;

-(Place*)getPlaceByPlaceId_NSString:(NSString*)placeId;
-(Place*)getPlaceByPlaceId_NSNumber:(NSNumber*)placeId;

+(NSDate*)convNSStringToNSDateOnlyDate:(NSString*)str;
+(NSString*)convNSDateToNSStringOnlyDate:(NSDate*)date;
+(NSDate*)convNSStringToNSDate:(NSString*)str;
+(NSString*)convNSDateToNSString:(NSDate*)date;

+(CLLocationCoordinate2D)coordinateFromEntry:(Entry*)entry;

+(UIImage*)loadImageFromStrURL:(NSString*)strURL;
+(Entry*)getEntryByEntryId:(NSString*)entryId;
+(void)updateEntryList:(NSArray*)entryList;

+(NSDate*)getSelectedDate;
+(NSString*)getPlaceCategoryNameById:(int)idx;
+(int)getPlaceCategoryDistantById:(int)idx;

+(void)addFollowingByUser:(User*)user;
+(void)removeFollowingByUserId:(NSString*)userId;

+(Category*)getCategoryById:(NSString*)categoryId;
+(UIImage*)getCategoryImageById:(NSString*)categoryId;
+(UIColor*)getCategoryColorById:(NSString*)categoryId;

+(Category*)getSelectedCategory;
+(JHAppDelegate*)getDelegate;

+(UIImage*)imageFromLink:(NSString*)urlStr;

@end
