//
//  MyLocation.h
//  DoubleTable
//
//  Created by Numpol Poldongnok on 5/28/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Entry;

@interface MyLocation : NSObject <MKAnnotation> {
    
    NSString *_name;
    NSString *_address;
    
    CLLocationCoordinate2D _coordinate;
    
    NSMutableArray* _places;
}

@property (nonatomic, assign) Entry* entry;
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (void)getAddressFromLocation:(CLLocationCoordinate2D)location;

-(void)addPlace:(MyLocation *)place;
-(int)placesCount;
-(void)cleanPlaces;
-(NSArray*)places;

@end
