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


#import "LearnOpenGLESViewController_1.h"

@interface LearnOpenGLESViewController_1 ()

{
    GLuint vertexBufferID;//uint32_t
}


@property (nonatomic,strong) GLKBaseEffect* baseEffect;//简化OpenGLES很多常用操作.


@end


//#if defined(__STRICT_ANSI__)
//struct _GLKVector3
//{
//    float v[3];
//};
//typedef struct _GLKVector3 GLKVector3;
//#else
//union _GLKVector3
//{
//    struct { float x, y, z; };
//    struct { float r, g, b; };
//    struct { float s, t, p; };
//    float v[3];
//};
//typedef union _GLKVector3 GLKVector3;
//#endif



typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;


static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0f}},
    {{0.5f,-0.5f,0.0f}},
    {{-0.5f,0.5f,0.0f}},
};


@implementation LearnOpenGLESViewController_1


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置当前上下文
    GLKView* view = (GLKView *)self.view;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    [EAGLContext setCurrentContext:context];
    
    //创建并初始化GLKBaseEffect实例
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    
    //使用恒定不变的白色来渲染
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //设置当前上下文的 清除颜色
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    
    //定义要绘制的三角形的顶点未知数据必须从CPU发送到GPU来渲染,这里创建一个用于保存顶点数据的顶点属性数组缓存.
    
    //step 1.为缓存生成一个独一无二的标志符
    //第一个参数用于指定要生存的缓存标志符的数量,第二个参数是一个指针,指向生成的标识符的内存保存位置.
    glGenBuffers(1, &vertexBufferID);
    
    //step 2.为接下来的运算绑定缓存.
    //第一个参数用于指定绑定哪一种类型的缓存.GL_ARRAY_BUFFER 类型用于指定一个顶点属性数组.第二个参数是要绑定的缓存标志符.
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    //step 3.复制数据到缓存中.
    //第一个参数用于指定要更新当前上下文中所绑定的是哪一个缓存.第二个参数指定要复制进这个缓存的字节大小.
    //第三个参数是要复制的字节的地址.第四个参数提示了混存在未来的运算中将如何使用.
    //GL_STATIC_DRAW表示这个缓存不会频繁更改. GL_DYNAMIC_DRAW表示这个混存会频繁更改.
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);//清除当前帧的缓存
    
    //step 4.启动
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //step 5.设置指针
    //告诉顶点苏沪在哪里
    //第一个参数告诉指示当前的缓存包含每个顶点的位置信息.
    //第二个参数指示每个位置有3个部分
    //第三个参数告诉每个部分都保存为一个浮点型的值
    //第四个参数告诉小数点固定数据是否可以改变.
    //第五个参数叫"步幅" :它指定了每个顶点的保存需要多少字节.
    //第六个参数告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据.
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    
    //step 6.绘图
    glDrawArrays(GL_TRIANGLES,
                 0,
                 3);
}


- (void)dealloc {
    //step 7.删除不在需要的顶点缓存和上下文.
    
    GLKView* view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != vertexBufferID) {
        
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
}


@end
