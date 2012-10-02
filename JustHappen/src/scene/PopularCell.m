//
//  PopularCell.m
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "PopularCell.h"
#import "DataModel.h"
#import "DataManager.h"

@implementation PopularCell

@synthesize imgIcon = _imgIcon;
@synthesize nameLabel = _nameLabel;

@synthesize imgPreview1 = _imgPreview1;
@synthesize imgPreview2 = _imgPreview2;
@synthesize imgPreview3 = _imgPreview3;
@synthesize imgPreview4 = _imgPreview4;

@synthesize follow1,follow2,follow3,follow4;

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
