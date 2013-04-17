//
//  ASContentController.m
//  PlayGround
//
//  Created by Avi Shevin on 4/12/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASStackController.h"
#import "ASBaseContentViewController.h"

@interface ASStackController ()

@property (nonatomic, strong) NSMutableDictionary *states;
@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation ASStackController

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if ( self )
  {
    [self setup];
  }
  
  return self;
}

- (id) initWithRootController:(ASBaseContentViewController *)controller;
{
  self = [super init];
  if ( self )
  {
    [self setup];
    
    controller.contentController = self;
    controller.wantsFullScreenLayout = YES;
    
    if ( controller )
      [self.stack addObject:controller];
  }
  
  return self;
}

- (void) setup
{
  self.states = [@{} mutableCopy];
  self.stack = [@[] mutableCopy];
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if ( self.stack.count > 0 )
    [self displayController:self.stack.lastObject];
}

- (void) pushController:(ASBaseContentViewController *)controller withAnimation:(ASStackControllerAnimation)animation
{
  controller.contentController = self;
  controller.wantsFullScreenLayout = YES;
  
  ASBaseContentViewController *vc = self.stack.lastObject;
  NSDictionary *state = [vc saveState];
  if ( state )
    [self saveState:state forController:vc];

  CGRect newFrame, oldFrame;
  [self framesForAnimation:animation newFrame:&newFrame oldFrame:&oldFrame];
  
  CGRect frames[2] = { newFrame, oldFrame };
  
  if ( vc == nil )
    [self displayController:controller];
  else
    [self cycleFromViewController:self.stack.lastObject toViewController:controller withStartingFrame:frames];
  
  [self.stack addObject:controller];
}

- (void) popControllerWithAnimation:(ASStackControllerAnimation)animation
{
  if ( self.stack.count == 0 )
    return;
  
  if ( self.stack.count == 1 )
  {
    [self hideContentController:self.stack.lastObject];
  }
  else
  {
    CGRect newFrame, oldFrame;
    [self framesForAnimation:animation newFrame:&newFrame oldFrame:&oldFrame];
    
    CGRect frames[2] = { newFrame, oldFrame };
    
    ASBaseContentViewController *vc = self.stack[self.stack.count - 2];
    [vc restoreState:[self stateForController:vc]];
    
    [self cycleFromViewController:self.stack.lastObject toViewController:vc withStartingFrame:frames];
  }

  [self.stack removeLastObject];
}

- (void) switchToController:(ASBaseContentViewController *)controller WithAnimation:(ASStackControllerAnimation)animation
{
  NSUInteger index = [self.stack indexOfObject:controller];

  if ( index == self.stack.count - 1 )
    return;
  
  if ( index != NSNotFound )
    [self.stack removeObjectAtIndex:index];

  [self pushController:controller withAnimation:animation];
}

- (void) saveState:(NSDictionary *)state forController:(ASBaseContentViewController *)controller
{
  self.states[[NSString stringWithFormat:@"%p", controller]] = state;
}

- (NSDictionary *) stateForController:(ASBaseContentViewController *)controller
{
  return self.states[[NSString stringWithFormat:@"%p", controller]];
}

- (void) displayController:(ASBaseContentViewController *) content;
{
  [self addChildViewController:content];

  content.view.frame = self.view.bounds;
  [self.view addSubview:content.view];

  [content didMoveToParentViewController:self];
}

- (void) hideContentController:(UIViewController *)content
{
  [content willMoveToParentViewController:nil];
  [content.view removeFromSuperview];
  [content removeFromParentViewController];
}

- (void) framesForAnimation:(ASStackControllerAnimation)animation newFrame:(CGRect *)newFrame oldFrame:(CGRect *)oldFrame
{
  *newFrame = self.view.frame;
  *oldFrame = self.view.frame;
  
  switch ( animation )
  {
    case ASStackControllerAnimationNone:
      break;
    case ASStackControllerAnimationDown:
      (*newFrame).origin.y = -(*newFrame).size.height;
      (*oldFrame).origin.y = (*oldFrame).size.height;
      break;
    case ASStackControllerAnimationLeft:
      (*newFrame).origin.x = (*newFrame).size.width;
      (*oldFrame).origin.x = -(*oldFrame).size.width;
      break;
    case ASStackControllerAnimationRight:
      (*newFrame).origin.x = -(*newFrame).size.width;
      (*oldFrame).origin.x = (*oldFrame).size.width;
      break;
    case ASStackControllerAnimationUp:
      (*newFrame).origin.y = (*newFrame).size.height;
      (*oldFrame).origin.y = -(*oldFrame).size.height;
      break;
  }
}

- (void) cycleFromViewController:(ASBaseContentViewController *)oldC toViewController:(ASBaseContentViewController *)newC withStartingFrame:(CGRect *)frames
{
  [oldC willMoveToParentViewController:nil];
  [self addChildViewController:newC];

  newC.view.frame = frames[0];

  [self transitionFromViewController:oldC
    toViewController: newC
    duration: 0.25
    options:0
    animations:
      ^
      {
        newC.view.frame = oldC.view.frame;
        oldC.view.frame = frames[1];
      }
    completion:
      ^(BOOL finished)
      {
        [oldC removeFromParentViewController];
        [newC didMoveToParentViewController:self];
      }
  ];
}

@end
