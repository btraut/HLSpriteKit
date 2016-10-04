//
//  HLGestureTarget.m
//  HLSpriteKit
//
//  Created by Karl Voskuil on 7/10/14.
//  Copyright (c) 2014 Hilo Games. All rights reserved.
//

#import "HLGestureTarget.h"

#if ! TARGET_OS_IPHONE
#import "NSGestureRecognizer+MultipleActions.h"
#endif

BOOL
HLGestureTarget_areEquivalentGestureRecognizers(HLGestureRecognizer *a, HLGestureRecognizer *b)
{
  Class classA = [a class];
  if (classA != [b class]) {
    return NO;
  }

#if TARGET_OS_IPHONE
  if (classA == [UITapGestureRecognizer class]) {
    UITapGestureRecognizer *tapA = (UITapGestureRecognizer *)a;
    UITapGestureRecognizer *tapB = (UITapGestureRecognizer *)b;
    if (tapA.numberOfTapsRequired != tapB.numberOfTapsRequired) {
      return NO;
    }
    if (tapA.numberOfTouchesRequired != tapB.numberOfTouchesRequired) {
      return NO;
    }
    return YES;
  }
  
  if (classA == [UISwipeGestureRecognizer class]) {
    UISwipeGestureRecognizer *swipeA = (UISwipeGestureRecognizer *)a;
    UISwipeGestureRecognizer *swipeB = (UISwipeGestureRecognizer *)b;
    if (swipeA.direction != swipeB.direction) {
      return NO;
    }
    if (swipeA.numberOfTouchesRequired != swipeB.numberOfTouchesRequired) {
      return NO;
    }
    return YES;
  }
  
  if (classA == [UIPanGestureRecognizer class]) {
    UIPanGestureRecognizer *panA = (UIPanGestureRecognizer *)a;
    UIPanGestureRecognizer *panB = (UIPanGestureRecognizer *)b;
    if (panA.minimumNumberOfTouches != panB.minimumNumberOfTouches) {
      return NO;
    }
    if (panA.maximumNumberOfTouches != panB.maximumNumberOfTouches) {
      return NO;
    }
    return YES;
  }
  
  if (classA == [UIScreenEdgePanGestureRecognizer class]) {
    UIScreenEdgePanGestureRecognizer *screenEdgePanA = (UIScreenEdgePanGestureRecognizer *)a;
    UIScreenEdgePanGestureRecognizer *screenEdgePanB = (UIScreenEdgePanGestureRecognizer *)b;
    if (screenEdgePanA.edges != screenEdgePanB.edges) {
      return NO;
    }
    return YES;
  }
  
  if (classA == [UILongPressGestureRecognizer class]) {
    UILongPressGestureRecognizer *longPressA = (UILongPressGestureRecognizer *)a;
    UILongPressGestureRecognizer *longPressB = (UILongPressGestureRecognizer *)b;
    if (longPressA.numberOfTapsRequired != longPressB.numberOfTapsRequired) {
      return NO;
    }
    if (longPressA.numberOfTouchesRequired != longPressB.numberOfTouchesRequired) {
      return NO;
    }
    const CFTimeInterval HLGestureTargetLongPressMinimumPressDurationEpsilon = 0.01;
    if (fabs(longPressA.minimumPressDuration - longPressB.minimumPressDuration) > HLGestureTargetLongPressMinimumPressDurationEpsilon) {
      return NO;
    }
    const CGFloat HLGestureTargetLongPressAllowableMovementEpsilon = 0.1f;
    if (fabs(longPressA.allowableMovement - longPressB.allowableMovement) > HLGestureTargetLongPressAllowableMovementEpsilon) {
      return NO;
    }
    return YES;
  }
#else
  if (classA == [NSClickGestureRecognizer class]) {
    NSClickGestureRecognizer *tapA = (NSClickGestureRecognizer *)a;
    NSClickGestureRecognizer *tapB = (NSClickGestureRecognizer *)b;
    if (tapA.numberOfClicksRequired != tapB.numberOfClicksRequired) {
      return NO;
    }
    return YES;
  }
  
  if (classA == [NSPressGestureRecognizer class]) {
    NSPressGestureRecognizer *longPressA = (NSPressGestureRecognizer *)a;
    NSPressGestureRecognizer *longPressB = (NSPressGestureRecognizer *)b;
    const CFTimeInterval HLGestureTargetLongPressMinimumPressDurationEpsilon = 0.01;
    if (fabs(longPressA.minimumPressDuration - longPressB.minimumPressDuration) > HLGestureTargetLongPressMinimumPressDurationEpsilon) {
      return NO;
    }
    const CGFloat HLGestureTargetLongPressAllowableMovementEpsilon = 0.1f;
    if (fabs(longPressA.allowableMovement - longPressB.allowableMovement) > HLGestureTargetLongPressAllowableMovementEpsilon) {
      return NO;
    }
    return YES;
  }
#endif

  return YES;
}

