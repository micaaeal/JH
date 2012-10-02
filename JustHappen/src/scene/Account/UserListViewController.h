//
//  UserListViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/29/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface UserListViewController : UITableViewController

@property (nonatomic,retain) User* user;
@property (nonatomic,retain) NSArray* userList;

@end
