//
//  glDrawElements(GL_TRIANGLES, self.indicesCount, GL_UNSIGNED_INT, 0); LearnOpenGLESViewController_3.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_3.h"
#import "CustomShader.h"




@interface LearnOpenGLESViewController_3 ()

@property (nonatomic,strong) CustomShader* shader;

@end

@implementation LearnOpenGLESViewController_3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    
    NSString* vertextPath = [[NSBundle mainBundle] pathForResource:@"vertextShader" ofType:@"glsl"];
    NSString* fragmentPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader" ofType:@"glsl"];
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

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.shader useProgram];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end
