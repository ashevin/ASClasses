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

@implementation ASPoint

@synthesize point = _point;

- (id) init
{
  self = [super init];
  if ( self )
    _point = CGPointMake(0, 0);
  
  return self;
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"{ x = %.0f, y = %.0f }", self.x, self.y];
}

- (void) setX:(float)x
{
  _point.x = floor(x);
}

- (void) setY:(float)y
{
  _point.y = floor(y);
}

- (float) x
{
  return _point.x;
}

- (float) y
{
  return _point.y;
}

- (CGPoint) point
{
  return CGPointMake(floor(_point.x), floor(_point.y));
}

@end