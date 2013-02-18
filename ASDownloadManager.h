//
//  ASDownloadManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASDownloadRequest : NSObject

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) id cookie;

@end

@protocol ASDownloadManagerDelegate

- (void) responseWithRequest:(ASDownloadRequest *)request;

@end

@interface ASDownloadManager : NSObject

- (void) downloadResourceWithRequest:(ASDownloadRequest *)request;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) id<ASDownloadManagerDelegate> delegate;

@end
