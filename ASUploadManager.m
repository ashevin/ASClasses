//
//  ASUploadManager.m
//  Folio
//
//  Created by Avi Shevin on 3/5/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASUploadManager.h"
#import "NSString+URLEncode.h"

@implementation ASUploadManager

- (void) instanceInit
{
  self.queue = [NSOperationQueue mainQueue];
}

- (void) uploadResourceWithRequest:(ASRequest *)request
{
  NSMutableURLRequest *req =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.resource]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:5.0];

  NSMutableString *data = [[NSMutableString alloc] init];
  
  for (NSString *key in request.formData.allKeys )
  {
    NSString *k = [key urlEncode];
    NSString *v = [request.formData[key] urlEncode];
    
    [data appendFormat:@"%@=%@&", k, v];
  }
  
  [req setHTTPMethod:@"POST"];
  [req setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
  [req setHTTPBody:[NSData dataWithBytes:[data UTF8String] length:data.length]];

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
