//
//  ASUploadManager.h
//  Folio
//
//  Created by Avi Shevin on 3/5/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASObject.h"
#import "ASRequest.h"

@protocol ASUploadManagerDelegate

- (void) responseForRequest:(ASRequest *)request;

@end

@interface ASUploadManager : ASObject

- (void) uploadResourceWithRequest:(ASRequest *)request;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) id<ASUploadManagerDelegate> delegate;

@end
