/*
 https://github.com/waynezxcv/GL
 
 Copyright (c) 2017 waynezxcv <liuweiself@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */





#import "CustomGLKView.h"

@interface CustomGLKView ()

@property (nonatomic,assign) GLuint defaultFrameBuffer;
@property (nonatomic,assign) GLuint colorRenderBuffer;

@end



@implementation CustomGLKView

@synthesize context = _context;

+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//designated initializer
- (id)initWithFrame:(CGRect)frame conxtext:(EAGLContext *)context {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.context = context;
        CAEAGLLayer* eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@(NO),//告诉CoreAnimation不保存背景,任何部分需要在屏幕上显示的时候都要绘制整个层的内容
                                         kEAGLColorFormatRGBA8:kEAGLDrawablePropertyColorFormat//用8位来保存层内的每个像素的每个颜色元素的值
                                         };
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAEAGLLayer* eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@(NO),
                                         kEAGLColorFormatRGBA8:kEAGLDrawablePropertyColorFormat};
    }
    return self;
}



#pragma mark - Setter & Getter

- (void)setContext:(EAGLContext *)context {
    if (_context != context) {
        [EAGLContext setCurrentContext:context];
        
        if (0 != _defaultFrameBuffer) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        
        if (0 != _colorRenderBuffer) {
            glDeleteRenderbuffers(1, &_colorRenderBuffer);
            _colorRenderBuffer = 0;
        }
        
        _context = context;
        
        if (nil != _context) {
            
            glGenFramebuffers(1, &_defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
            
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
            
        }
        
    }
}

- (EAGLContext *)context {
    return _context;
}


- (void)display {
    
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0,(GLint)self.drawableWidth,(GLint)self.drawableHeight);
    
    [self drawRect:self.bounds];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    
}


- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate lw_glkView:self drawInRect:self.bounds];
    }
}


- (void)layoutSubviews {
    CAEAGLLayer* eaglLayer = (CAEAGLLayer *)self.layer;
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (GL_FRAMEBUFFER_COMPLETE != status) {
        NSLog(@"failed to make complete frame buffer object : %x",status);
    }
}


- (NSInteger)drawableWidth {
    GLint backingWidth;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    
    return (NSInteger)backingWidth;
}

- (NSInteger)drawableHeight {
    GLint backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    return (NSInteger)backingHeight;
}

- (void)dealloc {
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
}

@end
