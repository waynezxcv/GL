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




#include "HelloTriangle.hpp"


//顶点着色器。

const GLchar* vertexShaderSource = "#version 330 core\nlayout (location = 0) in vec3 position;\nvoid main()\n{\ngl_Position = vec4(position.x, position.y, position.z, 1.0);\n}\0";

//片段着色器
//片段着色器全是关于计算你的像素最后的颜色输出。用RGBA表示
const GLchar* fragmentShaderSource = "#version 330 core\nout vec4 color;\nvoid main()\n{\ncolor = vec4(1.0, 0.5, 0.2, 1.0);\n}\n\0";

using namespace LWGL;




const GLfloat vertices[] = {
    
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f,
    0.0f,  0.5f, 0.0f
};




HelloTriangle::HelloTriangle() {

    
    //1. 设置着色器。
    //编译并连接到着色器程序，合并。
    
    
    //顶点着色器
    GLuint vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    GLint sucess;
    GLchar infoLog[512];
    
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &sucess);
    
    if (!sucess) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout<<"vertex shader compilation failed\n" << infoLog << std::endl;
    }
    
    //片段着色器
    GLuint fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &sucess);
    
    if (!sucess) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout<<"fragment shader compilation failed\n" << infoLog << std::endl;
    }
    
    //连接着色器
    //着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本。
    //这里用于将顶点着色器和片段着色器合并。
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    //检查链接错误
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &sucess);
    
    if (!sucess) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        std::cout<<"shader program link failed\n" << infoLog << std::endl;
    }
    
    //在把着色器对象链接到程序对象以后，删除着色器对象，我们不再需要它们了
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    
    
    //2.设置VAO和VBO
    /*
     VAO : 顶点数组对象。
     可以像顶点缓冲对象那样被绑定，任何随后的顶点属性调用都会储存在这个VAO中。这样的好处就是，当配置顶点属性指针时，你只需要将那些调用执行一次，之后再绘制物体的时候只需要绑定相应的VAO就行了。这使在不同顶点数据和属性配置之间切换变得非常简单，只需要绑定不同的VAO就行了。刚刚设置的所有状态都将存储在VAO中。
     */
    VAO = new GLuint();
    glGenVertexArraysAPPLE(1, VAO);
    glBindVertexArrayAPPLE(*VAO);
    
    
    /*
     VBO : 顶点缓冲对象。
     通过顶点缓冲对象(Vertex Buffer Objects, VBO)管理这个内存，它会在GPU内存(通常被称为显存)中储存大量顶点。
     使用这些缓冲对象的好处是我们可以一次性的发送一大批数据到显卡上，而不是每个顶点发送一次。
     */
    VBO = new GLuint();
    glGenBuffers(1, VBO);
    //OpenGL有许多缓冲对象类型，我们可以使用glBindBuffer函数把新创建的缓冲绑定到GL_ARRAY_BUFFER目标上：
    //我们使用的任何（在GL_ARRAY_BUFFER目标上的）缓冲调用都会用来配置当前绑定的缓冲(VBO)。
    glBindBuffer(GL_ARRAY_BUFFER, *VBO);
    
    
    
    //调用glBufferData函数，它会把之前定义的顶点数据复制到缓冲的内存中：
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    //3.设置顶点属性指针。
    //告诉OpenGL该如何解析顶点数据
    glVertexAttribPointer(
                          0,//指定我们要配置的顶点属性。
                          3,//指定顶点属性的大小，点属性是一个vec3，它由3个值组成，所以大小是3。
                          GL_FLOAT,//指定数据的类型为浮点型
                          GL_FALSE,//是否希望数据被标准化，如果设置为TRUE，所有数据都会被映射为0到1之间。
                          3 * sizeof(GLfloat),//『步长』，表示在连续的顶点属性组之间的间隙
                          (GLvoid *)0//表示位置数据在混充中起始位置的偏移量。
                          );
    
    //以顶点属性位置值作为参数，启用顶点属性
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //解绑VAO
    glBindVertexArrayAPPLE(0);
}




HelloTriangle::~HelloTriangle() {
    delete VAO;
    delete VBO;
}


void HelloTriangle::drawTriangle() {
    
    //设置清屏
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //绘制三角形
    
    
    //使用着色器程序
    glUseProgram(shaderProgram);
    
    //绑定VAO
    glBindVertexArrayAPPLE(*VAO);
    
    //绘制
    glDrawArrays(GL_TRIANGLES,//函数第一个参数是我们打算绘制的OpenGL图元的类型。
                 0,//第二个参数指定了顶点数组的起始索引，我们这里填0。
                 3);//最后一个参数指定我们打算绘制多少个顶点，这里是3（我们只从我们的数据中渲染一个三角形，它只有3个顶点长）。
    
    //解绑VAO
    glBindVertexArrayAPPLE(0);
}









