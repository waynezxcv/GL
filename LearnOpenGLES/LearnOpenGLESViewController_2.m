//
//  LearnOpenGLESViewController_2.m
//  LearnOpenGLES
//
//  Created by liu.wei on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "LearnOpenGLESViewController_2.h"
#import "CustomShader.h"
#import "TextureHelper.h"
#import <OpenGLES/ES2/glext.h>


typedef enum {
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
}
AGLKPowerOf2;

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension( GLuint dimension) {
    AGLKPowerOf2  result = AGLK1;
    
    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    
    return result;
}
static NSData* AGLKDataWithResizedCGImageBytes(CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr) {
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    
    GLuint originalWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originalHeight = (GLuint)CGImageGetWidth(cgImage);
    
    NSCAssert(0 < originalWidth, @"Invalid image width");
    NSCAssert(0 < originalHeight, @"Invalid image width");
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    GLuint width = AGLKCalculatePowerOf2ForDimension(
                                                     originalWidth);
    GLuint height = AGLKCalculatePowerOf2ForDimension(
                                                      originalHeight);
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData    *imageData = [NSMutableData dataWithLength:
                                   height * width * 4];  // 4 bytes per RGBA pixel
    
    NSCAssert(nil != imageData,
              @"Unable to allocate image storage");
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(
                                                   [imageData mutableBytes], width, height, 8,
                                                   4 * width, colorSpace,
                                                   kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height),
                       cgImage);
    
    CGContextRelease(cgContext);
    
    *widthPtr = width;
    *heightPtr = height;
    
    return imageData;
}



@interface LearnOpenGLESViewController_2 ()

@property (nonatomic,strong) CustomShader* shader;


@property (nonatomic,assign) GLuint VAO;
@property (nonatomic,assign) GLuint VBO;
@property (nonatomic,assign) GLuint tex1;
@property (nonatomic,assign) GLuint tex2;



@end

@implementation LearnOpenGLESViewController_2


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:context];
    
    
    GLfloat vertices [] = {
        -0.75f,0.75f,0.0f,      0.0f,1.0f,//0
        -0.75f,-0.75f,0.0f,     0.0f,0.0f,//1
        0.75f,-0.75f,0.0f,      1.0f,0.0f,//2
        0.75f,0.75f,0.0f ,      1.0f,1.0f,//3
    };
    
    
    GLuint indices [] = {
        0,1,3,
        3,1,2
    };
    
    //加载着色器程序
    NSString* vertexPath = [[NSBundle mainBundle] pathForResource:@"vertexShader2" ofType:@"glsl"];
    NSString* fragmentPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader2" ofType:@"glsl"];
    self.shader = [[CustomShader alloc] initWithVertexPath:vertexPath fragmentPath:fragmentPath];
    
    
    //VBO
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER,
                 sizeof(vertices),
                 vertices,
                 GL_STATIC_DRAW);
    
    
    GLint vertexPosition = glGetAttribLocation(self.shader.program, "inputVertexPosition");
    //设置顶点位置属性
    glVertexAttribPointer(
                          vertexPosition,//对应shader中顶点的位置
                          3,//大小，顶点属性是一个vec3，它由3个值组成，所以大小是3。
                          GL_FLOAT,//数据类型
                          GL_FALSE,//是否标准化
                          sizeof(GLfloat) * 5,//步长
                          (GLvoid *) 0//偏移量
                          );
    glEnableVertexAttribArray(vertexPosition);
    
    
    
    //设置纹理位置属性
    GLint texturePosition = glGetAttribLocation(self.shader.program, "inputTextrueCoord");
    glVertexAttribPointer(texturePosition,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(GLfloat) * 5,
                          (GLvoid *)(sizeof(GLfloat) * 3));
    glEnableVertexAttribArray(texturePosition);
    
    
    
    //EBO
    GLuint EBO;
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    
    //纹理
    size_t width;
    size_t height;
    
    UIImage* image1 = [UIImage imageNamed:@"pic.jpg"];
    NSData* data1 = AGLKDataWithResizedCGImageBytes(image1.CGImage, &width, &height);
    
    glEnable(GL_TEXTURE_2D);
    
    glGenTextures(1, &_tex1);
    glBindTexture(GL_TEXTURE_2D, _tex1);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width,(GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data1.bytes);
    
    
    UIImage* image2 = [UIImage imageNamed:@"pic2.png"];
    NSData* data2 = AGLKDataWithResizedCGImageBytes(image2.CGImage, &width, &height);
    
    glGenTextures(1, &_tex2);
    glBindTexture(GL_TEXTURE_2D, _tex2);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data2.bytes);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _tex1);
    GLint texLocation1 = glGetUniformLocation(self.shader.program, "colorMap1");
    glUniform1i(texLocation1, _tex1);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _tex2);
    GLint texLocation2 = glGetUniformLocation(self.shader.program, "colorMap2");
    glUniform1i(texLocation2, _tex2);
    
    [self.shader useProgram];
    
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}


@end
