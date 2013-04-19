//
//  ASTriangleButton.m
//  PlayGround
//
//  Created by Avi Shevin on 2/7/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASTriangleButton.h"

typedef void (*PointFunction)(id, CGPoint *, CGPoint *, CGPoint *);

@implementation ASTriangleButton

- (id) initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  return [self finishInit];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  
  return [self finishInit];
}

- (id) finishInit
{
  if ( self )
  {
    if ( self.fillColor == nil )
      self.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];

    if ( self.strokeColor == nil )
      self.strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
  }
  
  return self;
}

- (void) drawRect:(CGRect)rect
{
  static PointFunction pointFunctions[5] = { pointsForLeft, pointsForRight, pointsForUp, pointsForDown, pointsForArbitrary };
  
  CGPoint a, b, c;

  pointFunctions[self.triangleDirection](self, &a, &b, &c);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  if ( self.triangleDirection == ASTriangleButtonDirectionArbitrary )
  {
    CGPoint center = CGPointMake(b.x, a.y - (a.y - b.y) / 3);

    CGContextTranslateCTM (ctx, center.x, center.y);
    CGContextRotateCTM (ctx, self.angle);
    CGContextTranslateCTM (ctx, -center.x, -center.y);
  }
  
  if ( self.state == UIControlStateHighlighted )
  {
    CGFloat h, s, br, alpha;
    
    [self.fillColor getHue:&h saturation:&s brightness:&br alpha:&alpha];
    
    UIColor *color = [UIColor colorWithHue:h saturation:s brightness:br + 0.2 alpha:alpha];
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
  }
  else
  {
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
  }
  
  CGMutablePathRef triangle = CGPathCreateMutable();

  CGPathMoveToPoint(triangle, NULL, a.x, a.y);
  CGPathAddLineToPoint(triangle, NULL, b.x, b.y);
  CGPathAddLineToPoint(triangle, NULL, c.x, c.y);
  CGPathCloseSubpath(triangle);

  CGContextAddPath(ctx, triangle);
  CGContextDrawPath(ctx, kCGPathFillStroke);
  
  CGPathRelease(triangle);
}

void pointsForLeft(ASTriangleButton *tri, CGPoint *a, CGPoint *b, CGPoint *c)
{
  *a = CGPointMake(0, tri.frame.size.height / 2.0);
  *b = CGPointMake(tri.frame.size.width, 0);
  *c = CGPointMake(tri.frame.size.width, tri.frame.size.height);
}

void pointsForRight(ASTriangleButton *tri, CGPoint *a, CGPoint *b, CGPoint *c)
{
  *a = CGPointMake(0, 0);
  *b = CGPointMake(tri.frame.size.width, tri.frame.size.height / 2.0);
  *c = CGPointMake(0, tri.frame.size.height);
}

void pointsForUp(ASTriangleButton *tri, CGPoint *a, CGPoint *b, CGPoint *c)
{
  *a = CGPointMake(0, tri.frame.size.height);
  *b = CGPointMake(tri.frame.size.width / 2.0, 0);
  *c = CGPointMake(tri.frame.size.width, tri.frame.size.height);
}

void pointsForDown(ASTriangleButton *tri, CGPoint *a, CGPoint *b, CGPoint *c)
{
  *a = CGPointMake(0, 0);
  *b = CGPointMake(tri.frame.size.width, 0);
  *c = CGPointMake(tri.frame.size.width / 2.0, tri.frame.size.height);
}

void pointsForArbitrary(ASTriangleButton *tri, CGPoint *a, CGPoint *b, CGPoint *c)
{
  if ( tri.baseHeight > 0 && tri.baseWidth > 0 )
  {
    *a = CGPointMake((tri.frame.size.width - tri.baseWidth) / 2.0, tri.frame.size.height - (tri.frame.size.height - tri.baseHeight) / 2.0);
    *b = CGPointMake(tri.frame.size.width / 2, (tri.frame.size.height - tri.baseHeight) / 2.0);
    *c = CGPointMake(tri.frame.size.width - (tri.frame.size.width - tri.baseWidth) / 2.0, tri.frame.size.height - (tri.frame.size.height - tri.baseHeight) / 2.0);
  }
  else
  {
    *a = CGPointMake(0, tri.frame.size.height);
    *b = CGPointMake(tri.frame.size.width / 2.0, 0);
    *c = CGPointMake(tri.frame.size.width, tri.frame.size.height);
  }
}

- (void) setTriangleDirection:(ASTriangleButtonDirection)triangleDirection
{
  _triangleDirection = triangleDirection;
  
  [self setNeedsDisplay];
}

- (void) setFillColor:(UIColor *)fillColor
{
#if ! __has_feature(objc_arc)
  [fillColor retain];
  [_fillColor release];
#endif

  _fillColor = fillColor;
  
  [self setNeedsDisplay];
}

- (void) setStrokeColor:(UIColor *)strokeColor
{
#if ! __has_feature(objc_arc)
  [strokeColor retain];
  [_strokeColor release];
#endif

  _strokeColor = strokeColor;
  
  [self setNeedsDisplay];
}

- (void) setAngle:(float)angle
{
  _angle = angle;
  
  [self setNeedsDisplay];
}

- (void) setBaseHeight:(float)baseHeight
{
  _baseHeight = baseHeight;
  
  [self setNeedsDisplay];
}

- (void) setBaseWidth:(float)baseWidth
{
  _baseWidth = baseWidth;
  
  [self setNeedsDisplay];
}

- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}
 
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self setNeedsDisplay];
}
 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];
  [self setNeedsDisplay];
}
 
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  [self setNeedsDisplay];
  [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}
 
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  [self setNeedsDisplay];
  [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

#if ! __has_feature(objc_arc)

- (void) dealloc
{
  [_fillColor release];
  [_strokeColor release];
  
  [super dealloc];
}

#endif

@end
