//
//  ASDownloadManager.m
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASHTTPRequestManager.h"
#import "NSString+URLEncode.h"

@implementation ASHTTPRequestManager

static ASHTTPRequestManager *rm;

+ (id) httpRequestManager
{
  if ( rm == nil )
    rm = [[ASHTTPRequestManager alloc] init];
  
  return rm;
}

- (void) instanceInit
{
  self.queue = [NSOperationQueue mainQueue];
}

- (void) makeRequest:(ASRequest *)request withCompletionHandler:(void (^)(ASRequest *))handler
{
  NSMutableURLRequest *req =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.resource]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:5.0];

  if ( request.formData.count > 0 )
  {
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
  }

  void (^reqHandler)(NSURLResponse*, NSData*, NSError*);
  
  reqHandler = ^(NSURLResponse* response, NSData* data, NSError* error)
  {
    ASRequest *capturedRequest = request;
    
    capturedRequest.response = (NSHTTPURLResponse*)response;
    capturedRequest.data = data;
    capturedRequest.error = error;
    
    NSLog(@"data: |%@|", [[NSString alloc] initWithData:capturedRequest.data encoding:NSUTF8StringEncoding]);
    
    handler(capturedRequest);
  };
  
  [NSURLConnection sendAsynchronousRequest:req queue:self.queue completionHandler:reqHandler];
}

@end