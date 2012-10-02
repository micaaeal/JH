//
//  TilesController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/12/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IconDownloader.h"

@class User;

@protocol TilesControllerDelegate
-(void)performSegueWithEventIndex:(NSIndexPath*)eventIndex;
@end

@interface TileData : NSObject

@property (nonatomic,retain)NSArray* entryList;
@property (assign) int randVal;
@property (assign) int indexInEntryList;

-(id)initWithEntryList:(NSArray*)entryList randVal:(int)randVal indexInEntryList:(int)indexInEntryList;

@end

@interface TilesController : UITableViewController 
<
UISearchBarDelegate,
TilesControllerDelegate,
CLLocationManagerDelegate,
UIScrollViewDelegate,
IconDownloaderDelegate
>
@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic, retain) User* user;

-(void)getUserEntryListWithUserId:(NSString*)userId;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;

- (IBAction)refreshTapped:(UIBarButtonItem *)sender;
- (void)requestComplete:(id)data;

- (void)setCategory:(NSString*)categoryId;

@end
