//
//  DataModel.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/27/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong) NSString* facebookId;
@property (strong) NSNumber* userId;
@property (strong) NSString* name;
@property (strong) NSString* surname;
@property (strong) NSString* country;
@property (strong) NSString* email;
@property (strong) NSNumber* follower;
@property (strong) NSNumber* following;
@property (strong) NSArray* medal;
@property (strong) NSString* photoLink;
@property (strong) UIImage* cacheThumnail;

-(id)initWithFacebookId:(NSString*)facebookId 
                   userId:(NSNumber*)userId 
                     name:(NSString*)name
                  surname:(NSString*)surname
                  country:(NSString*)country
                    email:(NSString*)email
                 follower:(NSNumber*)follower
                following:(NSNumber*)following
                    photoLink:(NSString*)photoLink
                    medal:(NSArray*)medal;

-(UIImage*)getPhoto;

@end



@interface Entry : NSObject

@property (strong) NSNumber* ownerId;
@property (strong) NSNumber* categoryId;
@property (strong) NSNumber* entryId;
@property (strong) NSString* detail;
@property (strong) NSDate* date;
@property (strong) NSString* placeId;
@property (strong) NSString* photoLink;
@property (strong) UIImage* cacheImage;
@property (strong) UIImage* cacheThumnail;

-(id)initWithOwnerId:(NSNumber*)ownerId
          categoryId:(NSNumber*)categoryId
             entryId:(NSNumber*)entryId
           photoLink:(NSString*)photoLink
              detail:(NSString*)detail
            dateTime:(NSDate*)date
             placeId:(NSString*)placeId;

-(UIImage*)getPhoto;
-(NSString*)getPhotoURL;
-(NSString*)getThumnailURL;
-(NSString*)getPreviewURL;

@end

@interface Comment : NSObject

@property (strong) NSNumber* entryId;
@property (strong) NSNumber* commentId;
@property (strong) NSString* commentName;
@property (strong) NSNumber* userId;
@property (strong) NSString* detail;
@property (strong) NSDate* date;

-(id)initWithEntryId:(NSNumber*)entryId
           commentId:(NSNumber*)commentId
         commentName:(NSString*)commentName
              userId:(NSNumber*)userId
              detail:(NSString*)detail
            dateTime:(NSDate*)date;

@end

@interface Result : NSObject

@property (strong) NSString* type;
@property (strong) NSString* reason;

-(id)initWithType:(NSString*)type reason:(NSString*)reason;

@end


@interface Category : NSObject

@property (strong) NSNumber* categoryId;
@property (strong) NSString* name;

-(id)initWithId:(NSNumber*)categoryId name:(NSString*)name;

@end

@interface PopularCategory : NSObject

@property (strong) NSString* category;
@property (strong) NSArray* userList;

-(id)initWithCategoryId:(NSString*)category userList:(NSArray*)userList;

@end

@interface TheMessage : NSObject

@property (strong) NSString* message;
@property (strong) NSDate* date;

-(id)initWithMessage:(NSString*)message dateTime:(NSDate*)date;

@end

@interface Place : NSObject

@property (strong) NSNumber* placeId;
@property (strong) NSString* facebookPlaceId;
@property (strong) NSString* name;
@property (strong) NSNumber* lati;
@property (strong) NSNumber* longi;

-(id)initWithId:(NSNumber*)placeId
  facebookPlaceId:(NSString*)facebookPlaceId
             name:(NSString*)name
             lati:(NSNumber*)lati
            longi:(NSNumber*)longi;

@end


@interface Medal : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSMutableData* imgData;
}

@property (strong) NSNumber* medalId;
@property (strong) NSString* name;
@property (strong) NSString* image;
@property (strong) UIImage* imageFile;

-(id)initWithId:(NSNumber*)medalId
name:(NSString *)name image:(NSString*)img;

- (void) LoadImage;

@end

@interface MyDate : NSObject

@property (strong) NSString* name;
@property (strong) NSDate* date;

-(id)initWithName:(NSString*)name date:(NSDate*)date;

@end

// List 
@interface EntryList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end

@interface CommentList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end
@interface CategoryList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end

@interface PopularList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end

@interface UserList : NSObject

-(id)initWithUserList:(NSArray*)userList;

@end

@interface MessageList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end

@interface PlaceList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end

@interface MedalList : NSObject

-(id)initWithArrayList:(NSArray*)arrayList;

@end















