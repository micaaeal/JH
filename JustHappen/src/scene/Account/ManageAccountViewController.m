//
//  ManageAccountViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/1/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "ManageAccountViewController.h"
#import "DataManager.h"
#import "DataModel.h"

#import "UIAlertView+MKBlockAdditions.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "NSObject+MKBlockAdditions.h"

#import "JHAppDelegate.h"
#import "MBProgressHUD.h"

@interface ManageAccountViewController ()

@property (strong,nonatomic) MBProgressHUD* hud;
@end

@implementation ManageAccountViewController

@synthesize hud = _hud;
@synthesize userSurname;
@synthesize userName;
@synthesize userEmail;
@synthesize userAddress;
@synthesize userImage;

- (void)viewDidLoad{
    [super viewDidLoad];

    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && 
        [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        // Create a containing view to position the button
        {
            UIImage* barButtonImage = [UIImage imageNamed:@"button_menu_b.png"];
            float offsetX = 5;
            UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barButtonImage.size.width + offsetX, barButtonImage.size.height)];
            
            // Create a custom button with the image
            UIButton *barUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [barUIButton setImage:barButtonImage forState:UIControlStateNormal];
            barUIButton.frame = CGRectMake(offsetX, 0, barButtonImage.size.width, barButtonImage.size.height);
            [barUIButton addTarget:self.navigationController.parentViewController  
                            action:@selector(revealToggle:) 
                  forControlEvents:UIControlEventTouchUpInside];
            
            [containingView addSubview:barUIButton];
            
            // Create a container bar button
            UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:containingView];
            
            // Add the container bar button
            self.navigationItem.leftBarButtonItem = containingBarButton;
        }
	}
    
    User* user = [DataManager sharedDataManager].user;
    
    userName.text = user.name;
    userSurname.text = user.surname;
    userEmail.text = user.email;
    userAddress.text = user.country;
    
    NSLog(@"user.photoLink = %@",user.photoLink);
    
    userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.photoLink]]];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //HUD
    UIView *view = self.view;
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [view addSubview:_hud];
    
}

- (void)doneAction:(id)sender{
    
    [_hud show:YES];
    
    User* user = [DataManager sharedDataManager].user;
    
    [[DataManager getDelegate] ASIHttpRequest_UpdateUserInfoWithFacebookId:user.facebookId
                                                           name:self.userName.text
                                                        surname:self.userSurname.text
                                                        country:self.userAddress.text
                                                          email:self.userEmail.text
                                                          photo:self.userImage.image
                                                 viewController:self];
}

- (void)viewDidUnload{
    [self setUserName:nil];
    [self setUserEmail:nil];
    [self setUserAddress:nil];
    [self setUserImage:nil];
    [self setUserSurname:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)requestComplete:(id)data{
    [_hud hide:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)addPictureTapped:(id)sender {
    
    [UIActionSheet photoPickerWithTitle:@"Choose a photo from..." 
                             showInView:self.view 
                              presentVC:self 
                          onPhotoPicked:^(UIImage* image) 
     {
         self.userImage.image = image;
     }
                               onCancel:^
     {
         NSLog(@"Cancelled"); 
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
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
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
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

@end
