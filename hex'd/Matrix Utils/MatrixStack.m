//
//  MatrixStack.m
//  opengltest
//
//  Created by Howard Jing on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixStack.h"

@implementation MatrixStack

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        stack = [[NSMutableArray alloc] init];
        
        // initialize with the identity matrix
        [stack addObject:[CC3GLMatrix identity]];
    }
    return self;
}

- (void)push 
{
    CC3GLMatrix *matrix = [[[CC3GLMatrix alloc] init] autorelease];
    [CC3GLMatrix copyMatrix:[self peek] into:matrix.glMatrix];
    [stack addObject:matrix];
}

- (void)pop 
{
    [stack removeLastObject];
}

- (GLfloat *)peek 
{
    CC3GLMatrix *currentMatrix = (CC3GLMatrix *)[stack objectAtIndex:[stack count]-1];
    return currentMatrix.glMatrix;
}

// translate the current matrix
- (void)translate:(CC3Vector)vector 
{
    [CC3GLMatrix translate:[self peek] by:vector];
}

// rotate the current matrix
//- (void)rotate:(GLfloat)angle along:(CC3Vector)vector 
//{
//    // instantiate matrix in column major order
//    CC3GLMatrix *rotateMat = [[[CC3GLMatrix alloc] init] autorelease];
//    [CC3GLMatrix multiply:[self peek] byMatrix:rotateMat.glMatrix];
//}

- (void)rotateYXZ:(CC3Vector)vector 
{
    [CC3GLMatrix rotateYXZ:[self peek] by:vector];
}

// scale the current matrix
- (void)scale:(CC3Vector)factor {
    [CC3GLMatrix scale:[self peek] by:factor];
}

@end
