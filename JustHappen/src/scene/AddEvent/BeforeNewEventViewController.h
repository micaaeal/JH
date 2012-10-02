//
//  BeforeNewEventViewController.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 6/19/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BeforeNewEventViewControllerDelegate <NSObject>

-(void)exitFromChild:(id)sender done:(BOOL)done;

@end 

@interface BeforeNewEventViewController : UIViewController <BeforeNewEventViewControllerDelegate>


@end
