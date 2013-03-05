//
//  ASResourceManager.m
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASResourceManager.h"
#import "ASDownloadManager.h"
#import "ASCacheManager.h"

@interface ASResourceManager() <ASDownloadManagerDelegate>

@property (nonatomic, strong) ASDownloadManager *downloader;
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
  self.downloader = [[ASDownloadManager alloc] init];
  self.cache = [[ASCacheManager alloc] init];
  
  self.downloader.delegate = self;
}

- (void) retrieveResourceWithName:(NSString *)resourceName andCookie:(id)cookie
{
  NSString *file = [self.cache retrieveFilenameForResource:resourceName];
  
  if ( file != nil )
  {
    [self.delegate fileName:file forResource:resourceName withError:nil andCookie:cookie];
    
    return;
  }
  
  ASRequest *req = [[ASRequest alloc] init];
  
  req.resource = resourceName;
  req.cookie = cookie;
  
  [self.downloader downloadResourceWithRequest:req];
}

- (void) responseForRequest:(ASRequest *)request
{
  NSLog(@"%@ [%@] : %d", request.response.MIMEType, request.response.suggestedFilename, request.response.statusCode);
  NSLog(@"error: %@", request.error);
  NSLog(@"resource: %@", request.resource);
  NSLog(@"cookie: %@", request.cookie);

  [self.cache saveDataToCache:request.data withResourceName:request.resource];
  
  [self retrieveResourceWithName:request.resource andCookie:request.cookie];
}

- (void) retrieveResourceWithName:(NSString *)resourceName andURL:(NSString *)resourceURL andCompletionHandler:(void(^)(NSString *, NSString *, NSError *))handler
{
  NSString *file = [self.cache retrieveFilenameForResource:resourceName];
  
  if ( file != nil )
  {
    handler(file, resourceName, nil);
    
    return;
  }
  
  ASRequest *req = [[ASRequest alloc] init];
  req.resource = resourceURL;
  
  void(^resHandler)(ASRequest *);
  
  resHandler = ^(ASRequest *request)
  {
    [self.cache saveDataToCache:request.data withResourceName:resourceName];
    
    [self retrieveResourceWithName:resourceName andURL:resourceURL andCompletionHandler:handler];
  };
  
  [self.downloader downloadResourceWithRequest:req andCompletionHandler:resHandler];
}

@end