//
//  PopularCell.h
//  JustHappen
//
//  Created by Numpol Poldongnok on 9/2/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) IBOutlet UIImageView *imgPreview1;
@property (nonatomic, strong) IBOutlet UIImageView *imgPreview2;
@property (nonatomic, strong) IBOutlet UIImageView *imgPreview3;
@property (nonatomic, strong) IBOutlet UIImageView *imgPreview4;

@property (strong, nonatomic) IBOutlet UILabel *follow1;
@property (strong, nonatomic) IBOutlet UILabel *follow2;
@property (strong, nonatomic) IBOutlet UILabel *follow3;
@property (strong, nonatomic) IBOutlet UILabel *follow4;

@end
