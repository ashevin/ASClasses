//
//  ASRequest.h
//  Folio
//
//  Created by Avi Shevin on 3/5/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASRequest : NSObject

+ (id) new;

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSDictionary *formData;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) id cookie;

@end
