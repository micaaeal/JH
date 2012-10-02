//
//  AccountViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/29/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TilesController.h"

@class User;

@interface AccountViewController : TilesController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,retain) User* user;

-(void)searchBeginWithKey:(NSString*)key;
-(void)openPageForUser:(User*)user;
@end
