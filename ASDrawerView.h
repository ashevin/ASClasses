//
//  ASDrawerView.h
//  PlayGround
//
//  Created by Avi Shevin on 4/10/13.
//  Copyright (c) 2013 Avi Shevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDrawerView : UIView

- (id) initWithFrame:(CGRect)frame collapsed:(BOOL)collapsed;
- (void) setCollapsedState:(BOOL)collapsed animated:(BOOL)animated;

@property (nonatomic) CGSize pullTabSize;
@property (nonatomic) UIColor *pullTabColor;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) BOOL isCollapsed;

@end
