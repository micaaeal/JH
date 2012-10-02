//
//  DetailViewController.m
//  JustHappen
//
//  Created by Ray Wenderlich on 2/16/12.
//  Copyright (c) 2012 Tontanii-Studio. All rights reserved.
//

#import "DetailViewController.h"
#import "DataManager.h"
#import "DataModel.h"
#import "UIImageExtras.h"
#import "JHAppDelegate.h"
#import "CommentViewController.h"
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"
#import "DEFacebookComposeViewController.h"

@interface DetailViewController ()
{
    JHAppDelegate* _JHAppDelegate;
    NSArray* _commentList;
}
- (void)configureView;
@end

@implementation DetailViewController

@synthesize entry = _entry;
@synthesize owner = _owner;
@synthesize imageView = _imageView;
@synthesize placeLabel = _placeLabel;
@synthesize textView = _textView;
@synthesize dateLabel = _dateLabel;
@synthesize shareButton = _shareButton;
@synthesize likeButton = _likeButton;
@synthesize categoryView = _categoryView;
@synthesize userPhoto = _userPhoto;
@synthesize userName = _userName;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CommentSegue"]) {

        CommentViewController *commentView = (CommentViewController*)[segue destinationViewController];
        commentView.entry = _entry;
    }
}

#pragma mark - Managing the detail item

- (void)configureView
{
    UIImage* catImage = [DataManager getCategoryImageById:self.entry.categoryId.stringValue];
    self.categoryView.image = catImage;  
    self.imageView.image = catImage;
    
    // Update the user interface for the detail item.
    if (self.entry) {
          
        [self.textView setText:self.entry.detail];
        self.dateLabel.text = [DataManager convNSDateToNSString:self.entry.date];

        Place* place = [[DataManager sharedDataManager]getPlaceByPlaceId_NSString:self.entry.placeId];
        NSString* placeName = [NSString stringWithFormat:@"%@",place.name];
        if (([place.name isEqualToString:@""])) {
            placeName = @"Unknow place";
        }
        NSString* latLong = [NSString stringWithFormat:@"(Lat:%.2f,Long:%.2f)",place.lati.floatValue,place.longi.floatValue];
        self.placeLabel.text = latLong;
        self.title = placeName; 
  
        
        self.imageView.image = [self.entry getPhoto];
    }
    
    [_JHAppDelegate hideHud];
    
    // Check isLike?
    [_JHAppDelegate ASIHttpRequest_IsLikeWithUserId:[DataManager sharedDataManager].user.userId.stringValue 
                                           entry_id:_entry.entryId.stringValue 
                                     viewController:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_JHAppDelegate showHud];
    [self performSelector:@selector(configureView) withObject:nil afterDelay:.2];
    
}

- (void)requestComplete:(id)data{
    
    //For startLoginWithFacebook
    if ([data isKindOfClass:[User class]]) {
        
        User* user = (User*)data;
        self.owner = user;
        
        self.userPhoto.image = [self.owner getPhoto];
        self.userName.text = [NSString stringWithFormat:@"%@ %@",self.owner.name,self.owner.surname];
        
        return;
    }
    
    if ([data isEqualToString:@"yes"]) {
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateHighlighted];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateDisabled];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateSelected];
    }
    
    if ([data isEqualToString:@"LIKE"]) {
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateHighlighted];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateDisabled];
        [_likeButton setImage:[UIImage imageNamed:@"detail_like_c.png"] forState:UIControlStateSelected];
    }
    
    //Get owner
    if(self.owner==NULL)
    {
        [_JHAppDelegate ASIHttpRequest_GetUserInfoByUserId:self.entry.ownerId.stringValue viewController:self];
    }
}
- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setTextView:nil];
    [self setPlaceLabel:nil];
    [self setDateLabel:nil];
    [self setShareButton:nil];
    [self setLikeButton:nil];
    [self setCategoryView:nil];
    [self setUserPhoto:nil];
    [self setUserName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - Button

- (IBAction)btnCommentTouchUpInside:(id)sender {

    [self performSegueWithIdentifier:@"CommentSegue" sender:self];
}

- (IBAction)btnLikeTouchUpInside:(id)sender {
    
    [_JHAppDelegate ASIHttpRequest_LikeEntryWithUserId:[DataManager sharedDataManager].user.userId.stringValue 
                                              entry_id:_entry.entryId.stringValue viewController:self];
}

- (IBAction)btnShareTouchUpInside:(id)sender {

    DEFacebookComposeViewControllerCompletionHandler completionHandler = ^(DEFacebookComposeViewControllerResult result) {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    };
    
    DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [facebookViewComposer setInitialText:[_entry detail]];
    [facebookViewComposer addImage:self.imageView.image];
    facebookViewComposer.completionHandler = completionHandler;
    [self presentViewController:facebookViewComposer animated:YES completion:^{ }];
}

@end
