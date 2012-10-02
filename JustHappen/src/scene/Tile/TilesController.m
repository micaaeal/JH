//
//  TilesController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/12/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import "TilesController.h"
#import "TileCell.h"
#import "DetailViewController.h"
#import "DataManager.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "JHAppDelegate.h"

#define kSearchTextKey @"Search Text"


@implementation TileData

@synthesize entryList = _entryList;
@synthesize randVal = _randVal;
@synthesize indexInEntryList = _indexInEntryList;

-(id)initWithEntryList:(NSArray*)entryList randVal:(int)randVal indexInEntryList:(int)indexInEntryList{
    
    self = [super init];
    
    if (self) {
        self.entryList = entryList;
        self.randVal = randVal;
        self.indexInEntryList = indexInEntryList;
    }
    
    return self;
}
@end

@interface TilesController ()
{
    JHAppDelegate*  _JHAppDelegate;
    NSTimer*        _searchTimer;
    float           _distant;
    NSString*       _searchString;
    
    NSMutableArray*     _tileDataForCell;
    CLLocationManager*  _locationManager;
    
    UIButton* categoryButton;
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation TilesController

@synthesize searchBar = _searchBar;
@synthesize imageDownloadsInProgress;
@synthesize buttonView = _buttonView;
@synthesize user = _user;

- (void)requestComplete:(id)data{
    
    NSArray* myEntryList = (NSArray*)data;

    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
    
    //Clear tile
    [DataManager updateEntryList:myEntryList];
    
    [_tileDataForCell removeAllObjects];
    
    int totalEvent = [DataManager sharedDataManager].entryList.count;
    int indexInEntryList = 0;
    
    if (totalEvent > 0) {
        
        while (totalEvent > 2) {
            
            int val = 100;
            
            while (val > totalEvent) {
                if (arc4random()%2==0) {
                    val = 2;
                }else {
                    val = 8;
                }
            }
            
            NSMutableArray* entires = [[NSMutableArray alloc]init];
            
            for (int i = 0;i < val;i++) {
                [entires addObject:[[DataManager sharedDataManager].entryList objectAtIndex:indexInEntryList+i]];
            }
            
            TileData* tileData = [[TileData alloc]initWithEntryList:entires 
                                                            randVal:arc4random()%100 
                                                   indexInEntryList:indexInEntryList];
            
            [_tileDataForCell addObject:tileData];
            
            totalEvent -= val;
            indexInEntryList += val;
        }
        
        if (totalEvent > 0) {
            
            NSMutableArray* entires = [[NSMutableArray alloc]init];
            for (int i = 0;i < totalEvent;i++) {
                [entires addObject:[[DataManager sharedDataManager].entryList objectAtIndex:indexInEntryList+i]];
            }
            
            TileData* tileData = [[TileData alloc]initWithEntryList:entires 
                                                            randVal:arc4random() 
                                                   indexInEntryList:indexInEntryList];
            
            [_tileDataForCell addObject:tileData];
        }

    }
    
    [self.tableView reloadData];
}

-(void)getUserEntryListWithUserId:(NSString*)userId{
    
    [_JHAppDelegate ASIHttpRequest_GetUserEntryListWithUserId:userId viewController:self];
}

- (void)reloadSearchResult{

    if (_user && _user != [DataManager sharedDataManager].user) {
        [self getUserEntryListWithUserId:_user.userId.stringValue];
        
        return;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [DataManager getSelectedDate];
    NSString* dateStr = [dateFormat stringFromDate:date];
    NSLog(@"Date: %@",dateStr);
    
    CLLocationCoordinate2D coord = _locationManager.location.coordinate;
    

    Category* cat = [DataManager getSelectedCategory];
    
    [_JHAppDelegate ASIHttpRequest_GetEntryListWithLati:[NSString stringWithFormat:@"%f",coord.latitude]
                                                  longi:[NSString stringWithFormat:@"%f",coord.longitude] 
                                           min_distance:@"" 
                                           max_distance:[NSString stringWithFormat:@"%f",_distant] 
                                               min_date:@""
                                               max_date:dateStr
                                               category:cat.categoryId.stringValue
                                         viewController:self]; 

  
}

- (IBAction)refreshTapped:(UIBarButtonItem *)sender {
    
    [self reloadSearchResult];
}

- (void)updateButtons{
    
    if (self.buttonView.subviews.count == 0) {
        
        [self setupButtons];
    }
    
    if ([DataManager sharedDataManager].categoryList.count ==0)return;
    
    for (UIButton* button in self.buttonView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            
            switch (button.tag) {

                case 2:
                {
                    //Place Button
                    [button setTitle:[DataManager getPlaceCategoryNameById:[DataManager sharedDataManager].selectedPlace] forState:UIControlStateNormal];
                }
                    break;
                    
                case 3:
                {
                    //Date Button
                    MyDate* myDate = [[DataManager sharedDataManager].dateList objectAtIndex:[DataManager sharedDataManager].selectedDate];
                    [button setTitle:myDate.name forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void) showActionSheet:(id)sender forEvent:(UIEvent*)event{
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
            
        case 2:
        {
            TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"location"];
            
            for (int i = 0; i < 6; i++) {
                
                [actionSheet addButtonWithTitle:[DataManager getPlaceCategoryNameById:i] block:^{
                    
                    NSLog(@"Place: %@",[DataManager getPlaceCategoryNameById:i]);
                    
                    [button setTitle:[DataManager getPlaceCategoryNameById:i] forState:UIControlStateNormal];
                    [DataManager sharedDataManager].selectedPlace = i; 
                    
                    [self reloadSearchResult];
                }];
            }
            
            [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
            actionSheet.cornerRadius = 5;
            [actionSheet showWithTouch:event];
        }
            break;
            
        case 3:
        {
            TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"time"];
  
            NSArray* list = [DataManager sharedDataManager].dateList;
            for (MyDate* myDate in list) {
                
                [actionSheet addButtonWithTitle:myDate.name block:^{
                    
                    NSLog(@"Date: %@",myDate.name);
                    [button setTitle:myDate.name forState:UIControlStateNormal];
                    [DataManager sharedDataManager].selectedDate = [list indexOfObject:myDate];
                    
                    [self reloadSearchResult];
                }];
            }
            
            [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
            actionSheet.cornerRadius = 5;
            [actionSheet showWithTouch:event];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SearchBarDelegate

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    
//    _searchString = searchText;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _searchString =  searchBar.text;
    //Search engine here.
    [_JHAppDelegate ASIHttpRequest_SearchEntryWithText:_searchString viewController:self];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    _searchString = @"";
    [self setSearchHidden:YES animated:YES];
}

- (IBAction)showSearchBar:(id)sender {
    
    if (_searchBar.hidden) {
        [self setSearchHidden:NO animated:YES];
    }
    else {
        [self setSearchHidden:YES animated:YES];
    }
}

- (void)setSearchHidden:(BOOL)hidden animated:(BOOL)animated {
    
    UISearchBar *searchBar = _searchBar;
    
    //Move searchBar up!
    [self scrollViewDidScroll:nil];
    
    if (searchBar.hidden == hidden)return;
    
    CGFloat searchBarHeight = searchBar.frame.size.height;
    
    CGFloat offset = (hidden)? -searchBarHeight : 0;
    NSTimeInterval duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        
        searchBar.frame = CGRectOffset(searchBar.frame, 0.0, offset);
        
    } completion:^(BOOL finished) 
     {
         searchBar.hidden = hidden;
         if (!hidden) [searchBar becomeFirstResponder];
         else [searchBar resignFirstResponder];
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

        CGRect newFrame = _searchBar.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.tableView.contentOffset.y;
        _searchBar.frame = newFrame;
}

#pragma mark - ViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _tileDataForCell = [[NSMutableArray alloc]init];
        
        [DataManager sharedDataManager].entryList = [[NSMutableArray alloc]init];
        
        _distant = 1000000;
        
        _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self updateButtons];
    
    [self setSearchHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //Location Manager
    {
        //Instantiate a location object.
        _locationManager = [[CLLocationManager alloc] init];
        
        //Make this controller the delegate for the location manager.
        [_locationManager setDelegate:self];
        
        //Set some parameters for the location object.
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];   
    }

    [self setupButtons];
    
    if ((UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPhone))
    {
        self.tableView.rowHeight = 768/2;
    }
}

- (void)setupButtons{

    CGRect rect = self.buttonView.frame;
    float width = rect.size.width/3;
    float height = 30;
    
    float x = 0;
    float y = 0;
    
    CGRect frame;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        categoryButton = topButton;
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        //[topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"Category" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 1;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        frame = topButton.titleLabel.frame;
    }
    
    x+=width;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"location" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 2;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        topButton.titleLabel.frame = frame;
    }
    
    x+=width;
    {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topButton addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        topButton.frame = CGRectMake(x,y, width, height);
        [topButton setTitle:@"time" forState:UIControlStateNormal];
        topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.buttonView addSubview:topButton];
        topButton.tag = 3;
        topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        topButton.titleLabel.textAlignment = UITextAlignmentCenter;
        topButton.titleLabel.frame = frame;
    }
}

- (void)viewDidUnload{
    [self setButtonView:nil];
    [self setButtonView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView != self.tableView)return 0;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(tableView != self.tableView)return 0;
    
    return _tileDataForCell.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Not searhing
    static NSString *CellIdentifierDate = @"TileCodeCell";

    TileCell *cell = (TileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierDate];
    cell.contentView.tag = indexPath.row;
    cell.delegate = self;
        
    //Clear old value
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row < _tileDataForCell.count)
    {    
        TileData* tileData = [_tileDataForCell objectAtIndex:indexPath.row];
        
        [cell setEntries:tileData.entryList withRandVal:tileData.randVal];
        
        for (int i = 0; i < tileData.entryList.count; i++) {
            
            Entry* entry = [tileData.entryList objectAtIndex:i];
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!entry.cacheThumnail)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    NSIndexPath* downLoadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:i];
                    
                    ImageLoad* imageLoad = [[ImageLoad alloc]initWithURL:[entry getPreviewURL]];
                    [self startIconDownload:imageLoad forIndexPath:downLoadIndexPath];
                }       
            }
            else
            {
                [cell setImage:entry.cacheThumnail forImageTag:1+i];
            }
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected (%d,%d)",indexPath.row,indexPath.section);
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ImageLoad *)imageLoad forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imageLoad = imageLoad;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload]; 
    }
    else {
        if (iconDownloader.imageConnection==nil) {
            [iconDownloader startDownload];
        }
    }
    
    NSLog(@"indexPath = (%d,%d)",indexPath.row,indexPath.section);
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows{
    NSLog(@"loadImagesForOnscreenRows");
    if (_tileDataForCell.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
        {
            TileData* tileData = [_tileDataForCell objectAtIndex:indexPath.row];

            for (int i = 0; i < tileData.entryList.count; i++) {
                
                Entry *entry = [tileData.entryList objectAtIndex:i];
                
                if (!entry.cacheThumnail) // avoid the app icon download if the app already has an icon
                {
                    NSIndexPath* imagePath = [NSIndexPath indexPathForRow:indexPath.row inSection:i];

                    ImageLoad* imageLoad = [[ImageLoad alloc]initWithURL:[entry getPreviewURL]];
                    [self startIconDownload:imageLoad forIndexPath:imagePath];
                }
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath{
    NSLog(@"appImageDidLoad");
    
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader != nil)
    {
        TileData* tileData = [_tileDataForCell objectAtIndex:indexPath.row];
        Entry* entry = [tileData.entryList objectAtIndex:indexPath.section];
        
        entry.cacheThumnail = iconDownloader.imageLoad.image;

        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnscreenRows];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TileEventDetailSegue"]) 
    {
        DetailViewController *detailController = segue.destinationViewController;
        
        if ([detailController isKindOfClass:[DetailViewController class]]) {
            
            NSIndexPath* indexPath = (NSIndexPath*)sender;
            
            TileData* tileData = [_tileDataForCell objectAtIndex:indexPath.row];
            
            Entry* entry = [tileData.entryList objectAtIndex:indexPath.section-1];
            detailController.entry = entry;
        }
    }
}

-(void)performSegueWithEventIndex:(NSIndexPath*)eventIndex{
    
    [self performSegueWithIdentifier:@"TileEventDetailSegue" sender:eventIndex];
}

#pragma mark - CategoryPicker

- (void)selectCategory:(id)sender{
    [self performSegueWithIdentifier:@"CategorySegue" sender:self];
}

- (void)setCategory:(NSString*)categoryId{
    
    Category* category = [DataManager getCategoryById:categoryId];
    [DataManager sharedDataManager].selectedCategory = category.categoryId.intValue;
    categoryButton.titleLabel.text = category.name;
    [categoryButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    [self reloadSearchResult];
}


@end
