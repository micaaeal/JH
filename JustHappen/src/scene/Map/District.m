//
//  DemoMapAnnotation.m
//  Created by Gregory Combs on 11/30/11.
//
//  based on work at https://github.com/grgcombs/MultiRowCalloutAnnotationView
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License. 
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
//  or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
//
//

#import "District.h"
#import "Representative.h"
#import "MyLocation.h"
#import "DataModel.h"
#import "DataManager.h"

@interface District()
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title representative:(Representative *)representative;
@end

@implementation District
@synthesize title = _title;
@synthesize coordinate = _coordinate;
@synthesize representatives = _representatives;
@synthesize myRep = _myRep;

#pragma mark - The Good Stuff

+ (District *)districtWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title representative:(Representative *)representative {
    return [[District alloc] initWithCoordinate:coordinate title:title representative:representative];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title representative:(Representative *)representative {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.representatives = [[NSMutableArray alloc]initWithCapacity:0];
        self.myRep = representative;
    }
    return self;
}

+ (District *)districtWithRepresentative:(Representative *)representative {
    
    District* d = [[District alloc] initWithCoordinate:[DataManager coordinateFromEntry:representative.entry] 
                                          title:representative.name 
                                 representative:representative];
    [d addPlace:d];
    
    return d;
}

+ (District *)districtWithEntry:(Entry*)entry{

    Representative *rep = [Representative representativeWithEntry:entry];
    District* d = [District districtWithRepresentative:rep];
    return d;
}
- (void)dealloc {
    self.title = nil;
    self.representatives = nil;
}
- (NSArray *)calloutCells {
    if (_representatives.count == 0) {
        [_representatives addObject:_myRep];
    }
    if (!_representatives || [_representatives count] == 0)
        return nil;
    return [self valueForKeyPath:@"representatives.calloutCell"];
}
-(BOOL)isAlreadyAddPlace:(District *)place{
    for (Representative* rep in _representatives) {
        if (rep == [_representatives objectAtIndex:0])continue;
        if ([place.myRep.entry.entryId isEqualToNumber:rep.entry.entryId]) {
            return YES;
        }
    }
    return NO;
}
-(void)addPlace:(District *)place{
    
    if (_representatives.count==0) {
        [_representatives addObject:_myRep];
    }
    
    if (_representatives.count < 4) {
        [_representatives addObject:place.myRep];
    }

}

-(int)placesCount{
    return _representatives.count;
}

-(void)cleanPlaces{
    
    [_representatives removeAllObjects];
}

-(NSArray*)places{
    return _representatives;
}

@end
