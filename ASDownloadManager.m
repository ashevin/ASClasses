//
//  ASDownloadManager.m
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASDownloadManager.h"

@implementation ASDownloadManager

- (id) init
{
  self = [super init];
  if ( self )
  {
    self.queue = [NSOperationQueue mainQueue];
  }
  
  return self;
}

- (void) downloadResourceWithRequest:(ASRequest *)request
{
  NSURLRequest *req =
    [NSURLRequest requestWithURL:[NSURL URLWithString:request.resource]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:5.0];

  void (^handler)(NSURLResponse*, NSData*, NSError*);
  
  handler = ^(NSURLResponse* response, NSData* data, NSError* error)
  {
    ASRequest *capturedRequest = request;
    
    capturedRequest.response = (NSHTTPURLResponse*)response;
    capturedRequest.data = data;
    capturedRequest.error = error;
    
    [self.delegate responseForRequest:capturedRequest];
  };
  
  [NSURLConnection sendAsynchronousRequest:req queue:self.queue completionHandler:handler];
}


@end
