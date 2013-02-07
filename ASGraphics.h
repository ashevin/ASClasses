//
//  ASGraphics.h
//  PlayGround
//
//  Created by Avi Shevin on 1/25/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ASPixel

@interface ASPixel : NSObject

- (BOOL) isEqualToColorOfPixel:(ASPixel *)pixel;

@property (nonatomic) unsigned char red;
@property (nonatomic) unsigned char green;
@property (nonatomic) unsigned char blue;
@property (nonatomic) unsigned char alpha;

@end

ASPixel* ASPixelMake(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);

#pragma mark - ASPoint

@interface ASPoint : NSObject

@property (nonatomic) NSUInteger x;
@property (nonatomic) NSUInteger y;

@end

ASPoint* ASPointMake(NSUInteger x, NSUInteger y);
