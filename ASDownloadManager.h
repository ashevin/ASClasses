//
//  ASDownloadManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASRequest.h"

@protocol ASDownloadManagerDelegate

- (void) responseForRequest:(ASRequest *)request;

@end

@interface ASDownloadManager : NSObject

- (void) downloadResourceWithRequest:(ASRequest *)request;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) id<ASDownloadManagerDelegate> delegate;

@end
