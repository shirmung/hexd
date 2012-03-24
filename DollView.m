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

#pragma mark - Set up shapes

// structure to store vertex information
typedef struct {
    float Position[3];
    float Color[4];
} Vertex;


// A square
const Vertex square[] = {
    {{ 1, -1, 0}, {0.5, 0.5, 0.5, 1}}, // bottom right
    {{ 1,  1, 0}, {0.5, 0.5, 0.5, 1}}, // top right
    {{-1,  1, 0}, {0.5, 0.5, 0.5, 1}}, // top left
    {{-1, -1, 0}, {0.5, 0.5, 0.5, 1}}  // bottom left
};
const GLubyte squareIndices[] = {0,1,2,3,0};

// A trapezoid
const Vertex trapezoid[] = {
    {{   1, -1, 0}, {0.5, 0.5, 0.5, 1}}, // bottom right
    {{ 0.9,  1, 0}, {0.5, 0.5, 0.5, 1}}, // top right
    {{-0.9,  1, 0}, {0.5, 0.5, 0.5, 1}}, // top left
    {{  -1, -1, 0}, {0.5, 0.5, 0.5, 1}}  // bottom left
};
const GLubyte trapezoidIndices[] = {0,1,2,3,0};

// find circle vertex points
Vertex circle[30];
- (void)setUpCircle
{
    int limit = 30;
    float changeInTheata = 2*M_PI/limit;
    float theta;
    float x;
    float y;
    float z = 0;
    for (int i=0; i<limit; i++) {
        theta = changeInTheata*i;
        x = cos(-theta);
        y = sin(-theta);
        
        circle[i].Position[0] = x;
        circle[i].Position[1] = y;
        circle[i].Position[2] = z;
        
        circle[i].Color[0] = 0.5;
        circle[i].Color[1] = 0.5;
        circle[i].Color[2] = 0.5;
        circle[i].Color[3] = 1;
    }
}

- (void)setUpBufferObjects
{
    // set up square
    glGenBuffers(1, &squareVBO);
    glBindBuffer(GL_ARRAY_BUFFER, squareVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(square), square, GL_STATIC_DRAW);
    
    glGenBuffers(1, &squareIBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, squareIBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(squareIndices), squareIndices, GL_STATIC_DRAW);
    
    // set up trapezoid
    glGenBuffers(1, &trapezoidVBO);
    glBindBuffer(GL_ARRAY_BUFFER, trapezoidVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(trapezoid), trapezoid, GL_STATIC_DRAW);
    
    glGenBuffers(1, &trapezoidIBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, trapezoidIBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(trapezoidIndices), trapezoidIndices, GL_STATIC_DRAW);
    
    // set up circle
    [self setUpCircle];
    glGenBuffers(1, &circleVBO);
    glBindBuffer(GL_ARRAY_BUFFER, circleVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(circle), circle, GL_STATIC_DRAW);
}

- (void)drawSquare
{
    glUniformMatrix4fv(modelViewUniform, 1, GL_FALSE, [modelView peek]);
    glBindBuffer(GL_ARRAY_BUFFER, squareVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, squareIBO);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(color, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(squareIndices)/sizeof(squareIndices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)drawCircle
{
    glUniformMatrix4fv(modelViewUniform, 1, GL_FALSE, [modelView peek]);
    glBindBuffer(GL_ARRAY_BUFFER, circleVBO);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(color, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    glDrawArrays(GL_TRIANGLE_FAN, 0, sizeof(circle)/sizeof(circle[0]));
}

- (void)drawTrapezoid
{
    glUniformMatrix4fv(modelViewUniform, 1, GL_FALSE, [modelView peek]);
    glBindBuffer(GL_ARRAY_BUFFER, trapezoidVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, trapezoidIBO);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(color, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(trapezoidIndices)/sizeof(trapezoidIndices[0]), GL_UNSIGNED_BYTE, 0);
}


#pragma mark - Draw the doll
- (void)draw 
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
    

    // ==== Drawing Stuff Start ====
    
    [modelView push];
    [modelView scale:CC3VectorMake(0.5, 0.5, 0.5)];
    [modelView translate:CC3VectorMake(0, 1, 0)];
    
    [self drawTrapezoid];
    [self drawHead];
    [self drawBody];
    
    [modelView pop];
    
    // ==== Drawing Stuff End ====
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawHead
{
    [modelView push];
    
    [modelView scale:CC3VectorMake(0.9,1,1)];
    [self drawCircle];
    [modelView pop];
}

- (void)drawBody
{
    [modelView push];
    
    [modelView translate:CC3VectorMake(0, -2, 0)];
    [modelView scale:CC3VectorMake(0.5, 0.5, 1)];
    [self drawSquare];
    [modelView pop];
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
        [self setUpBufferObjects];
        [self draw];
    }
    return self;
}

- (void)dealloc
{
    [context release];
    [modelView release];
    [self deleteBuffers];
    [super dealloc];
}

- (void)deleteBuffers 
{
    glDeleteBuffers(1, &squareVBO);
    glDeleteBuffers(1, &squareIBO);
    glDeleteBuffers(1, &circleVBO);
    glDeleteBuffers(1, &trapezoidVBO);
    glDeleteBuffers(1, &trapezoidIBO);
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
