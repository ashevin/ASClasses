//
//  ASBitmap.m
//  PlayGround
//
//  Created by Avi Shevin on 1/22/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASColorBitmap.h"

@implementation ASColorBitmap
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    bitmap = malloc(height * width * 4);
    
    NSUInteger bpp = 4;
    NSUInteger bpr = bpp * width;
    NSUInteger bpc = 8;
    
    CGContextRef context =
      CGBitmapContextCreate(bitmap, width, height, bpc, bpr, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
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
  NSUInteger r, g, b, a;
  
  NSUInteger index = point.y * width * 4 + point.x * 4;
  
  r = (char) bitmap[index];
  g = (char) bitmap[index + 1];
  b = (char) bitmap[index + 2];
  a = (char) bitmap[index + 3];
  
  return ASPixelMake(r, g, b, a);
}

@end