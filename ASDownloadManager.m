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

- (void) downloadResourceWithURL:(NSString *)url
{
  NSURLRequest *req =
    [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:5.0];

  void (^handler)(NSURLResponse*, NSData*, NSError*);
  
  handler = ^(NSURLResponse* response, NSData* data, NSError* error)
  {
    NSString *resource = url;
    
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
    
    [self.delegate requestWithResponse:resp withData:data withError:error forResource:resource];
  };
  
  [NSURLConnection sendAsynchronousRequest:req queue:self.queue completionHandler:handler];
}


@end
