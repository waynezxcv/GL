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
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGE2MENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */



#include "Window.hpp"



/*
 GLFW是一个专门针对OpenGL的C语言库，它提供了一些渲染物体所需的最低限度的接口。它允许用户创建OpenGL上下文，定义窗口参数以及处理用户输入
 */

/*
 因为OpenGL只是一个标准/规范，具体的实现是由驱动开发商针对特定显卡实现的。由于OpenGL驱动版本众多，它大多数函数的位置都无法在编译时确定下来，需要在运行时查询。
 GLEW是OpenGL Extension Wrangler Library的缩写，它能解决我们上面提到的那个繁琐的问题。
 */


/*
 在OpenGL中，任何事物都在3D空间中，而屏幕和窗口却是2D像素数组，这导致OpenGL的大部分工作都是关于把3D坐标转变为适应你屏幕的2D像素。3D坐标转为2D坐标的处理过程是由OpenGL的图形渲染管线管理的。
 图形渲染管线可以被划分为两个主要部分：第一部分把你的3D坐标转换为2D坐标，第二部分是把2D坐标转变为实际的有颜色的像素。
 */

/*
 图形渲染管线接受一组3D坐标，然后把它们转变为你屏幕上的有色2D像素输出。图形渲染管线可以被划分为几个阶段，每个阶段将会把前一个阶段的输出作为输入。所有这些阶段都是高度专门化的（它们都有一个特定的函数），并且很容易并行执行。正是由于它们具有并行执行的特性，当今大多数显卡都有成千上万的小处理核心，它们在GPU上为每一个（渲染管线）阶段运行各自的小程序，从而在图形渲染管线中快速处理你的数据。这些小程序叫做着色器(Shader)。
 */


using namespace LWGL;


Window::Window(const int& width,const int& height,const std::string& title) :width(width) , height(height) ,title(title) {
    
    //初始化GLFW
    if(!glfwInit()){
        return;
    }
    //创建窗口对象
    this -> window = glfwCreateWindow(width, height,title.c_str(), NULL, NULL);
    
    //告诉OpenGL渲染的窗口尺寸大小
    int w;
    int h;
    glfwGetFramebufferSize(this -> window, &w, &h);
    
    //设置窗口的维度
    glViewport(0, 0, w, h);
    
    if(!this -> window) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    
    glfwMakeContextCurrent(this -> window);
}


Window::~Window() {
    glfwTerminate();
    exit(EXIT_FAILURE);
}


void Window::run() {
    
    //创建一个循环，在我们明确关闭程序之前一直渲染。
    while(!glfwWindowShouldClose(this -> window)){
        //检查事件
        glfwPollEvents();
        
        //渲染
        if (this -> renderCallBack != nullptr) {
            this -> renderCallBack();
        }
        
        //交换缓冲
        glfwSwapBuffers(this -> window);
    }
}


int Window::getWidth() const {
    return this -> width;
}


int Window::getHeight() const {
    return this -> height;
}



