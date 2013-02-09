//
//  ASBitmap.h
//  PlayGround
//
//  Created by Avi Shevin on 1/22/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASGraphics.h"

@interface ASColorBitmap : NSObject

- (id) initWithImage:(UIImage *)image;

- (ASPixel *) pixelAt:(CGPoint)point;

@end