//
//  ASGrayscaleBitmap.h
//  PlayGround
//
//  Created by Avi Shevin on 2/6/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASGraphics.h"
#import "ASBitmap.h"

@interface ASGrayscaleBitmap : NSObject <ASBitmap>

- (id) initWithImage:(UIImage *)image;

- (ASPixel *) pixelAt:(CGPoint)point;

@end
