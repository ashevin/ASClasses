//
//  ASdb.h
//  PlayGround
//
//  Created by Avi Shevin on 4/9/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASdb : NSObject

- (id) initWithDB:(NSString *)dbName;

- (void) beginClassRegistration;
- (void) registerClass:(Class)class;
- (void) endClassRegistration;

- (void) insert:(id)obj;

@end
