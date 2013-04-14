//
//  ASdb.m
//  PlayGround
//
//  Created by Avi Shevin on 4/9/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import "ASdb.h"
#import "ASdbObject.h"
#import <objc/runtime.h>
#import <sqlite3.h>

@interface ASdb()
{
  NSMutableDictionary *classes;
  NSDictionary *typeMap;
  
  sqlite3 *db;
  BOOL reqInit;
}

@property (nonatomic, strong) NSString *dbName;
@property (nonatomic, readonly) NSString *dbPath;

@end

@implementation ASdb

- (id) initWithDB:(NSString *)dbName
{
  self = [super init];
  if ( self != nil )
  {
    self.dbName = dbName;
    
    [self initTypeMap];
    
    if ( [self initDB] == NO )
      self = nil;
  }
  
  return self;
}

- (void) initTypeMap
{
  typeMap =
    @{
      @"NSString"     : @"text",
      @"NSNumber"     : @"real",
//      @"NSDictionary" : @"dictionary",
//      @"NSArray"      : @"array",
      @"NSDate"       : @"int",
      @"int"          : @"int",
      @"long"         : @"int",
      @"float"        : @"real",
      @"double"       : @"real",
      @"char"         : @"text",
    };
}

- (BOOL) initDB
{
  NSFileManager *fm = [NSFileManager defaultManager];
  
  reqInit = ( [fm fileExistsAtPath:self.dbPath] == NO );
  
  return ( sqlite3_open([self.dbPath UTF8String], &db) == SQLITE_OK );
}

- (NSString *) dbPath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:self.dbName];
}

- (void) beginClassRegistration
{
  classes = [[NSMutableDictionary alloc] init];
}

- (void) registerClass:(Class)class
{
  // For now we only except classes that descend from ASdbObject.
  if ( ! [class isSubclassOfClass:[ASdbObject class]] )
      @throw
        [NSException exceptionWithName:@"InvalidClassException"
          reason:[NSString stringWithFormat:@"The class %s is not a subclass of ASdbObject.", class_getName(class)] userInfo:nil];
  
  NSDictionary *map = [self createMapForClass:class];
  
  NSLog(@"%@", map);
  
  classes[[NSString stringWithFormat:@"%s", class_getName(class)]] =
    @{
      @"properties" : map,
    };
}

- (void) endClassRegistration
{
  if ( reqInit )
  {
    [self createTables];
    reqInit = NO;
  }
  
  NSLog(@"%@", classes);
}

- (void) createTables
{
}

- (void) insert:(id)obj
{
  NSLog(@"%@", [self insertStatementForClass:[obj class]]);
}

- (NSDictionary *)createMapForClass:(Class)class
{
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];

  NSLog(@"%s", class_getName(class));
  
  unsigned int count;
  objc_property_t *props = class_copyPropertyList(class, &count);
  
  if ( count == 0 )
      @throw
        [NSException exceptionWithName:@"NoPropertiesException"
          reason:[NSString stringWithFormat:@"The class %s can't be persisted as it has no properties.", class_getName(class)] userInfo:nil];
  
  for ( int i = 0; i < count; i++ )
  {
    const char *attrString = property_getAttributes(props[i]);

    NSString *propName = [NSString stringWithFormat:@"%s", property_getName(props[i])];

    NSString *attrType = [[NSString stringWithFormat:@"%s", attrString] componentsSeparatedByString:@","][0];
    char propType = attrString[1];
    
    NSString *className = nil;

    switch ( propType )
    {
      case 'i' : className = @"int"; break;
      case 'l' : className = @"long"; break;
      case 'f' : className = @"float"; break;
      case 'd' : className = @"double"; break;
      case 'c' : className = @"char"; break;
      case '@' : className = [attrType componentsSeparatedByString:@"\""][1]; break;
    }

    // We don't support this class/data type.
    // As the data model should be fixed by the programmer, we'll throw an exception that should be caught in testing.
    if ( className == nil || typeMap[className] == nil )
      @throw
        [NSException exceptionWithName:@"UnsupportedClassException"
          reason:[NSString stringWithFormat:@"The class %@ is not supported by this version of ASdb.", className] userInfo:nil];
    
    NSString *columnType = typeMap[className];
    
    NSLog(@"%@: [%c, %@] %@", propName, propType, className, columnType);
    
    NSDictionary *classMap =
      @{
        @"classname" : className,
        @"columntype" : columnType,
      };
    
    map[propName] = classMap;
  }

  if ( props )
    free(props);

  return map;
}

- (NSString *) createStatementForClass:(Class)class
{
  NSString *table = [NSString stringWithFormat:@"%s", class_getName(class)];
  NSDictionary *map = classes[table][@"properties"];
  NSArray *columns = [map allKeys];

  NSMutableString *create = [[NSMutableString alloc] initWithFormat:@"create table %@ (", table];
  
  for ( int i = 0; i < columns.count; i++ )
    [create appendString:[NSString stringWithFormat:@"%@ %@, ", columns[i], map[columns[i]][@"columntype"]]];

  [create appendString:@"pid integer primary key autoincrement)"];
  
  return create;
}

- (NSString *) insertStatementForClass:(Class)class
{
  NSString *table = [NSString stringWithFormat:@"%s", class_getName(class)];
  NSDictionary *map = classes[table][@"properties"];
  NSArray *columns = [map allKeys];
  
  NSMutableString *ins = [[NSMutableString alloc] initWithFormat:@"insert into %@ (", table];

  for ( int i = 0; i < columns.count - 1; i++ )
    [ins appendString:[NSString stringWithFormat:@"%@, ", columns[i]]];
  
  if ( columns.count > 0 )
    [ins appendString:columns[columns.count - 1]];
  
  [ins appendString:@") values ("];

  for ( int i = 0; i < columns.count - 1; i++ )
    [ins appendString:@"?, "];
  
  [ins appendString:@"?)"];
  
  return ins;
}

@end
