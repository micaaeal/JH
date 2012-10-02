//
//  ManageAccountViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/1/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageAccountViewController : UITableViewController <UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userSurname;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userAddress;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@end
