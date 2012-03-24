//
//  DollView.m
//  hex'd
//
//  Created by Howard Jing on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DollView.h"

@implementation DollView

#pragma mark - Setting up OpenGLES

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setUpLayer 
{
    eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
}

- (void)setUpContext 
{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setUpRenderBuffer
{
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
}

- (void)setUpFrameBuffer
{
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
}

#pragma mark - Drawing
- (void)render 
{
    glClearColor(0.5,0.5,0.5,1);
    glClear(GL_COLOR_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


# pragma mark - Boring stuff
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpLayer];
        [self setUpContext];
        [self setUpRenderBuffer];
        [self setUpFrameBuffer];
        [self render];
    }
    return self;
}

- (void)dealloc
{
    [context release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
