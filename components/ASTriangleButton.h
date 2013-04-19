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
  ASTriangleButtonDirectionDown,
  ASTriangleButtonDirectionArbitrary
} ASTriangleButtonDirection;

@interface ASTriangleButton : UIControl

@property (nonatomic) ASTriangleButtonDirection triangleDirection;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) float angle;
@property (nonatomic) float baseHeight;
@property (nonatomic) float baseWidth;

@end
