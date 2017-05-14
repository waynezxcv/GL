//
//  LearnOpenGLESViewController_4.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_4.h"
#import "CustomShader.h"
#import "TextureHelper.h"






@interface LearnOpenGLESViewController_4 ()

@property (nonatomic,strong) CustomShader* shader;

@property (nonatomic,assign) GLfloat timeValue;
@property (nonatomic,assign) GLfloat greenValue;



@end

@implementation LearnOpenGLESViewController_4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeValue = 0.0f;
    self.greenValue = 0.0f;
    
    self.view.backgroundColor = [UIColor whiteColor];
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.05f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    
    
    NSString* vertextPath = [[NSBundle mainBundle] pathForResource:@"vs1" ofType:@"glsl"];
    NSString* fragmentPath = [[NSBundle mainBundle] pathForResource:@"fs1" ofType:@"glsl"];
    self.shader = [[CustomShader alloc] initWithVertexPath:vertextPath fragmentPath:fragmentPath];
    
    
    GLfloat vertices [] = {
        -0.5f,-0.5f,0.0f,//左边
        0.5f,-0.5f,0.0f,//右边
        0.0f,0.5f,0.0f//上边
    };
    
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.shader.program, "position");
    
    glVertexAttribPointer(position,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          3 * sizeof(GLfloat),
                          (GLvoid *) 0);
    glEnableVertexAttribArray(position);
    
}


- (void)timerFired:(id)sender {
    self.timeValue += 0.05f;
    GLfloat greenValue = (sin(self.timeValue) / 2) + 0.5;
    self.greenValue = greenValue;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    //获取ourColor变量
    GLint vertexColorLocation = glGetUniformLocation(self.shader.program, "ourColor");
    
    
    [self.shader useProgram];
    glUniform4f(vertexColorLocation, 0.0f, self.greenValue, 0.0f, 1.0f);
    
    
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
