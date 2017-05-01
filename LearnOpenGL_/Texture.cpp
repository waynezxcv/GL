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


#include "Texture.hpp"
#include <SOIL.h>


using namespace LWGL;


Texture::Texture(const Shader& shader) : shader(shader) {
    
    GLfloat vertices[] = {
        // 顶点坐标          // 颜色               // 纹理坐标
        0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f, //右上
        0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f, //右下
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f, //左下
        -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f  //左上
    };
    
    
    
    GLuint indices[] = {
        0, 1, 3,
        1, 2, 3
    };
    
    
    
    /*
     VAO : 顶点数组对象。
     可以像顶点缓冲对象那样被绑定，任何随后的顶点属性调用都会储存在这个VAO中。
     这样的好处就是，当配置顶点属性指针时，你只需要将那些调用执行一次，之后再绘制物体的时候只需要绑定相应的VAO就行了。
     这使在不同顶点数据和属性配置之间切换变得非常简单，只需要绑定不同的VAO就行了。
     刚刚设置的所有状态都将存储在VAO中。
     */
    
    /*
     VBO : 顶点缓冲对象。
     通过顶点缓冲对象(Vertex Buffer Objects, VBO)管理这个内存，它会在GPU内存(通常被称为显存)中储存大量顶点。
     使用这些缓冲对象的好处是我们可以一次性的发送一大批数据到显卡上，而不是每个顶点发送一次。
     */
    
    
    this -> VAO = new GLuint();
    this -> VBO = new GLuint();
    this -> EBO = new GLuint();
    
    glGenVertexArraysAPPLE(1, VAO);
    glGenBuffers(1, VBO);
    glGenBuffers(1, EBO);
    
    glBindVertexArrayAPPLE(*VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, *VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    //顶点
    glVertexAttribPointer(
                          0,//指定我们要配置的顶点属性。
                          3,//指定顶点属性的大小，点属性是一个vec3，它由3个值组成，所以大小是3。
                          GL_FLOAT,////指定数据的类型为浮点型
                          GL_FALSE,//是否希望数据被标准化，如果设置为TRUE，所有数据都会被映射为0到1之间。
                          8 * sizeof(GLfloat),//『步长』，表示在连续的顶点属性组之间的间隙
                          (GLvoid *)0);//表示位置数据在混充中起始位置的偏移量。
    
    glEnableVertexAttribArray(0);
    
    //颜色
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat),  (GLvoid*)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
    
    
    //纹理
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(6 * sizeof(GLfloat)));
    glEnableVertexAttribArray(2);
    glBindVertexArrayAPPLE(0); // 解绑VAO
    
    
    //创建纹理
    this -> texture1 = new GLuint();
    glGenTextures(1,this -> texture1);
    glBindTexture(GL_TEXTURE_2D,* (this ->texture1));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    int width, height;
    unsigned char* image = SOIL_load_image("pic1.jpg", &width, &height, 0, SOIL_LOAD_RGB);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
    glGenerateMipmap(GL_TEXTURE_2D);
    SOIL_free_image_data(image);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
    
    this -> texture2 = new GLuint();
    glGenTextures(1, this -> texture2);
    glBindTexture(GL_TEXTURE_2D, *(this -> texture2));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    image = SOIL_load_image("pic2.jpg", &width, &height, 0, SOIL_LOAD_RGB);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
    glGenerateMipmap(GL_TEXTURE_2D);
    SOIL_free_image_data(image);
    glBindTexture(GL_TEXTURE_2D, 0);
}



Texture::~Texture() {
    glDeleteVertexArraysAPPLE(1, VAO);
    glDeleteBuffers(1, VBO);
    glDeleteBuffers(1, EBO);
    
    delete VAO;
    delete VBO;
    delete EBO;
    delete texture1;
    delete texture2;
}



void Texture::render() {
    //设置清屏
    glClearColor(0.2f, 0.3f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    //使用着色器程序
    this -> shader.useProgram();
    
    //使用纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, *(this -> texture1));
    glUniform1i(glGetUniformLocation(this -> shader.program, "Texture1"), 0);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D,  *(this -> texture2));
    glUniform1i(glGetUniformLocation(this -> shader.program, "Texture2"), 1);
    
    //绑定VAO
    glBindVertexArrayAPPLE(*VAO);
    
    //绘制
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArrayAPPLE(0);
    
}

