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

- (void)setUpDepthBuffer
{
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
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
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
}



#pragma mark - Compiling shaders
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error: &error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    return shaderHandle;
}

- (void)compileShaders {
    GLuint vertexShader = [self compileShader:@"VertexShader" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"FragmentShader" withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(programHandle);
    
    position = glGetAttribLocation(programHandle, "Position");
    color = glGetAttribLocation(programHandle, "SourceColor");
    projectionUniform = glGetUniformLocation(programHandle, "Projection");
    modelViewUniform = glGetUniformLocation(programHandle, "ModelView");
    
    glEnableVertexAttribArray(position);
    glEnableVertexAttribArray(color);
}

#pragma mark - Drawing
typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex rect[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte indices[] = {
    0,1,2,
    2,3,0
};

- (void)setUpVBOs 
{
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(rect), rect, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

- (void)render 
{
    glClearColor(1, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    // projection matrix
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = self.frame.size.height / self.frame.size.width;
    [projection populateOrthoFromFrustumLeft:-1 andRight:1 andBottom:-h andTop:h andNear:-1 andFar:1];
    glUniformMatrix4fv(projectionUniform, 1, 0, projection.glMatrix);
    
    

    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(color, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
    [modelView push];
    
    [modelView scale:CC3VectorMake(0.5,0.5,1)];
    [modelView translate:CC3VectorMake(0, 0, 0)];
    glUniformMatrix4fv(modelViewUniform, 1, GL_FALSE, [modelView peek]);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [modelView translate:CC3VectorMake(-0.5, 0.5, 0)];
    glUniformMatrix4fv(modelViewUniform, 1, GL_FALSE, [modelView peek]);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [modelView pop];
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


# pragma mark - Boring stuff
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // ModelView matrix
        modelView = [[MatrixStack alloc] init];
        
        [self setUpLayer];
        [self setUpContext];
        [self setUpDepthBuffer];
        [self setUpRenderBuffer];
        [self setUpFrameBuffer];
        [self compileShaders];
        [self setUpVBOs];
        [self render];
    }
    return self;
}

- (void)dealloc
{
    [context release];
    [modelView release];
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
