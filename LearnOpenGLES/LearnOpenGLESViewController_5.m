//
//  LearnOpenGLESViewController_5.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/11.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_5.h"
#import "CustomShader.h"



@interface LearnOpenGLESViewController_5 ()

@property (nonatomic,strong) CustomShader* shader;
@property (nonatomic,assign) GLuint indicesCount;

@property (nonatomic,assign) GLfloat totalTime;


@end


@implementation LearnOpenGLESViewController_5


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.totalTime = 0.0f;
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f/30.0f
                                             target:self
                                           selector:@selector(timefired)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.view.backgroundColor = [UIColor whiteColor];
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    
    NSString* vertextPath = [[NSBundle mainBundle] pathForResource:@"vertextShader1" ofType:@"glsl"];
    NSString* fragmentPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader1" ofType:@"glsl"];
    self.shader = [[CustomShader alloc] initWithVertexPath:vertextPath fragmentPath:fragmentPath];
    
    
    GLfloat vertices [] = {
        -1.0f,1.0f,0.0f,      0.0f,1.0f,
        -1.0f,-1.0f,0.0f,     0.0f,0.0f,
        1.0f,-1.0f,0.0f,      1.0f,0.0f,
        1.0f,1.0f,0.0f ,      1.0f,1.0f
    };
    
    
    GLuint indices [] = {
        0,1,3,
        3,1,2
    };
    
    
    
    self.indicesCount = sizeof(indices)/sizeof(GLuint);
    
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    GLint position = glGetAttribLocation(self.shader.program, "inputPosition");
    glVertexAttribPointer(position,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(GLfloat) * 5,
                          (GLvoid *)0);
    glEnableVertexAttribArray(position);
    
    GLint coord = glGetAttribLocation(self.shader.program, "textureCoord");
    glVertexAttribPointer(coord,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(GLfloat) * 5,
                          (GLvoid *) (sizeof(GLfloat) * 3));
    glEnableVertexAttribArray(coord);
    
    GLuint EBO;
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

- (void)timefired {
    self.totalTime += 1.0f/30.0f;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    GLint timeLocation = glGetUniformLocation(self.shader.program, "globalTime");
    GLint columnLocation = glGetUniformLocation(self.shader.program, "columnCount");
    
    [self.shader useProgram];
    
    glUniform1f(timeLocation, self.totalTime);
    glUniform1f(columnLocation, 6.0);
    glDrawElements(GL_TRIANGLES, self.indicesCount, GL_UNSIGNED_INT, 0);
}


@end
