//
//  ASResourceManager.m
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASResourceManager.h"
#import "ASHTTPRequestManager.h"
#import "ASCacheManager.h"

@interface ASResourceManager()

@property (nonatomic, strong) ASHTTPRequestManager *httpRequestManager;
@property (nonatomic, strong) ASCacheManager *cache;

@end

@implementation ASResourceManager

static ASResourceManager *rm = nil;

+ (ASResourceManager *) resourceManager
{
  if ( rm == nil )
    rm = [[ASResourceManager alloc] init];
  
  return rm;
}

- (void) instanceInit
{
  self.httpRequestManager = [ASHTTPRequestManager httpRequestManager];
  self.cache = [[ASCacheManager alloc] init];
}

- (void) retrieveResourceWithName:(NSString *)resourceName andURL:(NSString *)resourceURL andCompletionHandler:(void(^)(NSString *, NSString *, NSError *))handler
{
  NSString *file = [self.cache retrieveFilenameForResource:resourceName];
  
  if ( file != nil )
  {
    handler(file, resourceName, nil);
    
    return;
  }
  
  ASRequest *req = [ASRequest new];
  req.resource = resourceURL;
  
  void(^resHandler)(ASRequest *);
  
  resHandler = ^(ASRequest *request)
  {
    [self.cache saveDataToCache:request.data withResourceName:resourceName];
    
    [self retrieveResourceWithName:resourceName andURL:resourceURL andCompletionHandler:handler];
  };
  
  [self.httpRequestManager makeRequest:req withCompletionHandler:resHandler];
}

@end