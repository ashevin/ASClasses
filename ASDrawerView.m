//
//  ASDrawerView.m
//  PlayGround
//
//  Created by Avi Shevin on 4/10/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASDrawerView.h"

@interface ASDrawerView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISwipeGestureRecognizer *flickUpRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *flickDownRecognizer;

@end

@implementation ASDrawerView
{
  CGRect pullTabRect;
  BOOL isUp;
}

- (id)initWithFrame:(CGRect)frame
{
  CGSize defPullTabSize = CGSizeMake(20.0, 10.0);
  CGRect contentFrame = frame;
  contentFrame.size.height = frame.size.height - defPullTabSize.height;
  contentFrame.origin.y = defPullTabSize.height;

  frame.origin.y += contentFrame.size.height;
  
  self = [super initWithFrame:frame];
  if ( self )
  {
    self.backgroundColor = [UIColor clearColor];
    
    self.pullTabSize = defPullTabSize;
    self.pullTabColor = [UIColor grayColor];
    
    pullTabRect = CGRectMake((CGRectGetWidth(frame) / 2.0) - (self.pullTabSize.width / 2.0), 0.0, self.pullTabSize.width, self.pullTabSize.height);
    NSLog(@"%@", NSStringFromCGRect(pullTabRect));
    
    self.contentView = [[UIView alloc] initWithFrame:contentFrame];
    self.contentView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.contentView];
    
    self.flickUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
    self.flickUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.flickDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
    self.flickDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

    [self addGestureRecognizer:self.flickUpRecognizer];
    [self addGestureRecognizer:self.flickDownRecognizer];
  }

  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGContextSetLineWidth(ctx, 1.0);
  CGContextSetStrokeColorWithColor(ctx, self.pullTabColor.CGColor);
  CGContextSetFillColorWithColor(ctx, self.pullTabColor.CGColor);
  
  CGRect bounds = CGRectInset(self.bounds, 1, 1);
  
  float minx = (CGRectGetWidth(bounds) / 2.0) - (self.pullTabSize.width / 2.0);
  float miny = 0;
  float midx = CGRectGetMidX(bounds);
  float maxx = minx + self.pullTabSize.width;
  float maxy = self.pullTabSize.height;
  
  CGContextMoveToPoint(ctx, midx, miny);
  
  CGContextAddArcToPoint(ctx, maxx, miny, maxx, maxy, 4.0);

  CGContextAddLineToPoint(ctx, maxx, maxy);
  CGContextAddLineToPoint(ctx, minx, maxy);

  CGContextAddArcToPoint(ctx, minx, miny, maxx, miny, 4.0);
  
  CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  CGPoint location = [gestureRecognizer locationInView:self];
  
  NSLog(@"shouldBegin: %@", NSStringFromCGPoint(location));
  
  return CGRectContainsPoint(pullTabRect, location);
}

- (void) flick:(UIGestureRecognizer *)gestureRecognizer
{
  CGPoint location = [gestureRecognizer locationInView:self];
  
  if ( ! CGRectContainsPoint(pullTabRect, location) )
    return;
  
  NSLog(@"flick: %@", NSStringFromCGPoint(location));
  
  if ( gestureRecognizer == self.flickUpRecognizer && isUp )
    return;
  
  if ( gestureRecognizer == self.flickDownRecognizer && ! isUp)
    return;
  
  CGFloat distance = self.contentView.frame.size.height;
  if ( ! isUp ) distance = -distance;
  
  isUp = ! isUp;
  
  void (^animBlock)(void) = ^(void)
  {
    CGRect frame = self.frame;

    frame.origin.y += distance;
    self.frame = frame;
  };

  [UIView animateWithDuration:0.25 delay:0.0
    options:UIViewAnimationOptionAllowUserInteraction+UIViewAnimationCurveEaseIn animations:animBlock completion:nil];
}

@end
