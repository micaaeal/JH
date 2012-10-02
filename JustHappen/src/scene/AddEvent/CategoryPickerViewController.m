//
//  CategoryPickerViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 7/3/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "CategoryPickerViewController.h"
#import "CreateEventViewController.h"
#import "DataModel.h"
#import "DataManager.h"

@interface CategoryPickerViewController ()
{
    NSArray* _categoryList;
}
@end

@implementation CategoryPickerViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    _categoryList = [DataManager sharedDataManager].categoryList;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _categoryList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CategoryCell";
    static NSString *CellIdentifier2 = @"AllCell";
    UITableViewCell *cell;

    if (_categoryList.count==indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Category* category = [_categoryList objectAtIndex:indexPath.row];
        cell.textLabel.text = category.name;
        cell.imageView.image = [DataManager getCategoryImageById:category.categoryId.stringValue];
        cell.tag = category.categoryId.intValue;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController* viewCtrl = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [viewCtrl performSelector:@selector(setCategory:) withObject:[NSString stringWithFormat:@"%d",cell.tag]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAllTouchDown:(id)sender {
    
    UIViewController* viewCtrl = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    NSString* catId = @"0";
    [viewCtrl performSelector:@selector(setCategory:) withObject:catId];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
