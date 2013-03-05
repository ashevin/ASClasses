//
//  ASResourceManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASObject.h"

@protocol ASResourceManagerDelegate

- (void) fileName:(NSString *)fileName forResource:(NSString *)resourceName withError:(NSError *)error andCookie:(id)cookie;

@end

@interface ASResourceManager : ASObject

- (void) retrieveResourceWithName:(NSString *)resourceName andCookie:(id)cookie;

@property (nonatomic, weak) id<ASResourceManagerDelegate> delegate;

@end
