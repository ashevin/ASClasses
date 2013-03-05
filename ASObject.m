//
//  ASObject.m
//  Folio
//
//  Created by Avi Shevin on 3/5/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASObject.h"

@implementation ASObject

- (id) init
{
  self = [super init];
  if ( self )
  {
    if ( [self respondsToSelector:@selector(instanceInit)] )
      [self performSelector:@selector(instanceInit)];
  }
  
  return self;
}

@end
