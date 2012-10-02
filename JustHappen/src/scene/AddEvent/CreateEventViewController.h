//
//  CreateEventViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/29/55 BE.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BeforeNewEventViewController.h"

@class Entry;

@interface CreateEventViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) id <BeforeNewEventViewControllerDelegate> delegate;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (void)uploadEntryFinished:(NSString*)link;
- (void)setCategory:(NSString*)categoryId;

@end
