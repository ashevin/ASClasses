//
//  ASTriangleButton.h
//  PlayGround
//
//  Created by Avi Shevin on 2/7/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
  ASTriangleButtonDirectionLeft,
  ASTriangleButtonDirectionRight,
  ASTriangleButtonDirectionUp,
  ASTriangleButtonDirectionDown
} ASTriangleButtonDirection;

@interface ASTriangleButton : UIControl

@property (nonatomic) ASTriangleButtonDirection triangleDirection;

@end
