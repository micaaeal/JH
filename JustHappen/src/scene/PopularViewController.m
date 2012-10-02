//
//  PopularViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "PopularViewController.h"
#import "PopularCell.h"
#import "JHAppDelegate.h"
#import "DataModel.h"
#import "DataManager.h"
#import "AccountViewController.h"
#import "PopularListViewController.h"

@interface PopularViewController ()
{
    JHAppDelegate* _JHAppDelegate;
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation PopularViewController

@synthesize imageDownloadsInProgress;
@synthesize popularCategories = _popularCategories;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.popularCategories = [[NSMutableArray alloc]initWithCapacity:10];
    
    _JHAppDelegate = (JHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_JHAppDelegate ASIHttpRequest_GetPopularViewController:self];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _popularCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopularCell";
    PopularCell *popularCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    PopularCategory* popularCategory = [_popularCategories objectAtIndex:indexPath.section];
    
    Category* cat = [DataManager getCategoryById:popularCategory.category];
    
    popularCell.nameLabel.text = [NSString stringWithFormat:@"%@", cat.name];
    popularCell.imgIcon.image = [DataManager getCategoryImageById:cat.categoryId.stringValue];

    
    NSArray* imageViews = [NSArray arrayWithObjects:popularCell.imgPreview1,popularCell.imgPreview2,popularCell.imgPreview3,popularCell.imgPreview4, nil];
    NSArray* followLabels = [NSArray arrayWithObjects:popularCell.follow1,popularCell.follow2,popularCell.follow3,popularCell.follow4, nil];
    for (int i = 0; i < 4; i++) {
        
        UIImageView* imageView = [imageViews objectAtIndex:i];
        User* user = [popularCategory.userList objectAtIndex:i];
        imageView.image = user.cacheThumnail;
        if (!imageView.image) {
            imageView.image = [UIImage imageNamed:@"default_photo_a.png"];
        }
        UILabel* label = [followLabels objectAtIndex:i];
        label.text = user.follower.stringValue;
    }
    
    popularCell.tag = indexPath.section;
    NSLog(@"%d",popularCell.tag);
    return popularCell;
}

- (void)requestComplete:(id)data{
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];

    [_popularCategories removeAllObjects];
    [_popularCategories addObjectsFromArray:data];

    [self.tableView reloadData];
    
    [self performSelector:@selector(loadImagesForOnscreenRows) withObject:nil afterDelay:1];
}

- (IBAction)follow1:(UIButton*)sender {
    UIView* parent = sender.superview.superview.superview;
    int tag = parent.tag;
    NSLog(@"follow1 %d\n",tag);
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:tag];
    [self performSegueWithIdentifier:@"seguePopularAccount" sender:index];
}
- (IBAction)follow2:(UIButton*)sender {
    UIView* parent = sender.superview.superview.superview;
    int tag = parent.tag;
    NSLog(@"follow2 %d\n",tag);
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:tag];
    [self performSegueWithIdentifier:@"seguePopularAccount" sender:index];
}
- (IBAction)follow3:(UIButton*)sender {
    UIView* parent = sender.superview.superview.superview;
    int tag = parent.tag;
    NSLog(@"follow3 %d\n",tag);
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:tag];
    [self performSegueWithIdentifier:@"seguePopularAccount" sender:index];
}
- (IBAction)follow4:(UIButton*)sender {
    UIView* parent = sender.superview.superview.superview;
    int tag = parent.tag;
    NSLog(@"follow4 %d\n",tag);
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:3 inSection:tag];
    [self performSegueWithIdentifier:@"seguePopularAccount" sender:index];
}

- (IBAction)all:(UIButton*)sender {
    UIView* parent = sender.superview.superview;
    int tag = parent.tag;
    NSLog(@"All %d\n",tag);
    
    [self performSegueWithIdentifier:@"segueAll" sender:parent];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"seguePopularAccount"]) {
        
        NSIndexPath* index = (NSIndexPath*)sender;
        
        AccountViewController *accountCtrl = (AccountViewController*)[segue destinationViewController];
        PopularCategory* popularCategory = [_popularCategories objectAtIndex:index.section];
        NSLog(@"row = %d section =%d",index.row,index.section);
        accountCtrl.user = [popularCategory.userList objectAtIndex:index.row];
    }
    else if ([segue.identifier isEqualToString:@"segueAll"]) {
        
        UIView* parent = (UIView*)sender;
        int tag = parent.tag;
        
        PopularCategory* popularCategory = [_popularCategories objectAtIndex:tag];
        PopularListViewController *popularListView = (PopularListViewController*)[segue destinationViewController];
        popularListView.popularList = [[NSMutableArray alloc]initWithArray:popularCategory.userList];

        Category* cat = [DataManager getCategoryById:popularCategory.category];
        
        popularListView.title = [NSString stringWithFormat:@"All popular of %@", cat.name];
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
    if (_popularCategories.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PopularCategory* popCat = [_popularCategories objectAtIndex:indexPath.section];
            
            for (int i = 0;i < popCat.userList.count;i++) {
                User* user = [popCat.userList objectAtIndex:i];
                if (!user.cacheThumnail)
                {
                    NSIndexPath* imagePath = [NSIndexPath indexPathForRow:indexPath.section inSection:i];
                    
                    ImageLoad* imageLoad = [[ImageLoad alloc]initWithURL:user.photoLink];
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
        PopularCategory* popCat = [_popularCategories objectAtIndex:indexPath.row];
        
        if (indexPath.section < popCat.userList.count) {
            User* user = [popCat.userList objectAtIndex:indexPath.section];
            
            user.cacheThumnail = iconDownloader.imageLoad.image;
            
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


@end
