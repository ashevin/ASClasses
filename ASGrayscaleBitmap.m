//
//  ASGrayscaleBitmap.m
//  PlayGround
//
//  Created by Avi Shevin on 2/6/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASGrayscaleBitmap.h"

@implementation ASGrayscaleBitmap
{
  unsigned char *bitmap;
  
  NSUInteger width;
  NSUInteger height;
}

- (id) initWithImage:(UIImage *)image
{
  if ( ( self = [super init] ) )
  {
    CGImageRef imageRef = image.CGImage;
    
    width = CGImageGetWidth(imageRef);
    height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    bitmap = malloc(height * width);
    
    NSUInteger bpr = width;
    NSUInteger bpc = 8;
    
    CGContextRef context =
      CGBitmapContextCreate(bitmap, width, height, bpc, bpr, colorSpace, 0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
  }
  
  return self;
}

- (void) dealloc
{
  free(bitmap);
}

- (ASPixel *) pixelAt:(CGPoint)point
{
  NSUInteger r;
  
  NSUInteger index = point.y * width + point.x;
  
  r = (char) bitmap[index];
  
  return ASPixelMake(r, r, r, 0);
}

@end
