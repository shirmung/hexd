//
//  DollView.h
//  hex'd
//
//  Created by Howard Jing on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#import "MatrixStack.h"

@interface DollView : UIView {
    CAEAGLLayer *eaglLayer;
    EAGLContext *context;
    GLuint colorRenderBuffer;
    GLuint depthRenderBuffer;
    
    GLuint position;
    GLuint color;
    
    GLuint projectionUniform;
    GLuint modelViewUniform;
    
    MatrixStack *modelView;
    
    // Vertex Buffer Objects and
    // Index Buffer Objects
    GLuint squareVBO;
    GLuint squareIBO;
    
    GLuint circleVBO;
    
    GLuint trapezoidVBO;
    GLuint trapezoidIBO;
    
    // rotation
    int rotation;
    //int angle;
}

@end
