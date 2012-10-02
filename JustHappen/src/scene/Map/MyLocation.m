//
//  MyLocation.m
//  DoubleTable
//
//  Created by Numpol Poldongnok on 5/28/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import "MyLocation.h"

@implementation MyLocation

@synthesize entry = _entry;
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(void)getAddressFromLocation:(CLLocationCoordinate2D)location{
    CLLocation * loc = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if([placemarks count]>0){
             CLPlacemark *result=[placemarks objectAtIndex:0];
             //NSString *city=[NSString stringWithFormat:@"%@",[result locality]];
             _address = [NSString stringWithFormat:@"%@%@%@%@",
                         ([result country]==nil)?@"":[NSString stringWithFormat:@"%@,",[result country]],
                         ([result locality]==nil)?@"":[NSString stringWithFormat:@"%@,",[result locality]],
                         ([result subLocality]==nil)?@"":[NSString stringWithFormat:@"%@,",[result subLocality]],
                         ([result name]==nil)?@"":[NSString stringWithFormat:@"%@",[result name]]];
             
             //Get address name
             //self.entry.data.place = [NSString stringWithFormat:@"@ %@",_address];
         }}
     ];
}

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    
    if ((self = [super init])) {
        
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _places = [[NSMutableArray alloc]initWithCapacity:0];
        
        [self getAddressFromLocation:_coordinate];
    }
    return self;
}

- (NSString *)subtitle{
    if ([_places count]==1) {
        return _address;
    }
    else{
        return @"";
    }
}

- (NSString *)title{
    if ([_places count]==1) {
        return _name;
    }
    else{
        return [NSString stringWithFormat:@"%d places", [_places count]];
    }
}

-(void)addPlace:(MyLocation *)place{
    
    [_places addObject:place];
}

-(int)placesCount{
    return _places.count;
    
}

-(void)cleanPlaces{
    
    if (_places.count <= 1) return;
    
    id firstObject = [_places objectAtIndex:0];
    [_places removeAllObjects];
    [_places addObject:firstObject];
}

-(NSArray*)places{
    return _places;
}
@end