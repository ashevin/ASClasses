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

- (id) init
{
  self = [super init];
  if ( self )
  {
    self.downloader = [[ASDownloadManager alloc] init];
    self.cache = [[ASCacheManager alloc] init];
    
    self.downloader.delegate = self;
  }
  
  return self;
}

- (void) retrieveResourceWithName:(NSString *)resourceName
{
  NSString *file = [self.cache retrieveFilenameForResource:resourceName];
  
  if ( file != nil )
  {
    [self.delegate fileName:file forResource:resourceName withError:nil];
    
    return;
  }
  
  [self.downloader downloadResourceWithURL:resourceName];
}

- (void) requestWithResponse:(NSHTTPURLResponse *)response withData:(NSData *)data withError:(NSError *)error forResource:(NSString *)resource
{
  NSLog(@"%@ [%@] : %d", response.MIMEType, response.suggestedFilename, response.statusCode);
  NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
  NSLog(@"%@", error);
  NSLog(@"%@", resource);

  [self.cache saveDataToCache:data withResourceName:resource];
  
  [self retrieveResourceWithName:resource];
}

@end
