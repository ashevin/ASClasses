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

ASPoint* ASPointMake(NSUInteger x, NSUInteger y)
{
  ASPoint *p = [[ASPoint alloc] init];
  
  p.x = x;
  p.y = y;
  
  return p;
}

@implementation ASPoint

- (NSString *) description
{
  return [NSString stringWithFormat:@"{ x = %d, y = %d }", self.x, self.y];
}

@end