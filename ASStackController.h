//
//  ASContentController.h
//  PlayGround
//
//  Created by Avi Shevin on 4/12/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ASBaseContentViewController.h"

@class ASBaseContentViewController;

typedef enum
  {
    ASStackControllerAnimationNone,
    ASStackControllerAnimationRight,
    ASStackControllerAnimationLeft,
    ASStackControllerAnimationUp,
    ASStackControllerAnimationDown,
  } ASStackControllerAnimation;

@interface ASStackController : UIViewController

- (id) initWithRootController:(ASBaseContentViewController *)controller;

- (void) pushController:(ASBaseContentViewController *)controller withAnimation:(ASStackControllerAnimation)animation;
- (void) popControllerWithAnimation:(ASStackControllerAnimation)animation;
- (void) switchToController:(ASBaseContentViewController *)controller WithAnimation:(ASStackControllerAnimation)animation;

- (void) saveState:(NSDictionary *)state forController:(ASBaseContentViewController *)controller;
- (NSDictionary *) stateForController:(ASBaseContentViewController *)controller;

@end
