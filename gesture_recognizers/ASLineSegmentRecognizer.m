//
//  ASLineSegmentRecognizer.m
//  GestureRecognizerCollection
//
//  Created by Avi Shevin on 7/28/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASLineSegmentRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ASLineSegmentRecognizer
{
  CGPoint startingPoint;
  
  NSMutableArray *directions;
  ASSegmentDirection currentDirection;
  
  NSDictionary *EnumToTextMap;

  NSInteger currentProcessSegment;
  NSInteger currentProcessDirection;
  
  BOOL sawEnd;
}

- (id) initWithTarget:(id)target action:(SEL)action
{
  self = [super initWithTarget:target action:action];
  if ( self )
  {
    EnumToTextMap =
      @{
        @(0) : @"ASSegmentDirectionUnknown",
        @(1) : @"ASSegmentDirectionUp",
        @(2) : @"ASSegmentDirectionDown",
        @(3) : @"ASSegmentDirectionLeft",
        @(4) : @"ASSegmentDirectionRight",
        @(5) : @"ASSegmentDirectionUpRight",
        @(6) : @"ASSegmentDirectionUpLeft",
        @(7) : @"ASSegmentDirectionDownRight",
        @(8) : @"ASSegmentDirectionDownLeft",
      };
    
    self.minSegmentLength = 15.0;
    self.variance = 10.0;
  }

  return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  startingPoint = [[touches anyObject] locationInView:self.view];
  
  NSLog(@"startingPoint: %@", NSStringFromCGPoint(startingPoint));
  
  directions = [[NSMutableArray alloc] init];
  currentDirection = ASSegmentDirectionUnknown;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint movementPoint = [[touches anyObject] locationInView:self.view];
  CGFloat distance = sqrtf(powf(movementPoint.x - startingPoint.x, 2) + powf(movementPoint.y - startingPoint.y, 2));
  
  CGFloat varFromZero = self.variance;
  CGFloat varFrom90 = (90 - varFromZero);
  
  ASSegmentDirection direction = ASSegmentDirectionUnknown;

  if ( distance <= self.minSegmentLength )
    return;
  
  if ( fabs(movementPoint.x - startingPoint.x) == 0.0 ) // Slope is undefined, so movement is either up or down.
  {
    if ( movementPoint.y < startingPoint.y )
      direction = ASSegmentDirectionUp;
    else
      direction = ASSegmentDirectionDown;
  }
  else
  {
    // Calculate m and theta (angle) of slope.
    CGFloat m = (startingPoint.y - movementPoint.y) / (movementPoint.x - startingPoint.x);
    CGFloat theta = atan(m) * 180.0 / M_PI;
    
    NSLog(@"starting: %@, movement: %@", NSStringFromCGPoint(startingPoint), NSStringFromCGPoint(movementPoint));
    NSLog(@"m = %f, theta = %f, distance = %f", m, theta, distance);
    
    if ( ( theta > 0.0 ) )  // Movement is either up+right or down+left.
    {
      if ( movementPoint.x > startingPoint.x )
      {
        if ( theta <= varFromZero )  // Wiggle room.
          direction = ASSegmentDirectionRight;
        else if ( theta >= varFrom90 )
          direction = ASSegmentDirectionUp;
        else
          direction = ASSegmentDirectionUpRight;
      }
      else
      {
        if ( theta <= varFromZero )  // Wiggle room.
          direction = ASSegmentDirectionLeft;
        else if ( theta >= varFrom90 )
          direction = ASSegmentDirectionDown;
        else
          direction = ASSegmentDirectionDownLeft;
      }
    }
    else if ( theta == 0.0 )  // Movement is horizontal.
    {
      if ( movementPoint.x > startingPoint.x )
        direction = ASSegmentDirectionRight;
      else
        direction = ASSegmentDirectionLeft;
    }
    else   // Movement is either up+left or down+right.
    {
      if ( movementPoint.x > startingPoint.x )
      {
        if ( theta >= -varFromZero )  // Wiggle room.
          direction = ASSegmentDirectionRight;
        else if ( theta <= -varFrom90 )
          direction = ASSegmentDirectionDown;
        else
          direction = ASSegmentDirectionDownRight;
      }
      else
      {
        if ( theta >= -varFromZero )  // Wiggle room.
          direction = ASSegmentDirectionLeft;
        else if ( theta <= -varFrom90 )
          direction = ASSegmentDirectionUp;
        else
          direction = ASSegmentDirectionUpLeft;
      }
    }
  }
  
  startingPoint = movementPoint;
  
  if ( currentDirection != direction )
  {
    currentDirection = direction;
    [directions addObject:@(currentDirection)];
    
    NSLog(@"direction: %@", EnumToTextMap[@(currentDirection)]);
    
    if ( [self.lineSegmentDelegate respondsToSelector:@selector(lineSegmentRecognizer:didStartDirection:)] )
      [self.lineSegmentDelegate lineSegmentRecognizer:self didStartDirection:direction];
    
    self.state = [self processDirectionsGestureComplete:NO];
  }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.state = [self processDirectionsGestureComplete:YES];

  [self reset];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self reset];
}

- (void)reset
{
  startingPoint = CGPointZero;
  currentDirection = ASSegmentDirectionUnknown;
  directions = nil;
  
  currentProcessDirection = currentProcessSegment = 0;
  sawEnd = NO;
}

- (UIGestureRecognizerState)processDirectionsGestureComplete:(BOOL)complete
{
  NSString *currDir = EnumToTextMap[directions.lastObject];
  NSString *prevDir;
  if ( directions.count > currentProcessDirection + 1 )
    prevDir = EnumToTextMap[directions[directions.count - 2]];

  UIGestureRecognizerState state = self.state;
  
  if ( ! complete )
  {
    if ( sawEnd )
    {
      if ( ( ! [self.rules[currentProcessSegment][@"end"] containsObject:currDir] ) ||
           ( self.rules[currentProcessSegment][prevDir] == nil ) )
      {
        sawEnd = NO;
        prevDir = nil;
        
        currentProcessSegment++;
        currentProcessDirection = directions.count - 1;
      }
    }
    
    // We've run out of rules, but the gesture isn't complete.
    if ( currentProcessSegment == self.rules.count )
      return UIGestureRecognizerStateFailed;
    
    if ( prevDir == nil )
      state = ( [self.rules[currentProcessSegment][@"start"] containsObject:currDir] ) ? UIGestureRecognizerStatePossible : UIGestureRecognizerStateFailed ;
    else
      state = ( [self.rules[currentProcessSegment][prevDir] containsObject:currDir] ) ? UIGestureRecognizerStatePossible : UIGestureRecognizerStateFailed ;
    
    if ( [self.rules[currentProcessSegment][@"end"] containsObject:currDir] )
      sawEnd = YES;
    
    return state;
  }
  else
  {
    return ( ( currentProcessSegment == self.rules.count || sawEnd ) && ( self.state == UIGestureRecognizerStatePossible ) )
      ? UIGestureRecognizerStateEnded
      : UIGestureRecognizerStateFailed;
  }
  
  return UIGestureRecognizerStateFailed;
}

- (NSString *) nameForDirection:(ASSegmentDirection)direction
{
  return EnumToTextMap[@(direction)];
}

@end
