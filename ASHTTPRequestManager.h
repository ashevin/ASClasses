//
//  ASDownloadManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASObject.h"
#import "ASRequest.h"

@interface ASHTTPRequestManager : ASObject

+ (id) httpRequestManager;

- (void) makeRequest:(ASRequest *)request withCompletionHandler:(void (^)(ASRequest *))handler;

@property (nonatomic, strong) NSOperationQueue *queue;

@end
