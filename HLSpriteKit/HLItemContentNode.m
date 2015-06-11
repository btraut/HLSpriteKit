//
//  HLItemContentNode.m
//  HLSpriteKit
//
//  Created by Karl Voskuil on 4/13/15.
//  Copyright (c) 2015 Hilo Games. All rights reserved.
//

#import "HLItemContentNode.h"

enum {
  HLItemContentBackHighlightNodeZPositionLayerBackHighlight = 0,
  HLItemContentBackHighlightNodeZPositionLayerContent,
  HLItemContentBackHighlightNodeZPositionLayerCount
};

@implementation HLItemContentBackHighlightNode
{
  SKNode *_backHighlightNode;
}

- (instancetype)initWithContentNode:(SKNode *)contentNode backHighlightNode:(SKNode *)backHighlightNode
{
  self = [super init];
  if (self) {
    contentNode.name = @"content";
    [self addChild:contentNode];
    backHighlightNode.name = @"backHighlight";
    _backHighlightNode = backHighlightNode;
    [self HL_layoutZ];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    _backHighlightNode = [aDecoder decodeObjectForKey:@"backHighlightNode"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [super encodeWithCoder:aCoder];
  [aCoder encodeObject:_backHighlightNode forKey:@"backHighlightNode"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  HLItemContentBackHighlightNode *copy = [super copyWithZone:zone];
  if (copy) {
    if (_backHighlightNode.parent) {
      copy->_backHighlightNode = [copy childNodeWithName:@"backHighlightNode"];
    } else {
      copy->_backHighlightNode = [_backHighlightNode copy];
    }
  }
  return copy;
}

- (CGSize)size
{
  SKNode *contentNode = [self childNodeWithName:@"content"];
  return [(id)contentNode size];
}

- (void)setZPositionScale:(CGFloat)zPositionScale
{
  [super setZPositionScale:zPositionScale];
  [self HL_layoutZ];
}

- (void)hlItemContentSetHighlight:(BOOL)highlight
{
  if (highlight) {
    if (!_backHighlightNode.parent) {
      [self addChild:_backHighlightNode];
    }
  } else {
    if (_backHighlightNode.parent) {
      [_backHighlightNode removeFromParent];
    }
  }
}

- (void)HL_layoutZ
{
  CGFloat zPositionLayerIncrement = self.zPositionScale / HLItemContentBackHighlightNodeZPositionLayerCount;
  SKNode *contentNode = [self childNodeWithName:@"content"];
  contentNode.zPosition = HLItemContentBackHighlightNodeZPositionLayerContent * zPositionLayerIncrement;
  _backHighlightNode.zPosition = HLItemContentBackHighlightNodeZPositionLayerBackHighlight * zPositionLayerIncrement;
}

@end
