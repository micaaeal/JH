//
//  DetailViewController.h
//  JustHappen
//
//  Created by Ray Wenderlich on 2/16/12.
//  Copyright (c) 2012 Tontanii-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;
@class User;
@interface DetailViewController : UITableViewController < UINavigationControllerDelegate>

@property (strong, nonatomic) Entry * entry;
@property (strong, nonatomic) User * owner;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *categoryView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@end
