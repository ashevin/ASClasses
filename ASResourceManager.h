//
//  ASResourceManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASResourceManagerDelegate

- (void) fileName:(NSString *)fileName forResource:(NSString *)resourceName withError:(NSError *)error;

@end

@interface ASResourceManager : NSObject

- (void) retrieveResourceWithName:(NSString *)resourceName;

@property (nonatomic, weak) id<ASResourceManagerDelegate> delegate;

@end
