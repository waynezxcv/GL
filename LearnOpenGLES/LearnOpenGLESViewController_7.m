//
//  LearnOpenGLESViewController_7.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/12.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_7.h"
#import <OpenGLES/ES2/glext.h>

@interface LearnOpenGLESViewController_7 ()

@property (nonatomic,assign) GLuint VAO;

@property (nonatomic,strong) GLKBaseEffect* baseEffect;
@property (nonatomic,strong) GLKSkyboxEffect* skyboxEffect;
@property (nonatomic,strong) GLKTextureInfo* textureInfo;


@property (assign, nonatomic) GLKVector3 eyePosition;
@property (assign, nonatomic) GLKVector3 lookAtPosition;
@property (assign, nonatomic) GLKVector3 upVector;
@property (assign, nonatomic) float angle;


@end

@implementation LearnOpenGLESViewController_7

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.9f,
                                                         0.9f,
                                                         0.9f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    
    
    
    self.eyePosition = GLKVector3Make(0.0, 3.0, 3.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);
    self.upVector = GLKVector3Make(0.0, 1.0, 0.0);
    
    
    glGenVertexArraysOES(1, &_VAO);
    glBindVertexArrayOES(_VAO);
    
    self.textureInfo = [GLKTextureLoader cubeMapWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"skybox0" ofType:@"png"]
                                                           options:nil error:nil];
    
    
    self.skyboxEffect = [[GLKSkyboxEffect alloc] init];
    self.skyboxEffect.textureCubeMap.name = self.textureInfo.name;
    self.skyboxEffect.textureCubeMap.target = self.textureInfo.target;
    
    self.skyboxEffect.xSize = 6.0f;
    self.skyboxEffect.ySize = 6.0f;
    self.skyboxEffect.zSize = 6.0f;
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
}



- (void)preparePointOfViewWithAspectRatio:(GLfloat)aspectRatio {
    
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f),
                                                                           aspectRatio,
                                                                           0.1f,
                                                                           20.0f);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x,
                                                                     self.eyePosition.y,
                                                                     self.eyePosition.z,
                                                                     
                                                                     self.lookAtPosition.x,
                                                                     self.lookAtPosition.y,
                                                                     self.lookAtPosition.z,
                                                                     
                                                                     self.upVector.x,
                                                                     self.upVector.y,
                                                                     self.upVector.z);
    
    self.angle += 0.01;
    self.eyePosition = GLKVector3Make(
                                      3.0f * sinf(self.angle),
                                      3.0f,
                                      3.0f * cosf(self.angle));
    
    self.lookAtPosition = GLKVector3Make(
                                         0.0,
                                         1.5 + 3.0f * sinf(0.3 * self.angle),
                                         0.0);
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    [self preparePointOfViewWithAspectRatio:aspectRatio];
    
    self.baseEffect.light0.position = GLKVector4Make(0.4f,
                                                     0.4f,
                                                     -0.3f,
                                                     0.0f);
    self.skyboxEffect.center = self.eyePosition;
    self.skyboxEffect.transform.projectionMatrix = self.baseEffect.transform.projectionMatrix;
    self.skyboxEffect.transform.modelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    [self.skyboxEffect prepareToDraw];
    
    glDepthMask(false);
    [self.skyboxEffect draw];
    glBindVertexArrayOES(0);
}



@end
