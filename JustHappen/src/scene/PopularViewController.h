//
//  PopularViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface PopularViewController : UITableViewController <IconDownloaderDelegate>
@property (nonatomic,retain) NSMutableArray* popularCategories;

@end
