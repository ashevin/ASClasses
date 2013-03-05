//
//  ASUploadManager.m
//  Folio
//
//  Created by Avi Shevin on 3/5/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASUploadManager.h"

@implementation ASUploadManager

- (id) init
{
  self = [super init];
  if ( self )
  {
    self.queue = [NSOperationQueue mainQueue];
  }
  
  return self;
}

- (void) uploadResourceWithRequest:(ASRequest *)request
{
  NSMutableURLRequest *req =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.resource]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:5.0];

  [req setHTTPMethod:@"POST"];
  [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [req setValue:[NSString stringWithFormat:@"%d", [request.data length]] forHTTPHeaderField:@"Content-Length"];
  [req setHTTPBody:request.data];

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
