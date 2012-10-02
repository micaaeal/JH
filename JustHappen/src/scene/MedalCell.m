//
//  MedalCell.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/13/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "MedalCell.h"

@implementation MedalCell
@synthesize  view1,view2,view3,view4;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
