//
//  TileCell.h
//  TileTable
//
//  Created by Numpol Poldongnok on 6/11/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TilesController.h"


@interface TileCell : UITableViewCell

@property (nonatomic,assign) id <TilesControllerDelegate> delegate;

-(void)setEntries:(NSArray *)entires withRandVal:(int)randVal;

-(void)setImage:(UIImage *)image forImageTag:(int)imageTag;

@end
