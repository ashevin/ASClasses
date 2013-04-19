//
//  ASGraphics.m
//  PlayGround
//
//  Created by Avi Shevin on 1/25/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASGraphics.h"

#pragma mark - ASPixel

ASPixel* ASPixelMake(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha)
{
  ASPixel *p = [[ASPixel alloc] init];
  
  p.red = red;
  p.green = green;
  p.blue = blue;
  p.alpha = alpha;
  
  return p;
}

@implementation ASPixel

- (NSString *) description
{
  return [NSString stringWithFormat:@"{ r = %x, g = %x, b = %x, alpha = %x }", self.red, self.green, self.blue, self.alpha];
}

- (BOOL) isEqualToColorOfPixel:(ASPixel *)pixel
{
  return ( self.red == pixel.red && self.green == pixel.green && self.blue == pixel.blue );
}

@end

#pragma mark - ASPoint

ASPoint* ASPointMake(float x, float y)
{
  ASPoint *p = [[ASPoint alloc] init];
  
  p.x = x;
  p.y = y;
  
  return p;
}

ASPoint* ASPointFromCGPoint(CGPoint cgPoint)
{
  ASPoint *p = [[ASPoint alloc] init];
  
  p.x = floor(cgPoint.x);
  p.y = floor(cgPoint.y);
  
  return p;
}

@implementation ASPoint

@synthesize x = _x;
@synthesize y = _y;

- (NSString *) description
{
  return [NSString stringWithFormat:@"{ x = %.0f, y = %.0f }", self.x, self.y];
}

- (void) setX:(float)x
{
  _x = floor(x);
}

- (void) setY:(float)y
{
  _y = floor(y);
}

- (CGPoint) point
{
  return CGPointMake(_x, _y);
}

@end