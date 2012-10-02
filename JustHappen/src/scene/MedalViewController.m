//
//  MedalViewController.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/13/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "MedalViewController.h"
#import "DataManager.h"
#import "DataModel.h"
#import "MedalCell.h"

@interface MedalViewController ()
{
    NSArray* _medals;
}

@end

@implementation MedalViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _medals = [DataManager sharedDataManager].medalList;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    int total = _medals.count;
    while (total>4) {
        total-=4;
        count++;
    }
    if (total>0)count++;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MedalCell";
    MedalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    int offset = indexPath.row;
    
    // Configure the cell...
//    if (indexPath.row==0) 
//    {
//        int val = offset;
//        Medal* medal = [_medals objectAtIndex:val];
//        UIView* view = cell.view1;
//        [self setMedal:medal view:view image:[UIImage imageNamed:@"default_photo_a.png"]];
//        
//
//        val++;
//        view = cell.view2;
//        if (val < _medals.count) {
//            medal = [_medals objectAtIndex:val];
//            
//            [self setMedal:medal view:view image:[UIImage imageNamed:@"medal_copper.png"]];
//        }else view.alpha = 0;
//        
//        val++;
//        view = cell.view3;
//        if (val < _medals.count) {
//            medal = [_medals objectAtIndex:val];
//            
//            [self setMedal:medal view:view image:[UIImage imageNamed:@"medal_copper.png"]];
//        }else view.alpha = 0;
//
//        val++;
//        view = cell.view4;
//        if (val < _medals.count) {
//            medal = [_medals objectAtIndex:val];
//            
//            [self setMedal:medal view:view image:[UIImage imageNamed:@"medal_copper.png"]];
//        }else view.alpha = 0;
//    }
    Medal* medal = [_medals objectAtIndex:offset*4 + 0];
    UIView* view = cell.view1;
    [self setMedal:medal view:view image: medal.imageFile ];
    
    medal = [_medals objectAtIndex:offset*4 + 1];
    view = cell.view2;
    [self setMedal:medal view:view image: medal.imageFile ];
    
    medal = [_medals objectAtIndex:offset*4 + 2];
    view = cell.view3;
    [self setMedal:medal view:view image: medal.imageFile ];
    
    medal = [_medals objectAtIndex:offset*4 + 3];
    view = cell.view4;
    [self setMedal:medal view:view image: medal.imageFile ];
    
    return cell;
}

-(void)setMedal:(Medal*)medal view:(UIView*)view image:(UIImage*)image{
    
    BOOL haveMedal = NO;
    NSArray* userMedals = [DataManager sharedDataManager].user.medal;
    for (Medal* myMedal in userMedals) {
        if ([myMedal.medalId isEqualToNumber:medal.medalId]) {
            haveMedal = YES;
            break;
        }
    }
    
    if (medal){
        for (id obj in view.subviews) 
        {
            if ([obj isKindOfClass:[UIImageView class]]) 
            {
                UIImageView* imageView = (UIImageView*)obj;
                imageView.image = image;
                if (haveMedal==NO){
                    imageView.alpha = 1.0f;
                    //imageView.backgroundColor = [UIColor grayColor];
                }
            }
            if ([obj isKindOfClass:[UILabel class]]) 
            {
                ((UILabel*)obj).text = medal.name;
            }
        }
    }else
        view.alpha = 0;

}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return Nil;
}

@end
