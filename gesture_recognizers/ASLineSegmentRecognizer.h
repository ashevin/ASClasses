//
//  ASLineSegmentRecognizer.h
//  GestureRecognizerCollection
//
//  Created by Avi Shevin on 7/28/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
  ASSegmentDirectionUnknown    = 0,
  ASSegmentDirectionUp         = 1,
  ASSegmentDirectionDown       = 2,
  ASSegmentDirectionLeft       = 3,
  ASSegmentDirectionRight      = 4,
  ASSegmentDirectionUpRight    = 5,
  ASSegmentDirectionUpLeft     = 6,
  ASSegmentDirectionDownRight  = 7,
  ASSegmentDirectionDownLeft   = 8,
}
ASSegmentDirection;

@interface ASLineSegment : NSObject

- (id) initWithDirection:(ASSegmentDirection)direction andDistanceTravelled:(CGFloat)distanceTravelled;

@property (nonatomic, readonly) ASSegmentDirection direction;
@property (nonatomic, readonly) CGFloat distanceTravelled;

@end


@class ASLineSegmentRecognizer;

@protocol ASLineSegmentDelegate <NSObject>

- (void)lineSegmentRecognizer:(ASLineSegmentRecognizer *)recognizer didAddSegment:(ASLineSegment *)segment;

@end


@interface ASLineSegmentRecognizer : UIGestureRecognizer

- (NSString *) nameForDirection:(ASSegmentDirection)direction;

@property (nonatomic, copy) NSArray *rules;

@property (nonatomic, assign) CGFloat minSegmentLength;
@property (nonatomic, assign) CGFloat variance;

@property (nonatomic, weak) id<ASLineSegmentDelegate> lineSegmentDelegate;

@end
