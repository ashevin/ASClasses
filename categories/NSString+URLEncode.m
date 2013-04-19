//
//  NSString+URLEncode.m
//  ASClasses
//
//  Created by Avi Shevin on 2/26/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *) urlEncode
{
  return (NSString *)
    CFBridgingRelease
    (
        CFURLCreateStringByAddingPercentEscapes
          (
            NULL,
            (CFStringRef)self,
            NULL,
            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
            kCFStringEncodingUTF8
          )
    );
}

@end
