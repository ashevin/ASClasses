//
//  ASTriangleButton.m
//  PlayGround
//
//  Created by Avi Shevin on 2/7/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASTriangleButton.h"

@implementation ASTriangleButton

- (void) drawRect:(CGRect)rect
{
  CGPoint a, b, c;

  switch ( self.triangleDirection )
  {
    case ASTriangleButtonDirectionLeft:
      a = CGPointMake(0, self.frame.size.height / 2.0);
      b = CGPointMake(self.frame.size.width, 0);
      c = CGPointMake(self.frame.size.width, self.frame.size.height);
      break;

    case ASTriangleButtonDirectionRight:
      a = CGPointMake(0, 0);
      b = CGPointMake(self.frame.size.width, self.frame.size.height / 2.0);
      c = CGPointMake(0, self.frame.size.height);
      break;

    case ASTriangleButtonDirectionUp:
      a = CGPointMake(0, self.frame.size.height);
      b = CGPointMake(self.frame.size.width / 2.0, 0);
      c = CGPointMake(self.frame.size.width, self.frame.size.height);
      break;

    case ASTriangleButtonDirectionDown:
      a = CGPointMake(0, 0);
      b = CGPointMake(self.frame.size.width, 0);
      c = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height);
      break;

    default:
      a = CGPointMake(0, self.frame.size.height / 2.0);
      b = CGPointMake(self.frame.size.width, 0);
      c = CGPointMake(self.frame.size.width, self.frame.size.height);
      break;
  }
  
  CGContextRef ref = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(ref, self.fillColor.CGColor);
  CGContextSetStrokeColorWithColor(ref, self.strokeColor.CGColor);
  
  CGMutablePathRef triangle = CGPathCreateMutable();

  CGPathMoveToPoint(triangle, NULL, a.x, a.y);
  CGPathAddLineToPoint(triangle, NULL, b.x, b.y);
  CGPathAddLineToPoint(triangle, NULL, c.x, c.y);
  CGPathCloseSubpath(triangle);

  CGContextAddPath(ref, triangle);
  CGContextFillPath(ref);
  //CGContextDrawPath(ref, kCGPathFillStroke);
  
  CGPathRelease(triangle);
}

- (void) setTriangleDirection:(ASTriangleButtonDirection)triangleDirection
{
  _triangleDirection = triangleDirection;
  
  [self setNeedsDisplay];
}

- (void) setFillColor:(UIColor *)fillColor
{
  _fillColor = fillColor;
  
  [self setNeedsDisplay];
}

- (void) setStrokeColor:(UIColor *)strokeColor
{
  _strokeColor = strokeColor;
  
  [self setNeedsDisplay];
}

@end
