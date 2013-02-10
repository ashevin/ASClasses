//
//  ASHitTest.m
//  PlayGround
//
//  Created by Avi Shevin on 1/23/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASHitTester.h"
#import "ASGrayscaleBitmap.h"
#import "ASGraphics.h"


@implementation ASHitTester
{
  ASGrayscaleBitmap *bitmap;
  NSArray *regionsList;
}

- (id) initWithImage:(UIImage *)image andRegions:(NSArray *)regions
{
  if ( ( self = [super init] ) )
  {
    bitmap = [[ASGrayscaleBitmap alloc] initWithImage:image];
    regionsList = regions;
  }
  
  return self;
}

- (NSInteger) hitTest:(CGPoint)point
{
  NSLog(@"pixel color: %@", [bitmap pixelAt:point]);
  
  for ( int i = 0; i < regionsList.count; i++ )
    for ( ASPoint *p in regionsList[i] )
      if ( isInRegion(bitmap, point, p) )
        return i;
  
  return -1;
}

// Algorithm:
//    Calculate the line between the tapped point and the "center" point for the region.
//    Iterate over each pair of points which falls on the line.  If a point is black, the tap was not in the region.
//    The line is solved for both x and y to ensure that every pair of points (with an integer x and y) on the line is visited.
//    Tests are done for horizontal and vertical lines to avoid invalid calculations.
BOOL isInRegion(ASGrayscaleBitmap *bitmap, CGPoint target, ASPoint *center)
{
  double m = (center.y - target.y) / (center.x - target.x);
  double b = (-m * target.x) + target.y;
  
  double minX = MIN(target.x, center.x);
  double maxX = MAX(target.x, center.x);
  
  double minY = MIN(target.y, center.y);
  double maxY = MAX(target.y, center.y);
  
  NSLog(@"hitX = %f, hitY = %f", target.x, target.y);
  NSLog(@"midX = %f, midY = %f", center.x, center.y);
  NSLog(@"m = %f, b = %f", m, b);
  
  ASPixel *black = ASPixelMake(0, 0, 0, 0);
  
  // Line is vertical, so x is static.
  if ( target.x == center.x )
  {
    for ( int i = minY; i <= maxY; i++ )
      if ( [black isEqualToColorOfPixel:[bitmap pixelAt:CGPointMake(minX, i)]] )
        return NO;

    return YES;
  }

  // Line is horizontal, so y is static.
  if ( target.y == center.y )
  {
    for ( int i = minX; i <= maxX; i++ )
      if ( [black isEqualToColorOfPixel:[bitmap pixelAt:CGPointMake(i, minY)]] )
        return NO;

    return YES;
  }

  NSLog(@"Solving for y.");
  for ( int i = minX; i <= maxX; i++ )
  {
    NSLog(@"x = %d, y = %f", i, m * i + b);

    if ( [black isEqualToColorOfPixel:[bitmap pixelAt:CGPointMake(i, floor(m * i + b))]] )
      return NO;
  }

  NSLog(@"Solving for x.");
  for ( int i = minY; i <= maxY; i++ )
  {
    NSLog(@"x = %f, y = %d", (i - b) / m, i);

    if ( [black isEqualToColorOfPixel:[bitmap pixelAt:CGPointMake(floor((i - b) / m), i)]] )
      return NO;
  }
  
  return YES;
}

@end