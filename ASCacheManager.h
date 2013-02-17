//
//  ASCacheManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCacheManager : NSObject

- (NSString *) retrieveFilenameForResource:(NSString *)resourceName;

- (void) saveDataToCache:(NSData *)data withResourceName:(NSString *)resourceName;

@end
