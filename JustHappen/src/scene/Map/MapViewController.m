//
//  MapViewController.m
//  Map Kit Demo
//
//  Created by Ryan Johnson on 3/18/12.
//  Copyright (c) 2012 mobile data solutions.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

#import "MapViewController.h"

#import "TSPopoverController.h"
#import "TSActionSheet.h"

#import "DataManager.h"
#import "DetailViewController.h"
#import "JHAppDelegate.h"

#import "Representative.h"
#import "District.h"
#import "GenericPinAnnotationView.h"
#import "MultiRowCalloutAnnotationView.h"
#import "MultiRowAnnotation.h"

#define METERS_PER_MILE 1609.344
#define kSearchTextKey @"Search Text"

@interface MapViewController ()
{
    NSMutableArray* _geocodingResults;
    CLGeocoder* _geocoder;
    NSTimer* _searchTimer;
    
    JHAppDelegate* _JHAppDelegate;

    CLLocationManager* locationManager;
    CLLocationDegrees zoomLevel;
    UIButton* categoryButton;
    
    CLPlacemark * _selectedPlacemark;
}

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic, retain) MultiRowAnnotation *calloutAnnotation;

@property (strong, nonatomic) NSMutableArray* annotations;

- (void) geocodeFromTimer:(NSTimer *)timer;
- (void) processForwardGeocodingResults:(NSArray *)placemarks;
- (void) processReverseGeocodingResults:(NSArray*)placemarks;
- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coord;
- (void) addPinAnnotationForPlacemark:(CLPlacemark*)placemark;
- (void) zoomMapToPlacemark:(CLPlacemark *)selectedPlacemark;
- (IBAction)userLocTapped:(id)sender;

@end

@implementation MapViewController

@synthesize buttonView = _buttonView;
@synthesize mapView = _mapView;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize annotations = _annotations;

