//
//  Representative.m
//  Created by Greg Combs on 11/30/11.
//
//  based on work at https://github.com/grgcombs/MultiRowCalloutAnnotationView
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License. 
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
//  or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
//
//

#import "Representative.h"
#import "MultiRowCalloutCell.h"
#import "DataModel.h"
#import "DataManager.h"
#import "MapViewController.h"
#import "JHAppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"

@interface Representative()
- (id)initWithName:(NSString *)name party:(NSString *)party image:(UIImage *)image representativeID:(NSString *)representativeID;
@end
    
@implementation Representative
@synthesize name = _name;
@synthesize party = _party;
@synthesize image = _image;
@synthesize representativeID = _representativeID;
@synthesize calloutCell = _calloutCell;
@synthesize entry = _entry;
@synthesize mapViewCtrl = _mapViewCtrl;

+ (Representative *)representativeWithName:(NSString *)name party:(NSString *)party image:(UIImage *)image representativeID:(NSString *)representativeID {
    return [[Representative alloc] initWithName:name party:party image:image representativeID:representativeID];
}

+ (Representative *)representativeWithEntry:(Entry*)entry{
    
    
    Place* place = [[DataManager sharedDataManager]getPlaceByPlaceId_NSString:entry.placeId];
    NSString* title = place.name;
    if (title == nil || [title isEqualToString:@""]) {
        title = @"Unknow place";
    }
    Representative* rep = [[Representative alloc]initWithName:title
                                                        party:entry.detail 
                                                        image:entry.cacheImage 
                                             representativeID:entry.entryId.stringValue];
    rep.entry = entry;
    
    return rep;
}

- (id)initWithName:(NSString *)name party:(NSString *)party image:(UIImage *)image representativeID:(NSString *)representativeID {
    self = [super init];
    if (self) {
        self.name = name;
        self.party = party;
        self.image = image;
        self.representativeID = representativeID;
    }
    return self;
}

- (void)dealloc {
    self.name = nil;
    self.party = nil;
    self.image = nil;
    self.representativeID = nil;
}

- (MultiRowCalloutCell *)calloutCell {

    Entry* entry = [DataManager getEntryByEntryId:_entry.entryId.stringValue];
    UIImage* image = [DataManager loadImageFromStrURL:[entry getThumnailURL]];
    
    //image = [DataManager getCategoryImageById:[entry categoryId].stringValue];
    //TODO mix category icon into preview image!?

    MultiRowCalloutCell* cell = [MultiRowCalloutCell cellWithImage:image
                                                             title:_party 
                                                          subtitle:_name 
                                                          userData:[NSDictionary dictionaryWithObject:_representativeID forKey:@"id"]
                                          onCalloutAccessoryTapped:^(MultiRowCalloutCell *cell, UIControl *control, NSDictionary *userData){
                                              
                                              [_mapViewCtrl showDetailViewWithEntryId:_entry.entryId.stringValue];
                                          }];
    
    cell.backgroundColor = [DataManager getCategoryColorById:entry.categoryId.stringValue];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[DataManager getCategoryImageById:entry.categoryId.stringValue]];

    return cell;
}

@end
