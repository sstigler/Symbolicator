//
//  SYMTreeNode.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/30/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYMTreeNode <NSObject>

/**
 @return The node's child at the given index, or nil if it doesn't have one at that index.
 */
- (instancetype)childAtIndex:(NSInteger)index;

/**
 @return YES if the node is a leaf, otherwise NO.
 */
- (BOOL)isLeaf;

/**
 @return The number of children the node has.
 */
- (NSInteger)numberOfChildren;

/**
 @return The node's children, in alphabetical order.
 */
- (NSArray *)orderedChildren;


/**
 @return The node's display name, for display in a user interface.
 */
- (NSString *)displayName;

@end
