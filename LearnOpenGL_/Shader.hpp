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



/*
 着色器(Shader)是运行在GPU上的小程序。这些小程序为图形渲染管线的某个特定部分而运行。
 从基本意义上来说，着色器只是一种把输入转化为输出的程序。着色器也是一种非常独立的程序，因为它们之间不能相互通信；
 它们之间唯一的沟通只有通过输入和输出。
 着色器是使用一种叫GLSL的类C语言写成的。
 
 一个典型的着色器有下面的结构：
 
 #version version_number
 
 in type in_variable_name;
 in type in_variable_name;
 
 out type out_variable_name;
 
 uniform type uniform_name;
 
 int main()
 {
 // 处理输入并进行一些图形操作
 ...
 // 输出处理过的结果到输出变量
 out_variable_name = weird_stuff_we_processed;
 }
 
 
 */


#ifndef Shader_hpp
#define Shader_hpp

#include <string>
#include <fstream>
#include <sstream>
#include <iostream>
#include <OpenGL/gl.h>


namespace LWGL {
    
    //这个类用来管理着色器
    class Shader {
    public:
        //着色器程序的ID
        GLuint program;
        
        //构造函数构建着色器
        Shader(const GLchar* vertexPath,const GLchar* fragmentPath);
        
        //使用着色器程序
        void useProgram();
        
    };
    
}



#endif /* Shader_hpp */
