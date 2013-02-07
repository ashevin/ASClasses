//
//  ASHitTest.h
//  PlayGround
//
//  Created by Avi Shevin on 1/23/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASHitTester : NSObject

- (id) initWithImage:(UIImage *)image andRegions:(NSArray *)regions;

- (NSInteger) hitTest:(CGPoint)point;

@end