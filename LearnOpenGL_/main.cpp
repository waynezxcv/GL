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





#include <iostream>
#include <GL/glew.h>
#include <GL/glfw3.h>

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


using namespace std;

void render(void) {
    
    //设置清屏颜色，在每个渲染迭代开始的时候清屏
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glBegin(GL_TRIANGLES);
    
    glColor3f(1.0f,0.0f,0.0f);
    glVertex2f(0.0f, 0.5f);
    glColor3f(0.0f,1.0f,0.0f);
    glVertex2f(-0.5f,-0.5f);
    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex2f(0.5f, -0.5f);
    
    glEnd();
}


void setupGLEW() {
    
    glewExperimental = GL_TRUE;
    if (!glewInit()) {
        cout<<"failed to initialize GLEW"<<endl;
    }
    
}


void releaseGLFW() {
    glfwTerminate();
    exit(EXIT_FAILURE);
}


int main(int argc, const char * argv[]) {
    
    //初始化GLFW
    if(!glfwInit()){
        return -1;
    }
    
    //创建窗口对象
    GLFWwindow* window = glfwCreateWindow(640.0f, 480.0f, "A OpenGL Project", NULL, NULL);
    
    
    //告诉OpenGL渲染的窗口尺寸大小
    int width;
    int height;
    glfwGetFramebufferSize(window, &width, &height);
    
    //设置窗口的维度
    glViewport(0, 0, width, height);
    
    
    if(!window) {
        releaseGLFW();
    }
    
    
    glfwMakeContextCurrent(window);
    
    
    //创建一个循环，在我们明确关闭程序之前一直渲染。
    while(!glfwWindowShouldClose(window)){
        //检查事件
        glfwPollEvents();
        
        //渲染
        render();
        
        //交换缓冲
        glfwSwapBuffers(window);
    }
    
    
    //在循环结束后，我们需要正确释放内存
    releaseGLFW();
    
    return 0;
}



