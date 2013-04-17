//
//  ASBaseContentViewController.h
//  PlayGround
//
//  Created by Avi Shevin on 4/12/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStackController.h"

@interface ASBaseContentViewController : UIViewController

- (NSDictionary *) saveState;
- (void) restoreState:(NSDictionary *)state;

@property (nonatomic, weak) ASStackController *contentController;

@end
