//
//  CustomGLKView.m
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "CustomGLKView.h"

@interface CustomGLKView ()

@property (nonatomic,strong) EAGLContext* context;
@property (nonatomic,assign) GLuint defaultFrameBuffer;
@property (nonatomic,assign) GLuint colorRenderBuffer;

@property (nonatomic,assign) GLsizei drawableWidth;
@property (nonatomic,assign) GLsizei drawableHeight;


@end



@implementation CustomGLKView

//CAEAGLLayer是CoreAnimation提供的标准层类之一。它会与OpenGLES的帧缓存共享它的像素颜色仓库
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    if (!context) {
        return nil;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        self.context = context;
        
    }
    return self;
}

- (void)setupLayer {
    CAEAGLLayer* layer = (CAEAGLLayer *)self.layer;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.opaque = YES;
    layer.drawableProperties = @{
                                 kEAGLDrawablePropertyRetainedBacking:@(NO),//告诉CoreAnimation任何部分需要显示都重绘整个屏幕
                                 kEAGLColorFormatRGBA8:kEAGLDrawablePropertyColorFormat//用8位来保存层内的每个像素的每个颜色的值
                                 };
}


- (void)setContext:(EAGLContext *)context {
    
    if (!context) {
        return;
    }
    
    if (_context != context) {
        
        _context = context;
        
        [EAGLContext setCurrentContext:_context];
        
        if (_defaultFrameBuffer != 0) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        
        if (_colorRenderBuffer != 0) {
            glDeleteRenderbuffers(1, &_colorRenderBuffer);
            _colorRenderBuffer = 0;
        }
        
        [EAGLContext setCurrentContext:_context];
        
        
        //帧缓冲区
        //帧缓冲区(显存)：是由像素组成的二维数组，每一个存储单元对应屏幕上的一个像素，整个帧缓冲对应一帧图像即当前屏幕画面。
        //帧缓冲通常包括：颜色缓冲，深度缓冲，模板缓冲和累积缓冲。
        glGenFramebuffers(1, &_defaultFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
        
        
        //颜色缓冲区
        glGenRenderbuffers(1, &_colorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
        
        //将_colorRenderBuffer装配到GL_COLOR_ATTACHMENT0 这个装配点上
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    }
}


- (void)layoutSubviews {
    
    CAEAGLLayer* layer = (CAEAGLLayer *)self.layer;
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"error : make frame buffer objecgt failed : %x",status);
    }
    
    [self display];
    
}

- (void)display {
    [EAGLContext setCurrentContext:self.context];
    //OpenGL的世界坐标系是一个坐标原点在屏幕中心，范围[-1,1]的坐标系
    //这里需要将时间坐标系大小映射到世界坐标上
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    
    [self drawRect:self.bounds];
    
    //将renderbuffer显示到窗口上
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate customGlkView:self drawInRect:rect];
    }
}

- (GLsizei)drawableWidth {
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return backingWidth;
}

- (GLsizei)drawableHeight {
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return backingHeight;
}


- (void)dealloc {
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

@end
