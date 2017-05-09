//
//  LearnOpenGLESViewController_1.m
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_1.h"
#import "CustomGLKView.h"
#import "CustomShader.h"


@interface LearnOpenGLESViewController_1 ()<CustomGLKViewDelegate>


@property (nonatomic,strong) CustomGLKView* glkView;

@end

@implementation LearnOpenGLESViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.glkView = [[CustomGLKView alloc] initWithFrame:self.view.bounds context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    
    self.glkView.delegate = self;
    [self.view addSubview:self.glkView];
    
    
}


- (void)customGlkView:(CustomGLKView *)glkView drawInRect:(CGRect)rect {
    
    //设置清理颜色（背景颜色）
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    //着色器程序
    NSString* vPath = [[NSBundle mainBundle] pathForResource:@"shaderv" ofType:@"vsh"];
    NSString* fPath = [[NSBundle mainBundle] pathForResource:@"shaderf" ofType:@"fsh"];
    
    CustomShader* shader = [[CustomShader alloc] initWithVertexPath:vPath fragmentPath:fPath];
    
    if (shader) {
        [shader useProgram];
    }
    
    
    //顶点数据，前三个是顶点坐标，后面两个是纹理坐标
    GLfloat squareVertexData[] = {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
    };
    
    //顶点索引
    GLuint indices[] = {
        0, 1, 2,
        1, 3, 0
    };
    
    
    /*
     VBO : 顶点缓冲对象。
     通过顶点缓冲对象(Vertex Buffer Objects, VBO)管理这个内存，它会在GPU内存(通常被称为显存)中储存大量顶点。
     使用这些缓冲对象的好处是我们可以一次性的发送一大批数据到显卡上，而不是每个顶点发送一次。
     */
    
    GLuint buffer;
    glGenBuffers(1, &buffer);//申请一个VBO标识符
    glBindBuffer(GL_ARRAY_BUFFER, buffer);//把标识符绑定到GL_ARRAY_BUFFER上
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);//把顶点数据从CPU复制到GPU
    glEnableVertexAttribArray(GLKVertexAttribPosition);//开启顶点属性
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);

    
    
    
    
    
}

@end
