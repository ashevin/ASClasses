//
//  ASDownloadManager.h
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASDownloadManagerDelegate

- (void) requestWithResponse:(NSHTTPURLResponse *)response withData:(NSData *)data withError:(NSError *)error forResource:(NSString *)resource;

@end

@interface ASDownloadManager : NSObject

- (void) downloadResourceWithURL:(NSString *)url;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) id<ASDownloadManagerDelegate> delegate;

@end
