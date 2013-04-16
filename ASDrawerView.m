//
//  ASDrawerView.m
//  PlayGround
//
//  Created by Avi Shevin on 4/10/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASDrawerView.h"

@interface ASPullTabView : UIView

@property (nonatomic) float width;
@property (nonatomic) UIColor *color;
@property (nonatomic) CGRect pullTabRect;

@end

@implementation ASPullTabView

- (id) initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( self )
  {
    self.width = 20;
    self.backgroundColor = [UIColor clearColor];
    
    self.pullTabRect = CGRectMake((CGRectGetWidth(frame) / 2.0) - (self.width / 2.0), 0.0, self.width, CGRectGetHeight(frame));
  }
  
  return self;
}

- (void) drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGContextSetLineWidth(ctx, 1.0);
  CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
  CGContextSetFillColorWithColor(ctx, self.color.CGColor);
  
  float minx = CGRectGetMinX(self.pullTabRect);
  float miny = CGRectGetMinY(self.pullTabRect) + 1;
  float midx = CGRectGetMidX(self.pullTabRect);
  float maxx = CGRectGetMaxX(self.pullTabRect);
  float maxy = CGRectGetMaxY(self.pullTabRect);
  
  CGContextMoveToPoint(ctx, midx, miny);
  
  CGContextAddArcToPoint(ctx, maxx, miny, maxx, maxy, 4.0);

  CGContextAddLineToPoint(ctx, maxx, maxy);
  CGContextAddLineToPoint(ctx, minx, maxy);

  CGContextAddArcToPoint(ctx, minx, miny, maxx, miny, 4.0);

  CGContextAddLineToPoint(ctx, midx, miny);
  
  CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void) setColor:(UIColor *)color
{
  _color = color;
  
  [self setNeedsDisplay];
}

@end

#pragma mark - ASDrawerView

@interface ASDrawerView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ASPullTabView *pullTabView;

@property (nonatomic, strong) UISwipeGestureRecognizer *flickUpRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *flickDownRecognizer;

@end

@implementation ASDrawerView
{
  CGRect originalFrame;
}

- (id)initWithFrame:(CGRect)frame closed:(BOOL)closed
{
  self = [self initWithFrame:frame];

  [self setClosedState:closed animated:NO];

  return self;
}

- (id) initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( self )
  {
    [self setupSubViews];
    [self setupGestureRecognizers];

    self.backgroundColor = [UIColor clearColor];
    self.pullTabView.color = [UIColor grayColor];
    
    originalFrame = frame;
   
    self.pullTabSize = CGSizeMake(self.pullTabView.width, CGRectGetHeight(self.pullTabView.frame));
    self.pullTabColor = [UIColor grayColor];
  }

  return self;
}

- (void) setupSubViews
{
  CGSize defPullTabSize = CGSizeMake(20.0, 10.0);
  
  CGRect pullTabFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), defPullTabSize.height);
  CGRect contentFrame = CGRectMake(0, defPullTabSize.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - defPullTabSize.height);

  self.pullTabView = [[ASPullTabView alloc] initWithFrame:pullTabFrame];
  self.pullTabView.backgroundColor = [UIColor clearColor];
  [self addSubview:self.pullTabView];
  
  self.contentView = [[UIView alloc] initWithFrame:contentFrame];
  self.contentView.backgroundColor = [UIColor greenColor];
  [self addSubview:self.contentView];
}

- (void) layoutSubviews
{
  if ( self.isClosed )
  {
    CGRect frame = originalFrame;
    frame.origin.y += CGRectGetHeight(self.contentView.frame);
    frame.size.height = CGRectGetHeight(self.pullTabView.frame);
    self.frame = frame;
  }
  else
  {
    CGRect contentFrame = self.frame;
    contentFrame.origin.y = CGRectGetHeight(self.pullTabView.frame);
    contentFrame.size.height = CGRectGetHeight(self.frame) - CGRectGetHeight(self.pullTabView.frame);
    self.contentView.frame = contentFrame;
  }
}

- (void) setFrame:(CGRect)frame
{
//  if ( ! self.isClosed )
    [super setFrame:frame];
  
//  originalFrame = frame;
}

- (void) setupGestureRecognizers
{
  self.flickUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
  self.flickUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
  
  self.flickDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
  self.flickDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

  [self.pullTabView addGestureRecognizer:self.flickUpRecognizer];
  [self.pullTabView addGestureRecognizer:self.flickDownRecognizer];
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
  return CGRectContainsPoint(self.pullTabView.pullTabRect, point) || CGRectContainsPoint(self.contentView.frame, point);
}

- (void) setPullTabColor:(UIColor *)pullTabColor
{
  self.pullTabView.color = pullTabColor;
}

- (UIColor *) pullTabColor
{
  return self.pullTabView.color;
}

- (void) setClosedState:(BOOL)closed animated:(BOOL)animated
{
  if ( _isClosed == closed )
    return;
  
  _isClosed = closed;
  
  void (^animBlock)(void) = ^(void)
  {
    __weak __typeof(self) weakSelf = self;
    
    if ( ! closed )
      weakSelf.frame = originalFrame;
    
    [weakSelf layoutSubviews];
  };

  [UIView animateWithDuration:( animated ) ? 0.25 : 0.0 delay:0.0
    options:UIViewAnimationOptionAllowUserInteraction+UIViewAnimationCurveEaseIn animations:animBlock completion:^(BOOL finished){ [self setNeedsDisplay]; }];

  return;
  
  if ( closed )
  {
    void (^animBlock)(void) = ^(void)
    {
      CGRect frame = self.frame;
      frame.origin.y += CGRectGetHeight(self.contentView.frame);
      frame.size.height = CGRectGetHeight(self.pullTabView.frame);
      self.frame = frame;
    };

    [UIView animateWithDuration:( animated ) ? 0.25 : 0.0 delay:0.0
      options:UIViewAnimationOptionAllowUserInteraction+UIViewAnimationCurveEaseIn animations:animBlock completion:^(BOOL finished){ [self setNeedsDisplay]; }];
  }
  else
  {
    void (^animBlock)(void) = ^(void)
    {
      self.frame = originalFrame;
    };

    [UIView animateWithDuration:( animated ) ? 0.25 : 0.0 delay:0.0
      options:UIViewAnimationOptionAllowUserInteraction+UIViewAnimationCurveEaseIn animations:animBlock completion:^(BOOL finished){ [self setNeedsDisplay]; }];
  }
}

- (void) flick:(UIGestureRecognizer *)gestureRecognizer
{
  if ( gestureRecognizer == self.flickUpRecognizer && ! self.isClosed )
    return;
  
  if ( gestureRecognizer == self.flickDownRecognizer && self.isClosed )
    return;

  [self setClosedState:! self.isClosed animated:YES];
}

@end