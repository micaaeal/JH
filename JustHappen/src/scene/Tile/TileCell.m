//
//  TileCell.m
//  TileTable
//
//  Created by Numpol Poldongnok on 6/11/55 BE.
//  Copyright (c) 2555 Tontanii-Studio. All rights reserved.
//

#import "TileCell.h"
#import "DataModel.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/CALayer.h>

@interface TileCell ()
{
    int _imageTag;
}
@end

@implementation TileCell

@synthesize delegate;

#pragma mark Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)sourceImage
{

    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

-(void)addImageWithFrame:(CGRect)rect andEntry:(Entry*)entry{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIImage* img = [UIImage imageNamed:@"placeholder.png"];
    imageView.image = img;
    
    [self.contentView addSubview:imageView];

    imageView.userInteractionEnabled = YES;
    imageView.tag = _imageTag;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tgr.delegate = self;
    [imageView addGestureRecognizer:tgr];
    
    [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [imageView.layer setBorderWidth: 2.0];
    
    _imageTag++;
}

-(void)setImage:(UIImage *)image forImageTag:(int)imageTag{
    
    //NSLog(@"Subviews = %d",self.contentView.subviews.count);
    for (UIImageView* imageView in self.contentView.subviews) {
        
        if ([image isKindOfClass:[UIImage class]]==NO) {
            continue;
        }

        if (imageView.tag == imageTag) {
            image = [self imageByScalingAndCroppingForSize:imageView.frame.size image:image];
            imageView.image = image;
        }
    }
}
- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"Image Tapped!");
 
    UIImageView *imageView = (UIImageView *)tapGestureRecognizer.view;
    UIView* containtView = (UIView*)imageView.superview;
    
    int row = containtView.tag;
    int section = tapGestureRecognizer.view.tag;
    
    NSLog(@"(%d,%d)",row,section);
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [delegate performSegueWithEventIndex:indexPath];
    
    
    /*
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{ tapGestureRecognizer.view.alpha = 0.5; } 
                     completion:^(BOOL finished) {
                         
                         NSLog(@"Fade finish..");
 
                         UIImageView *imageView = (UIImageView *)tapGestureRecognizer.view;
                         UIView* containtView = (UIView*)imageView.superview;

                         int row = containtView.tag;
                         int section = tapGestureRecognizer.view.tag;
                         
                         NSLog(@"(%d,%d)",row,section);
                         
                         NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                         [delegate performSegueWithEventIndex:indexPath];
                         
                     }];
     */
}

-(void)setEntries:(NSArray *)entires withRandVal:(int)randVal
{
    _imageTag = 1;
    int count = entires.count;
    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)) {
        
        if (entires.count <= 2) {
            int width = 320/2;
            if (count > 0)[self addImageWithFrame:CGRectMake(0, 0, width, width) andEntry:[entires objectAtIndex:0]];
            if (count > 1)[self addImageWithFrame:CGRectMake(width, 0, width, width) andEntry:[entires objectAtIndex:1]];
        }
        else {
            int width = 320/4;
            if (count > 0)[self addImageWithFrame:CGRectMake(0, 0, width, width) andEntry:[entires objectAtIndex:0]];
            if (count > 1)[self addImageWithFrame:CGRectMake(0, width, width, width) andEntry:[entires objectAtIndex:1]];
            if (count > 2)[self addImageWithFrame:CGRectMake(width, 0, width, width) andEntry:[entires objectAtIndex:2]];
            if (count > 3)[self addImageWithFrame:CGRectMake(width, width, width, width) andEntry:[entires objectAtIndex:3]];
            if (count > 4)[self addImageWithFrame:CGRectMake(width*2, 0, width, width) andEntry:[entires objectAtIndex:4]];
            if (count > 5)[self addImageWithFrame:CGRectMake(width*2, width, width, width) andEntry:[entires objectAtIndex:5]];
            if (count > 6)[self addImageWithFrame:CGRectMake(width*3, 0, width, width) andEntry:[entires objectAtIndex:6]];
            if (count > 7)[self addImageWithFrame:CGRectMake(width*3, width, width, width) andEntry:[entires objectAtIndex:7]];
        }
    }
    else {
        if (entires.count <= 2) {
            int width = 768/2;
            if (count > 0)[self addImageWithFrame:CGRectMake(0, 0, width, width) andEntry:[entires objectAtIndex:0]];
            if (count > 1)[self addImageWithFrame:CGRectMake(width, 0, width, width) andEntry:[entires objectAtIndex:1]];
        }
        else {
            int width = 768/4;
            if (count > 0)[self addImageWithFrame:CGRectMake(0, 0, width, width) andEntry:[entires objectAtIndex:0]];
            if (count > 1)[self addImageWithFrame:CGRectMake(0, width, width, width) andEntry:[entires objectAtIndex:1]];
            if (count > 2)[self addImageWithFrame:CGRectMake(width, 0, width, width) andEntry:[entires objectAtIndex:2]];
            if (count > 3)[self addImageWithFrame:CGRectMake(width, width, width, width) andEntry:[entires objectAtIndex:3]];
            if (count > 4)[self addImageWithFrame:CGRectMake(width*2, 0, width, width) andEntry:[entires objectAtIndex:4]];
            if (count > 5)[self addImageWithFrame:CGRectMake(width*2, width, width, width) andEntry:[entires objectAtIndex:5]];
            if (count > 6)[self addImageWithFrame:CGRectMake(width*3, 0, width, width) andEntry:[entires objectAtIndex:6]];
            if (count > 7)[self addImageWithFrame:CGRectMake(width*3, width, width, width) andEntry:[entires objectAtIndex:7]];
        }
    } 
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        _imageTag = 1;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