@implementation HLTapGestureTarget

+ (instancetype)tapGestureTargetWithDelegate:(id<HLTapGestureTargetDelegate>)delegate
{
  return [[HLTapGestureTarget alloc] initWithDelegate:delegate];
}

+ (instancetype)tapGestureTargetWithHandleGestureBlock:(void (^)(HLGestureRecognizer *))handleGestureBlock
{
  return [[HLTapGestureTarget alloc] initWithHandleGestureBlock:handleGestureBlock];
}

- (instancetype)initWithDelegate:(id<HLTapGestureTargetDelegate>)delegate
{
  self = [super init];
  if (self) {
    _delegate = delegate;
    _gestureTransparent = NO;
  }
  return self;
}

- (instancetype)initWithHandleGestureBlock:(void (^)(HLGestureRecognizer *))handleGestureBlock
{
  self = [super init];
  if (self) {
    _handleGestureBlock = handleGestureBlock;
    _gestureTransparent = NO;
  }
  return self;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _gestureTransparent = NO;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    _delegate = [aDecoder decodeObjectForKey:@"delegate"];
    // note: Cannot decode _handleGestureBlock.
    _gestureTransparent = [aDecoder decodeBoolForKey:@"gestureTransparent"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeConditionalObject:_delegate forKey:@"delegate"];
  // note: Cannot encode _handleGestureBlock.
  [aCoder encodeBool:_gestureTransparent forKey:@"gestureTransparent"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  HLTapGestureTarget *copy = [[[self class] allocWithZone:zone] init];
  if (copy) {
    copy->_delegate = _delegate;
    copy->_handleGestureBlock = _handleGestureBlock;
    copy->_gestureTransparent = _gestureTransparent;
  }
  return self;
}

- (BOOL)addToGesture:(HLGestureRecognizer *)gestureRecognizer firstTouchSceneLocation:(CGPoint)interactionPoint isInside:(BOOL *)isInside
{
  BOOL handleGesture = NO;

#if TARGET_OS_IPHONE
  if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)gestureRecognizer;
    if (tapGestureRecognizer.numberOfTapsRequired == 1) {
      *isInside = YES;
      handleGesture = YES;
    }
  }
#else
  if ([gestureRecognizer isKindOfClass:[NSClickGestureRecognizer class]]) {
    NSClickGestureRecognizer *clickGestureRecognizer = (NSClickGestureRecognizer *)gestureRecognizer;
    if (clickGestureRecognizer.numberOfClicksRequired == 1) {
      *isInside = YES;
      handleGesture = YES;
    }
  }
#endif
	
  *isInside = !_gestureTransparent;
  if (handleGesture) {
    [gestureRecognizer addTarget:self action:@selector(HLTapGestureTarget_handleGesture:)];
  }
  return handleGesture;
}

- (NSArray *)addsToGestureRecognizers
{
#if TARGET_OS_IPHONE
  return @[ [[UITapGestureRecognizer alloc] init] ];
#else
  return @[ [[NSClickGestureRecognizer alloc] init] ];
#endif
}

- (void)HLTapGestureTarget_handleGesture:(HLGestureRecognizer *)gestureRecognizer
{
  id <HLTapGestureTargetDelegate> delegate = _delegate;
  if (delegate) {
    [delegate tapGestureTarget:self didTap:gestureRecognizer];
  }
  if (_handleGestureBlock) {
    _handleGestureBlock(gestureRecognizer);
  }
}

@end
