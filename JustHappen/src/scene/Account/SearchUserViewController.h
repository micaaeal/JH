//
//  SearchUserViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchUserViewController : UITableViewController
<UISearchDisplayDelegate>

@property (nonatomic,retain)NSString* searchString;

-(void)searchWithKey:(NSString*)key;
@end
