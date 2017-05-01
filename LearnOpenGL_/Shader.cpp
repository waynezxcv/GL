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





#include "Shader.hpp"



/*
 为了让OpenGL知道我们的坐标和颜色值构成的到底是什么，OpenGL需要你去指定这些数据所表示的渲染类型。
 我们是希望把这些数据渲染成一系列的点？一系列的三角形？还是仅仅是一个长长的线？
 做出的这些提示叫做图元(Primitive)，任何一个绘制指令的调用都将把图元传递给OpenGL。
 这是其中的几个：GL_POINTS、GL_TRIANGLES、GL_LINE_STRIP。
 */


/*
 图形渲染管线的第一个部分是顶点着色器(Vertex Shader)，它把一个单独的顶点作为输入。
 顶点着色器主要的目的是把3D坐标转为另一种3D坐标，同时顶点着色器允许我们对顶点属性进行一些基本处理。
 */

/*
 图元装配(Primitive Assembly)阶段将顶点着色器输出的所有顶点作为输入（如果是GL_POINTS，那么就是一个顶点），
 并所有的点装配成指定图元的形状；
 */

/*
 图元装配阶段的输出会传递给几何着色器(Geometry Shader)。几何着色器把图元形式的一系列顶点的集合作为输入，它可以通过产生新顶点构造出新的（或是其它的）图元来生成其他形状。
 */

/*
 几何着色器的输出会被传入光栅化阶段(Rasterization Stage)，这里它会把图元映射为最终屏幕上相应的像素，生成供片段着色器(Fragment Shader)使用的片段(Fragment)。
 在片段着色器运行之前会执行裁切(Clipping)。裁切会丢弃超出你的视图以外的所有像素，用来提升执行效率。
 */

/*
 片段着色器的主要目的是计算一个像素的最终颜色，这也是所有OpenGL高级效果产生的地方。
 通常，片段着色器包含3D场景的数据（比如光照、阴影、光的颜色等等），这些数据可以被用来计算最终像素的颜色。
 */


/*
 在所有对应颜色值确定以后，最终的对象将会被传到最后一个阶段，我们叫做Alpha测试和混合(Blending)阶段。
 这个阶段检测片段的对应的深度（和模板(Stencil)）值（后面会讲），用它们来判断这个像素是其它物体的前面还是后面，决定是否应该丢弃。
 这个阶段也会检查alpha值（alpha值定义了一个物体的透明度）并对物体进行混合(Blend)。
 所以，即使在片段着色器中计算出来了一个像素输出的颜色，在渲染多个三角形的时候最后的像素颜色也可能完全不同。
 */



using namespace LWGL;


Shader::Shader(const GLchar* vertexPath,const GLchar* fragmentPath) {
    
    //1.从文件路径中获取顶点着色器和片段着色器
    std::string vertexCode;
    std::string fragmentCode;
    
    std::ifstream vShaderFile;
    std::ifstream fShaderFile;
    
    vShaderFile.exceptions(std::ifstream::badbit);
    fShaderFile.exceptions(std::ifstream::badbit);
    
    try {
        //打开文件
        vShaderFile.open(vertexPath);
        fShaderFile.open(fragmentPath);
        
        std::stringstream vShaderStream;
        std::stringstream fShaderStream;
        
        //读取文件的buffer内容到流中
        vShaderStream << vShaderFile.rdbuf();
        fShaderStream << fShaderFile.rdbuf();
        
        //关闭文件
        vShaderFile.close();
        fShaderFile.close();
        
        vertexCode = vShaderStream.str();
        fragmentCode = fShaderStream.str();
        
    } catch (std::ifstream::failure e) {
        std::cout << "Error : Shader::file not successfully read!" <<std::endl;
    }
    
    
    //转换至GLchar数组
    const GLchar* vShaderCode = vertexCode.c_str();
    const GLchar* fShaderCode = fragmentCode.c_str();
    
    //2.编译和连接着色器程序
    GLuint vertextShader;
    GLuint fragmentShader;
    GLchar infoLog[512];
    GLint success;
    
    
    //顶点着色器
    vertextShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertextShader,1,&vShaderCode,NULL);
    glCompileShader(vertextShader);
    glGetShaderiv(vertextShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(vertextShader, 512, NULL, infoLog);
        std::cout << "Error : vertex shader complilation failed :" <<infoLog << std::endl;
    }
    
    
    //片段着色器
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fShaderCode, NULL);
    glCompileShader(fragmentShader);
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "Error : fragment shader complilation failed :" <<infoLog << std::endl;
    }
    
    //创建着色器程序
    this -> program = glCreateProgram();
    glAttachShader(this -> program, vertextShader);
    glAttachShader(this -> program, fragmentShader);
    glLinkProgram(this -> program);
    glGetProgramiv(this -> program, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(this -> program, 512, NULL, infoLog);
        std::cout << "Error : shader program link failed :" <<infoLog << std::endl;
    }
    
    //删除着色器
    glDeleteShader(vertextShader);
    glDeleteShader(fragmentShader);
}


void Shader::useProgram() {
    glUseProgram(this -> program);
}


