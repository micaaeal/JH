//
//  CreateEventViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/29/55 BE.
//
//

#import "CreateEventViewController.h"
#import "DataModel.h"
#import "DataManager.h"
#import "UIImageExtras.h"
#import "BeforeNewEventViewController.h"
#import "JHAppDelegate.h"
#import "CategoryPickerViewController.h"
#import "TargetConditionals.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DEFacebookComposeViewController.h"
#import "MBProgressHUD.h"

@interface CreateEventViewController ()
<
UITextFieldDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
CLLocationManagerDelegate,
FBPlacePickerDelegate,
UIPopoverControllerDelegate,
UIImagePickerControllerDelegate>
{
    JHAppDelegate* _JHAppDelegate;
    BOOL newMedia;
    BOOL _useLocation;
    BOOL _firstEditText;
}

@property (strong, nonatomic) MBProgressHUD* hud;
@property (assign) int selectedCategory;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;

@property (strong, nonatomic) IBOutlet UIButton *btnPlace;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;

@property (strong, nonatomic) Entry * entryItem;

@property (strong, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (strong, nonatomic) NSObject<FBGraphPlace>* selectedPlace;
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@implementation CreateEventViewController


@synthesize delegate = _delegate;
@synthesize hud = _hud;
@synthesize locationManager = _locationManager;
@synthesize placePickerController = _placePickerController;
@synthesize btnCategory = _btnCategory;
@synthesize entryItem = _entryItem;
@synthesize cameraRollButton = _cameraRollButton;
@synthesize detailTextView = _detailTextView;
@synthesize imageView = _imageView;
@synthesize selectedCategory = _selectedCategory;
@synthesize btnPlace = _btnPlace;

@synthesize selectedPlace = _selectedPlace;
@synthesize popoverController;


#pragma mark - Managing

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)configureView {
    
    User* theUser = [DataManager sharedDataManager].user;
    self.entryItem = [[Entry alloc]initWithOwnerId:theUser.userId
                                        categoryId:[NSNumber numberWithInt:1]
                                           entryId:nil
                                         photoLink:nil
                                            detail:@"My new entry"
                                          dateTime:[NSDate dateWithTimeIntervalSinceNow:0]
                                           placeId:[NSString stringWithFormat:@"%d",10000+arc4random()%10000]];
    
    if (self.entryItem) {
        self.detailTextView.text = @"Entry detail here...";
        //self.imageView.image = self.entryItem.cacheImage;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void)updateSelections {
    
    _btnPlace.titleLabel.text = (self.selectedPlace ?self.selectedPlace.name:@"Select One");
    [_btnPlace.titleLabel setTextAlignment:UITextAlignmentCenter];
}

#pragma mark - View lifecycle

- (void)dealloc {
    
    _locationManager.delegate = nil;
    _placePickerController.delegate = nil;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
        _selectedCategory = -1;
        _useLocation = NO;
    }
    
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    _firstEditText = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    
    // Get the CLLocationManager going.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // We don't want to be notified of small changes in location, preferring to use our
    // last cached results, if any.
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    
    _detailTextView.delegate = self;
    
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleAction:)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = cancleButton;
    
    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)) {
        [self.cameraRollButton removeFromSuperview];
    }
    
    [self addPictureTapped:nil];
    
    
    //HUD
    UIView *view = self.view;
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [view addSubview:_hud];
}
- (void)viewDidUnload{
    [self setDetailTextView:nil];
    [self setImageView:nil];
    
    
    self.placePickerController = nil;
    
    [self setBtnPlace:nil];
    [self setBtnCategory:nil];
    
    [self setCameraRollButton:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)cancleAction:(id)sender{
    
    [self exit];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
    {
        // FBSample logic
        // If we already have a place picker, reload its data. If not, pre-fetch the
        // data so it is displayed quickly on first use of the place picker.
        if (self.placePickerController) {
            self.placePickerController.locationCoordinate = newLocation.coordinate;
            [self.placePickerController loadData];
        } else {
            FBCacheDescriptor *cacheDescriptor =
            [FBPlacePickerViewController cacheDescriptorWithLocationCoordinate:newLocation.coordinate
                                                                radiusInMeters:1000
                                                                    searchText:nil
                                                                  resultsLimit:50
                                                              fieldsForRequest:nil];
            [cacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
            
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"Location Error:%@", error);
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (_firstEditText) {
        _firstEditText = NO;
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    _entryItem.detail = textView.text;
}

#pragma mark - CategoryPicker

- (void)setCategory:(NSString*)categoryId{
    Category* category = [DataManager getCategoryById:[NSString stringWithFormat:@"%@",categoryId]];
    
    self.selectedCategory = category.categoryId.intValue;
    self.btnCategory.titleLabel.text = category.name;
    [self.btnCategory.titleLabel setTextAlignment:UITextAlignmentCenter];
}

#pragma mark - PlacePickerDelegate

- (void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker{
    self.selectedPlace = placePicker.selection;
    [self updateSelections];
    if (self.selectedPlace.count > 0) {
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - Button

- (IBAction)cameraRoll:(id)sender {
    if ([self.popoverController isPopoverVisible]) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            popoverController.delegate = self;
            
            UIButton* button = (UIButton*)sender;
            [self.popoverController presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
            newMedia = NO;
        }
    }
}
- (IBAction)btnPlaceTouchUpInside:(id)sender {
    if (!self.placePickerController) {
        self.placePickerController = [[FBPlacePickerViewController alloc]
                                      initWithNibName:nil bundle:nil];
        
        self.placePickerController.delegate = self;
        self.placePickerController.title = @"Select a place";
    }
    self.placePickerController.locationCoordinate = self.locationManager.location.coordinate;
    self.placePickerController.radiusInMeters = 1000;
    self.placePickerController.resultsLimit = 50;
    self.placePickerController.searchText = @"";
    
    [self.placePickerController loadData];
    [self.navigationController pushViewController:self.placePickerController
                                         animated:true];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        if (self.imageView.image==NULL)
        {
            [self performSelector:@selector(addPictureTapped:) withObject:NULL afterDelay:0.1];
        }
        else if (_selectedCategory==-1) {
            [self performSegueWithIdentifier:@"CategorySegue" sender:self];
        }
        
        else if (_selectedPlace==nil) {
            
            [self btnPlaceTouchUpInside:nil];
        }
    }
    else if (buttonIndex==1) {
        
        if (_selectedPlace==nil && _useLocation == NO) {
            
            _useLocation = YES;
            
            [self doneAction:nil];
            
        }
    }
}

#pragma mark - Upload Callback

- (void)exit{
    [_JHAppDelegate hideHud];
    [self dismissModalViewControllerAnimated:YES];
    [_delegate exitFromChild:self done:YES];
}

- (void)uploadEntryFinished:(NSString*)link{
    
    [_hud hide:YES];
    
    //Auto share..
    _entryItem.photoLink = link;
    if ([DataManager sharedDataManager].autoPost) {
        [self postToFacebook];
    }
    else {
        [self exit];
    }
}

- (void)doneAction:(id)sender{
    
    if ([self.detailTextView isFirstResponder])
    {
        [_detailTextView resignFirstResponder];
        [self textViewDidEndEditing:_detailTextView];
    }
    
    if (self.imageView.image==NULL) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No event photo!"
                              message: @"Please pick photo"
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"Cancle",nil];
        [alert show];
        
        return;
    }
    if (_selectedCategory==-1) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No category selected!"
                              message: @"Please select category."\
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"Cancle",nil];
        [alert show];
        
        
        return;
    }
    
    
    
    if (_selectedPlace==nil && _useLocation == NO) {
        
        NSString* locationStr = [NSString stringWithFormat:@"Yor are at location (%.2f %.2f)",
                                 self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No place selected!"
                                                        message:locationStr
                                                       delegate:self
                                              cancelButtonTitle:@"Pick place"
                                              otherButtonTitles:@"Use location",nil];
        [alert show];
        
        return;
    }
    
    
    User* user = [DataManager sharedDataManager].user;
    
    if (user==nil) {
        
        NSLog(@"Invalid user");
        return;
    }
    
    
    [_hud show:YES];
    
    UIImage* img = [CreateEventViewController imageWithImage:self.imageView.image scaledToSize:CGSizeMake(500, 500)];
    
    if (_selectedPlace)
    {
        [_JHAppDelegate ASIHttpRequest_NewEntryListWithUserId:user.userId.stringValue
                                                   categories:[NSString stringWithFormat:@"%d",_selectedCategory]
                                                       detail:self.detailTextView.text
                                                        photo:img
                                               facebook_place:_selectedPlace.id
                                                   place_name:_selectedPlace.name
                                                         lati:_selectedPlace.location.latitude.stringValue
                                                        longi:_selectedPlace.location.longitude.stringValue
                                               viewController:self];
    }else {
        [_JHAppDelegate ASIHttpRequest_NewEntryListWithUserId:user.userId.stringValue
                                                   categories:[NSString stringWithFormat:@"%d",_selectedCategory]
                                                       detail:self.detailTextView.text
                                                        photo:img
                                               facebook_place:_selectedPlace.id
                                                   place_name:_selectedPlace.name
                                                         lati:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude]
                                                        longi:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude]
                                               viewController:self];
    }
    
    
}

