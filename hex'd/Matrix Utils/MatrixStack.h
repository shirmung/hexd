//
//  MatrixStack.h
//  opengltest
//
//  Created by Howard Jing on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"
#import "CC3GLMatrix.h"

// A stack of CC3GLMatrixs
@interface MatrixStack : NSObject {
    NSMutableArray *stack;
}

- (void)push;
- (void)pop;
- (GLfloat *)peek;  // returns a pointer to the current matrix
- (void)translate:(CC3Vector)vector;
//- (void)rotate:(GLfloat)angle along:(CC3Vector)vector;
- (void)scale:(CC3Vector)factor;
- (void)rotateYXZ:(CC3Vector)vector;
@end
