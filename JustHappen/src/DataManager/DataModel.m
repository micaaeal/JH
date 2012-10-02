//
//  DataModel.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/27/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation User

@synthesize facebookId = _facebookId;
@synthesize userId = _userId;
@synthesize name = _name;
@synthesize surname = _surname;
@synthesize country = _country;
@synthesize email = _email;
@synthesize follower = _follower;
@synthesize following = _following;
@synthesize medal = _medal;
@synthesize photoLink =_photoLink;
@synthesize cacheThumnail = _cacheThumnail;

-(id)initWithFacebookId:(NSString*)facebookId 
                 userId:(NSNumber*)userId 
                   name:(NSString*)name
                surname:(NSString*)surname
                country:(NSString*)country
                  email:(NSString*)email
               follower:(NSNumber*)follower
              following:(NSNumber*)following
              photoLink:(NSString*)photoLink
                  medal:(NSArray*)medal{ 
    if ((self = [super init])) {
        self.facebookId = facebookId;
        self.userId = userId;
        self.name = name;
        self.surname = surname;
        self.country = country;
        self.email = email;
        self.follower = follower;
        self.following = following;
        self.photoLink = photoLink;
        self.medal = medal;
    }
    
    return self;
}

-(UIImage*)getPhoto{

    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_photoLink]]]; 
}

@end

@implementation Entry

@synthesize ownerId = _ownerId;
@synthesize categoryId = _categoryId;
@synthesize entryId = _entryId;
@synthesize detail = _detail;
@synthesize date = _date;
@synthesize placeId = _placeId;
@synthesize photoLink = _photoLink;
@synthesize cacheImage = _cacheImage;
@synthesize cacheThumnail = _cacheThumnail;

-(id)initWithOwnerId:(NSNumber*)ownerId
          categoryId:(NSNumber*)categoryId
             entryId:(NSNumber*)entryId
           photoLink:(NSString*)photoLink
              detail:(NSString*)detail
            dateTime:(NSDate*)date
             placeId:(NSString*)placeId{

    if ((self = [super init])) {
        self.ownerId = ownerId;
        self.categoryId = categoryId;
        self.entryId = entryId;
        self.photoLink = photoLink;
        self.detail = detail;
        self.date = date;
        self.placeId = placeId;
        
        if (_photoLink==nil) {
            self.cacheImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",1/*+arc4random()%30*/]];
        }
    }
    return self;
}

-(UIImage*)getPhoto{

    return self.cacheImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self getPhotoURL]]]];
}

-(NSString*)getPhotoURL{
    
    return [NSString stringWithFormat:@"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/images_entry/image_origin/%@",_photoLink];
}

-(NSString*)getThumnailURL{
    
    return [NSString stringWithFormat:@"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/images_entry/image_thumb_1/%@",_photoLink];
}

-(NSString*)getPreviewURL{
    
    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        return [NSString stringWithFormat:@"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/images_entry/image_thumb_2/%@",_photoLink];
    
    return [NSString stringWithFormat:@"http://ec2-54-251-0-140.ap-southeast-1.compute.amazonaws.com/justhappen/images_entry/image_medium_1/%@",_photoLink];
}

@end

@implementation Comment

@synthesize entryId = _entryId;
@synthesize commentId = _commentId;
@synthesize commentName = _commentName;
@synthesize userId = _userId;
@synthesize detail = _detail;
@synthesize date = _date;

-(id)initWithEntryId:(NSNumber*)entryId
           commentId:(NSNumber*)commentId
         commentName:(NSString*)commentName
              userId:(NSNumber*)userId
              detail:(NSString*)detail
            dateTime:(NSDate*)date{ 
    if ((self = [super init])){
        self.entryId = entryId;
        self.commentId = commentId;
        self.commentName = commentName;
        self.userId = userId;
        self.detail = detail;
        self.date = date;
    }
    return self;
}

@end

@implementation Result

@synthesize type = _type;
@synthesize reason = _reason;

-(id)initWithType:(NSString*)type reason:(NSString*)reason{ 
    if ((self = [super init])) {
        self.type = type;
        self.reason = reason;
    }
    return self;
}

@end

@implementation Category

@synthesize categoryId = _categoryId;
@synthesize name = _name;

-(id)initWithId:(NSNumber*)categoryId name:(NSString*)name{ 
    if ((self = [super init])) {
        self.categoryId = categoryId;
        self.name = name;
    }
    return self;
}

@end

@implementation PopularCategory

@synthesize category = _category;
@synthesize userList = _userList;

-(id)initWithCategoryId:(NSString*)category userList:(NSArray*)userList{ 
    if ((self = [super init])) {
        self.category = category;
        self.userList = userList;
    }
    return self;
}

@end

@implementation TheMessage

@synthesize message = _message;
@synthesize date = _date;

-(id)initWithMessage:(NSString*)message dateTime:(NSDate*)date{ 
    if ((self = [super init])) {
        self.message = message;
        self.date = date;
    }
    return self;
}

@end

@implementation Place

@synthesize placeId = _placeId;
@synthesize facebookPlaceId = _facebookPlaceId;
@synthesize name = _name;
@synthesize lati = _lati;
@synthesize longi = _longi;

-(id)initWithId:(NSNumber*)placeId
facebookPlaceId:(NSString*)facebookPlaceId
           name:(NSString*)name
           lati:(NSNumber*)lati
          longi:(NSNumber*)longi{ 
    if ((self = [super init])) {
        self.placeId = placeId;
        self.facebookPlaceId = facebookPlaceId;
        self.name = name;
        self.lati = lati;
        self.longi = longi;
    }
    return self;
}

@end

@implementation Medal

@synthesize medalId = _medalId;
@synthesize name = _name;
@synthesize image = _image;

-(id)initWithId:(NSNumber*)medalId
name:(NSString *)name image:(NSString*)img{
    if ((self = [super init])) {
        self.medalId = medalId;
        self.name = name;
        self.image = img;
    }
    return self;
}

- (void) LoadImage{
    if (self.image != Nil) {
        imgData = [[NSMutableData alloc] init];
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.image]];
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        [connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [imgData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.imageFile = [[UIImage alloc] initWithData:imgData];
}

@end

@implementation MyDate

@synthesize date = _date;
@synthesize name = _name;

-(id)initWithName:(NSString*)name date:(NSDate*)date{ 
    if ((self = [super init])) {
        self.date = date;
        self.name = name;
    }
    return self;
}

@end

#pragma mark - List 

@implementation EntryList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {
        
    }
    return self;
}

@end

@implementation CommentList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {
        
    }
    return self;
}

@end
@implementation CategoryList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {}
    return self;
}

@end
@implementation PopularList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {}
    return self;
}

@end

@implementation UserList

-(id)initWithUserList:(NSArray*)userList{ 
    if ((self = [super init])) {}
    return self;
}

@end

@implementation MessageList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {}
    return self;
}

@end

@implementation PlaceList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {}
    return self;
}

@end

@implementation MedalList

-(id)initWithArrayList:(NSArray*)arrayList{ 
    if ((self = [super init])) {}
    return self;
}

@end