#pragma mark - imagePickerDelegate

- (IBAction)addPictureTapped:(id)sender {
    
    [UIActionSheet photoPickerWithTitle:@"Choose a photo from..."
                             showInView:self.view
                              presentVC:self
                          onPhotoPicked:^(UIImage* image)
     {
         self.entryItem.cacheImage = image;
         self.imageView.image = image;
     }
                               onCancel:^
     {
         NSLog(@"Cancelled");
         
         [self exit];
     }];
}

//FOR IPAD...
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self.popoverController dismissPopoverAnimated:true];
//
//    //[self dismissModalViewControllerAnimated:YES];
//
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    self.entryItem.cacheImage = image;
//    self.imageView.image = image;
//
//    if (newMedia)
//        UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:finishedSavingWithError:contextInfo:),nil);
//}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark Share Facebook

- (void)postToFacebook{
    
    // Invoke the dialog
    DEFacebookComposeViewControllerCompletionHandler completionHandler = ^(DEFacebookComposeViewControllerResult result) {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                break;
        }
        
        //[self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            //When dialog show
            [self exit];
        }];
        //[self performSelector:@selector(exit) withObject:nil afterDelay:0.2f];
    };
    
    DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [facebookViewComposer setInitialText:[_entryItem detail]];
    [facebookViewComposer addImage:self.imageView.image];
    facebookViewComposer.completionHandler = completionHandler;
    [self presentViewController:facebookViewComposer animated:YES completion:^{
        //When dialog show
    }];
    
}


@end
