//
//  ASCacheManager.m
//  Folio
//
//  Created by Avi Shevin on 2/17/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSData(MD5)
 
- (NSString *) MD5;
 
@end

@implementation NSData(MD5)
 
- (NSString*) MD5
{
  // Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
 
  // Create 16 byte MD5 hash value, store in buffer
  CC_MD5(self.bytes, self.length, md5Buffer);
 
  // Convert unsigned char buffer to NSString of hex values
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for ( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) 
    [output appendFormat:@"%02x", md5Buffer[i]];
 
  return output;
}

@end

/*
  The cache manager maintains a list of resources that have been cached.
  The data model is simply a dictionary of dictionaries.  The key of the root
  dictionary is the id, usually the URL, of the resource.  The value is a dictionary
  with keys for the file's name and the time the file was added to the cache.
  
  The cache index is persisted across app launches.  The default cache policy
  is to discard an entry after 10 days.  There is a delegate protocol that allows
  for a custom policy.
*/

@interface ASCacheManager()

@property (nonatomic, strong) NSMutableDictionary *resourceList;
@property (nonatomic, readonly) NSString *cacheFile;
@property (nonatomic, readonly) NSString *cacheDir;

@end

@implementation ASCacheManager

- (void) instanceInit
{
  self.resourceList = [NSMutableDictionary dictionaryWithContentsOfFile:self.cacheFile];
  if ( self.resourceList == nil )
    self.resourceList = [NSMutableDictionary dictionary];
  
  NSLog(@"cacheDir: %@", self.cacheDir);
}

- (NSString *) retrieveFilenameForResource:(NSString *)resourceName
{
  NSDictionary *resource = self.resourceList[resourceName];
  
  if ( resource == nil )
    return nil;
  
  NSString *file = resource[@"name"];
  
  NSFileManager *fm = [NSFileManager defaultManager];
  
  if ( [fm fileExistsAtPath:file] )
    return file;
  
  [self.resourceList removeObjectForKey:resourceName];
  [self.resourceList writeToFile:self.cacheFile atomically:YES];
  
  return nil;
}

- (void) saveDataToCache:(NSData *)data withResourceName:(NSString *)resourceName
{
  NSString *fileName, *path;
  
  NSDictionary *resource = self.resourceList[resourceName];
  
  fileName = ( resource != nil )
    ? resource[@"name"]
    : [data MD5];
  
  path = [NSString stringWithFormat:@"%@/%@", self.cacheDir, fileName];

  if ( resource == nil )
  {
    resource = @{ @"name" : path, @"date" : [NSDate date] };
    self.resourceList[resourceName] = resource;
  }
  
  [data writeToFile:path atomically:YES];
  
  [self.resourceList writeToFile:self.cacheFile atomically:YES];
}

#pragma mark - Private Properties

- (NSString *) cacheFile
{
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"cacheindex"];
}

- (NSString *) cacheDir
{
  return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

@end
