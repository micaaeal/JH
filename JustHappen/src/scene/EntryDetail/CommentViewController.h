//
//  CommentViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/3/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;

@interface CommentViewController : UITableViewController

@property (nonatomic,retain) Entry* entry;

- (void)addCommentComplete;
- (void)downLoadCommentComplete:(NSArray*)commentList;

@property (strong, nonatomic) IBOutlet UITextField *commentTextField;

@end
