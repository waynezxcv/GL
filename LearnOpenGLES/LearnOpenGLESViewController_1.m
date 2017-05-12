//
//  LearnOpenGLESViewController_1.m
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_1.h"


@interface LearnOpenGLESViewController_1 ()


@property (nonatomic,assign) GLsizei indicesCount;
@property (nonatomic,strong) GLKBaseEffect* effect;



@end

@implementation LearnOpenGLESViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* glkView = (GLKView *)self.view;
    glkView.context = context;
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    self.effect.useConstantColor = GL_TRUE;
    
    GLfloat vertices[] = {
        0.5f, 0.5f, 0.0f,   // 右上角
        0.5f, -0.5f, 0.0f,  // 右下角
        -0.5f, -0.5f, 0.0f, // 左下角
        -0.5f, 0.5f, 0.0f   // 左上角
    };
    
    GLuint indices[] = { // 注意索引从0开始!
        0, 1, 3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    };
    
    self.indicesCount = sizeof(indices)/sizeof(GLuint);
    
    //顶点缓冲对象VBO
    GLuint VBO;
    glGenBuffers(1, &VBO);//生成VBO标识符
    glBindBuffer(GL_ARRAY_BUFFER, VBO);//设置缓冲对象的保存方式，这里表示放在数组当中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);//将VBO从CPU复制到GPU
    //告诉OpenGL如何解析顶点属性
    glVertexAttribPointer(0,
                          3,//指定顶点属性的大小
                          GL_FLOAT,//顶点的数据类型
                          GL_FALSE,//是否标准化，若GL_TRUE所有数据会被映射到-1到1之间
                          3 * sizeof(GLfloat),//步长，表示连续顶点属性之间的间隔。
                          (GLvoid *)0);//它表示位置数据在缓冲中起始位置的偏移量(Offset)。由于位置数据在数组的开头，所以这里是0。
    glEnableVertexAttribArray(0);//以顶点属性位置值作为参数，启用顶点属性
    
    
    
    
    
    
    //索引缓冲对象 EBO
    //对于重叠的顶点只储存不同的顶点，并设定绘制这些顶点的顺序。，之后只要指定绘制的顺序就行了。
    GLuint EBO;
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //启动着色器
    [self.effect prepareToDraw];
    
    
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    glDrawElements(GL_TRIANGLES, self.indicesCount, GL_UNSIGNED_INT, 0);
    
}

@end
