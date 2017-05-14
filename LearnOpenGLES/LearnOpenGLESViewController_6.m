//
//  LearnOpenGLESViewController_6.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/11.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_6.h"
#import <OpenGLES/ES2/glext.h>

static GLfloat vetices[216] = {
    
    // 顶点坐标X, 顶点坐标Y, 顶点坐标Z,     法向量X, 法向量Y, 法向量Z,法向量即绘制的每个三角形平面的法线的方向
    
    0.5f, -0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};


static double GetTimeMS() {
    return (CACurrentMediaTime()*1000.0);
}


@interface LearnOpenGLESViewController_6 ()

@property (nonatomic,strong) EAGLContext* context;
@property (nonatomic,strong) GLKBaseEffect* effect;
@property (nonatomic,strong) GLKBaseEffect* extraEffect;


@property (nonatomic,assign) GLuint VAO;
@property (nonatomic,assign) GLuint VBO;

@property (nonatomic,assign) GLuint vertextCount;

@property (nonatomic,assign) GLfloat radius;
@property (nonatomic,assign) GLfloat rotation;

@property (nonatomic,assign) BOOL zeroDeltaTime;
@property (nonatomic,assign) GLfloat renderTime;


@end

@implementation LearnOpenGLESViewController_6

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zeroDeltaTime = YES;
    
    //设置上下文
    self.view.backgroundColor = [UIColor whiteColor];
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    //给GLKView添加深度缓存
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:context];
    
    //2.设置baseEffect
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    //漫反射光
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    //环境光
    self.effect.light0.ambientColor = GLKVector4Make(0.2f, 0.2f, 0.2f, 1.0f);
    
    //镜面反射颜色
    self.effect.light0.specularColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    
    //开启深度测试
    glEnable(GL_DEPTH_TEST);
    
    //VAO
    glGenVertexArraysOES(1, &_VAO);
    glBindVertexArrayOES(_VAO);
    
    //VBO
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vetices), vetices, GL_DYNAMIC_DRAW);
    
    //设置顶点位置属性
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(GLfloat) * 6,
                          (GLvoid *) 0);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //设置法线属性数据
    glVertexAttribPointer(GLKVertexAttribNormal,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(GLfloat) * 6,
                          (GLvoid *)(sizeof(GLfloat) * 3));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    
    
    //计算顶点个数
    self.vertextCount = sizeof(vetices) / sizeof(GLfloat) / 6;
    
    //解绑VAO
    glBindVertexArrayOES(0);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //更新动画参数
    double currentTime = GetTimeMS();
    double deltaTime = _zeroDeltaTime ? 0.0 : currentTime - _renderTime;
    self.renderTime = currentTime;
    if (self.zeroDeltaTime) {
        self.zeroDeltaTime = FALSE;
    }
    self.rotation += deltaTime * 0.05 * M_PI / 180.0;
    
    //恢复VAO
    glBindVertexArrayOES(_VAO);
    
    //设置背景颜色
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //屏幕纵横比
    GLfloat aspect = rect.size.width / rect.size.height;
    
    //用于整个场景的坐标系
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    
    //用于控制对象显示位置的坐标系
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, self.rotation, 0.0f, 1.0f, 0.0f);
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -fabs(1.0f));
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    //使用着色器程序
    [self.effect prepareToDraw];
    
    //绘制
    glDrawArrays(GL_TRIANGLES, 0, self.vertextCount);
}


@end