- (IBAction)userLocTapped:(id)sender {
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
    
    [self.mapView setRegion:region animated:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        _geocodingResults = [NSMutableArray array];
        _geocoder = [[CLGeocoder alloc] init]; 
        
        _annotations = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - MKMapViewDelegate methods. 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if (![annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)])
        return nil;
    
    NSObject <MultiRowAnnotationProtocol> *newAnnotation = (NSObject <MultiRowAnnotationProtocol> *)annotation;
    

    if (newAnnotation == self.calloutAnnotation) {
        MultiRowCalloutAnnotationView *annotationView = (MultiRowCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MultiRowCalloutReuseIdentifier];
        
        if (!annotationView) {
            annotationView = [MultiRowCalloutAnnotationView calloutWithAnnotation:newAnnotation 
                                                         onCalloutAccessoryTapped:
                              ^(MultiRowCalloutCell *cell, UIControl *control, NSDictionary *userData) {
                // This is where I usually push in a new detail view onto the navigation controller stack, using the object's ID
                NSLog(@"Representative (%@) with ID '%@' was tapped.", cell.subtitle, [userData objectForKey:@"id"]);
            }];
        }
        else
        {
            annotationView.annotation = newAnnotation;
        }
        
        annotationView.parentAnnotationView = self.selectedAnnotationView;
        annotationView.mapView = mapView;
        return annotationView;
    }


    
    GenericPinAnnotationView *annotationView = (GenericPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GenericPinReuseIdentifier];
    
    if (!annotationView) 
    {
        annotationView = [GenericPinAnnotationView pinViewWithAnnotation:newAnnotation];
    }
    annotationView.annotation = newAnnotation;
    for (UIView* obj in annotationView.subviews) {
        if (obj.tag == 777) {
            [obj removeFromSuperview];
        }
    }
    
    //Get image to represent
    District* d = (District*)annotation;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[DataManager getCategoryImageById:d.myRep.entry.categoryId.stringValue]];
    imageView.frame = CGRectMake(-10, -5, 40, 40);
    imageView.tag = 777;
    [annotationView addSubview:imageView];

    return annotationView;    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
    id<MKAnnotation> annotation = aView.annotation;
    if (!annotation || ![aView isSelected])
        return;
    if ( NO == [annotation isKindOfClass:[MultiRowCalloutCell class]] &&
        [annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
    {
        NSObject <MultiRowAnnotationProtocol> *pinAnnotation = (NSObject <MultiRowAnnotationProtocol> *)annotation;
        if (!self.calloutAnnotation) {
            _calloutAnnotation = [[MultiRowAnnotation alloc] init];
            [_calloutAnnotation copyAttributesFromAnnotation:pinAnnotation];
            [mapView addAnnotation:_calloutAnnotation];
        }
        self.selectedAnnotationView = aView;
        return;
    }
    [mapView setCenterCoordinate:annotation.coordinate animated:YES];
    self.selectedAnnotationView = aView;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)aView {
    if ( NO == [aView.annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
        return;
    if ([aView.annotation isKindOfClass:[MultiRowAnnotation class]])
        return;
    GenericPinAnnotationView *pinView = (GenericPinAnnotationView *)aView;
    if (self.calloutAnnotation && !pinView.preventSelectionChange) {
        [mapView removeAnnotation:_calloutAnnotation];
        self.calloutAnnotation = nil;
    }
}
- (void)filterAnnotations:(NSArray *)placesToFilter{
    
    float deviceScreenWidth = 320;
    float deviceScreenHeight = 480;
    float annotationWidth = 32;
    float annotationHeight = 32;
    
    float iphoneScaleFactorLatitude = deviceScreenWidth/annotationWidth;
    float iphoneScaleFactorLongitude = deviceScreenHeight/annotationHeight;
    
    float latDelta  = _mapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta = _mapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    
    [placesToFilter makeObjectsPerformSelector:@selector(cleanPlaces)];
    
    if (placesToFilter.count <= 0)return;
    
    NSMutableArray *shopsToShow=[[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* annoList = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i=0; i<[placesToFilter count]; i++) {
        
        District *checkingLocation = [placesToFilter objectAtIndex:i];
        
        CLLocationCoordinate2D coord = [DataManager coordinateFromEntry:checkingLocation.myRep.entry];
        CLLocationDegrees latitude = coord.latitude;
        CLLocationDegrees longitude = coord.longitude;
        
        bool found=FALSE;
        for (District *tempPlacemark in shopsToShow) {
            
            CLLocationCoordinate2D coordinate = [DataManager coordinateFromEntry:tempPlacemark.myRep.entry];
            
            if(fabs(coordinate.latitude-latitude) < latDelta
               && fabs(coordinate.longitude-longitude) <longDelta
               && [tempPlacemark isAlreadyAddPlace:checkingLocation]==NO
               )
            {
                [annoList removeObject:checkingLocation];
                found=TRUE;
                [tempPlacemark addPlace:checkingLocation];
                break;
            }
        }
        if (!found) {

            [shopsToShow addObject:checkingLocation];
            [annoList addObject:checkingLocation];
        }
    }
    
    [_annotations addObjectsFromArray:annoList];
    [_mapView addAnnotations:_annotations];
    
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (zoomLevel!=mapView.region.span.longitudeDelta) {
        [self filterAnnotationsByEntryList];
        zoomLevel=mapView.region.span.longitudeDelta;
    }
}
- (void)requestComplete:(NSArray*)myEntryList{
    
    //Add annotation
    [DataManager updateEntryList:myEntryList];
    
    [self filterAnnotationsByEntryList];
}
- (void)filterAnnotationsByEntryList{
    
    //Clear map
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
    
    NSMutableArray* annotationToFilter = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (Entry* entry in [DataManager sharedDataManager].entryList) {
        
        District* d = [District districtWithEntry:entry];
        d.myRep.mapViewCtrl = self;
        
        [annotationToFilter addObject:d];
    }
    
    [self filterAnnotations:annotationToFilter]; 
}
- (void)reloadSearchResult{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [DataManager getSelectedDate];
    NSString* dateStr = [dateFormat stringFromDate:date];
    NSLog(@"Date: %@",dateStr);
    
    CLLocationCoordinate2D coord = locationManager.location.coordinate;
    Category* cat = [DataManager getSelectedCategory];
    [_JHAppDelegate ASIHttpRequest_GetEntryListWithLati:[NSString stringWithFormat:@"%f",coord.latitude]
                                                longi:[NSString stringWithFormat:@"%f",coord.longitude] 
                                         min_distance:@"" 
                                         max_distance:@""
                                             min_date:@"" 
                                             max_date:dateStr 
                                             category:cat.categoryId.stringValue
                                       viewController:self];  
}

#pragma mark - ViewController

- (void)updateButtons{
    
    if (self.buttonView.subviews.count == 0) {
        
        [self setupButtons];
    }
    
    if ([DataManager sharedDataManager].categoryList.count ==0)return;
    
    for (UIButton* button in self.buttonView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            
            switch (button.tag) {
                    
                case 2:
                {
                    //Place Button
                    [button setTitle:[DataManager getPlaceCategoryNameById:[DataManager sharedDataManager].selectedPlace] forState:UIControlStateNormal];
                    [self zoomDistant:[DataManager getPlaceCategoryDistantById:[DataManager sharedDataManager].selectedPlace]];
                }
                    break;
                    
                case 3:
                {
                    //Date Button
                    MyDate* myDate = [[DataManager sharedDataManager].dateList objectAtIndex:[DataManager sharedDataManager].selectedDate];
                    [button setTitle:myDate.name forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {  

    NSLog(@"APPEAR!");
    
    [self setSearchHidden:YES animated:YES];
    
    //Update all button
    //[self updateButtons];
    
    //First load result
    //[self reloadSearchResult];
    
    //[self zoomDistant:[DataManager getPlaceCategoryDistantById:[DataManager sharedDataManager].selectedPlace]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;     
    
    //Location manager
    {
        // Ensure that you can view your own location in the map view.
        [self.mapView setShowsUserLocation:YES];
        
        //Instantiate a location object.
        locationManager = [[CLLocationManager alloc] init];
        
        //Make this controller the delegate for the location manager.
        [locationManager setDelegate:self];
        
        //Set some parameters for the location object.
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }

    //Update all button
    [self updateButtons];
    
    //First load result
    [self reloadSearchResult];
    
    //Zoom to user location
    [self userLocTapped:nil];
}
- (void)setupButtons{
    
    CGRect rect = self.buttonView.frame;
    float width = rect.size.width/3;
    float height = 30;
    
    float x = 0;
    float y = 0;
    
    CGRect frame;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        categoryButton = topButton;
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        //[topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"Category" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 1;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        frame = topButton.titleLabel.frame;
    }
    
    x+=width;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"location" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 2;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        topButton.titleLabel.frame = frame;
    }
    
    x+=width;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"time" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 3;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        topButton.titleLabel.frame = frame;
    }
}
- (void)zoomDistant:(float)distant{
    
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,distant*METERS_PER_MILE,distant*METERS_PER_MILE);
    
    [self.mapView setRegion:region animated:YES];
    
    
//    CLLocationCoordinate2D zoomLocation = _selectedPlacemark.location.coordinate;
//    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, distant*METERS_PER_MILE, distant*METERS_PER_MILE);
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
//    
//    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (void)showPopover:(id)sender forEvent:(UIEvent*)event{
    
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    popoverController.cornerRadius = 5;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
}
- (void)showActionSheet:(id)sender forEvent:(UIEvent*)event{
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {

        case 2:
        {
            TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"location"];
            
            for (int i = 0; i < 6; i++) {
                
                [actionSheet addButtonWithTitle:[DataManager getPlaceCategoryNameById:i] block:^{
                    
                    NSLog(@"Place: %@",[DataManager getPlaceCategoryNameById:i]);
                    
                    [button setTitle:[DataManager getPlaceCategoryNameById:i] forState:UIControlStateNormal];
                    [DataManager sharedDataManager].selectedPlace = i; 
                    
                    [self zoomDistant:[DataManager getPlaceCategoryDistantById:i]];
                    [self reloadSearchResult];
                }];
            }
            
            [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
            actionSheet.cornerRadius = 5;
            [actionSheet showWithTouch:event];
        }
            break;
            
        case 3:
        {
            TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"time"];
            
            NSArray* list = [DataManager sharedDataManager].dateList;
            for (MyDate* myDate in list) {
                
                [actionSheet addButtonWithTitle:myDate.name block:^{
                    
                    NSLog(@"Date: %@",myDate.name);
                    [button setTitle:myDate.name forState:UIControlStateNormal];
                    [DataManager sharedDataManager].selectedDate = [list indexOfObject:myDate];
                    
                    [self reloadSearchResult];
                }];
            }
            
            [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
            actionSheet.cornerRadius = 5;
            [actionSheet showWithTouch:event];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)viewDidUnload{
    [self setButtonView:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - Geocoding Methods

- (void)geocodeFromTimer:(NSTimer *)timer {
    
    NSString * searchString = [timer.userInfo objectForKey:kSearchTextKey];
    
    // Cancel any active geocoding. Note: Cancelling calls the completion handler on the geocoder
    if (_geocoder.isGeocoding)
        [_geocoder cancelGeocode];
    
    [_geocoder geocodeAddressString:searchString
                  completionHandler:^(NSArray *placemark, NSError *error) {
                      if (!error)
                          [self processForwardGeocodingResults:placemark];
                  }
     ];
}
- (void)processForwardGeocodingResults:(NSArray *)placemarks {
    [_geocodingResults removeAllObjects];
    [_geocodingResults addObjectsFromArray:placemarks];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coord {
    if ([_geocoder isGeocoding])
        [_geocoder cancelGeocode];
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coord.latitude 
                                                       longitude:coord.longitude];
    
    [_geocoder reverseGeocodeLocation:location
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (!error)
                            [self processReverseGeocodingResults:placemarks];
                    }];
}
- (void)processReverseGeocodingResults:(NSArray *)placemarks {
    
    if ([placemarks count] == 0)
        return;
    
    CLPlacemark * placemark = [placemarks objectAtIndex:0];
    NSString * alertMessage = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO); // requires AddressBookUI framework
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Geocode Complete"
                                                     message:alertMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}
- (void)addPinAnnotationForPlacemark:(CLPlacemark*)placemark {
    
    MKPointAnnotation * placemarkAnnotation = [[MKPointAnnotation alloc] init];
    placemarkAnnotation.coordinate = placemark.location.coordinate;
    placemarkAnnotation.title = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    [_mapView addAnnotation:placemarkAnnotation];
}
- (void)zoomMapToPlacemark:(CLPlacemark *)selectedPlacemark {
    
    CLLocationCoordinate2D coordinate = selectedPlacemark.location.coordinate;
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    double radius = (MKMapPointsPerMeterAtLatitude(coordinate.latitude) * selectedPlacemark.region.radius)/2;
    MKMapSize size = {radius, radius};
    MKMapRect mapRect = {mapPoint, size};
    mapRect = MKMapRectOffset(mapRect, -radius/2, -radius/2); // adjust the rect so the coordinate is in the middle
    [_mapView setVisibleMapRect:mapRect animated:YES];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)setSearchHidden:(BOOL)hidden animated:(BOOL)animated {
    
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    
    if (searchBar.hidden == hidden)return;
    
    CGFloat searchBarHeight = searchBar.frame.size.height;
    
    CGFloat offset = (hidden)? -searchBarHeight : searchBarHeight;
    NSTimeInterval duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        
        searchBar.frame = CGRectOffset(searchBar.frame, 0.0, offset);
        
    } completion:^(BOOL finished) 
     {
         searchBar.hidden = hidden;
         if (!hidden) [searchBar becomeFirstResponder];
     }];
}
- (IBAction)showSearchBar:(id)sender {
    
    [self setSearchHidden:NO animated:YES];
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self setSearchHidden:YES animated:YES];
}
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    // Use a timer to only start geocoding when the user stops typing
    if ([_searchTimer isValid])
        [_searchTimer invalidate];
    
    const NSTimeInterval kSearchDelay = .25;
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:searchString
                                                          forKey:kSearchTextKey];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                    target:self
                                                  selector:@selector(geocodeFromTimer:)
                                                  userInfo:userInfo
                                                   repeats:NO];
    
    return NO;
}

#pragma mark - UITableView Data Source + Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_geocodingResults count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const  kCellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellIdentifier];
    
    
    CLPlacemark * placemark = [_geocodingResults objectAtIndex:indexPath.row];
    
    NSString * formattedAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    cell.textLabel.text = formattedAddress;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Clear the map
    [_mapView removeAnnotations:_annotations];
    
    CLPlacemark * selectedPlacemark = [_geocodingResults objectAtIndex:indexPath.row];
    
    [self addPinAnnotationForPlacemark:selectedPlacemark];
    
    // hide the search display controller and reset the search results
    [self.searchDisplayController setActive:NO animated:YES];
    
    [_geocodingResults removeAllObjects];
    
    _selectedPlacemark = _selectedPlacemark;
    [self zoomMapToPlacemark:selectedPlacemark];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString* entryId = (NSString*)sender;
    if ([segue.identifier isEqualToString:@"MapEventDetailSegue"]) 
    {
        Entry* entry = [DataManager getEntryByEntryId:entryId];
        
        DetailViewController *detailController = segue.destinationViewController;
        detailController.entry = entry;
    }
}
- (void)showDetailViewWithEntryId:(NSString*)entryId{
    [self performSegueWithIdentifier:@"MapEventDetailSegue" sender:entryId];
}

#pragma mark - CategoryPicker

- (void)selectCategory:(id)sender{
    [self performSegueWithIdentifier:@"CategorySegue" sender:self];
}

- (void)setCategory:(NSString*)categoryId{
    
    Category* category = [DataManager getCategoryById:categoryId];
    [DataManager sharedDataManager].selectedCategory = category.categoryId.intValue;
    categoryButton.titleLabel.text = category.name;
    [categoryButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    [self reloadSearchResult];
}


@end
