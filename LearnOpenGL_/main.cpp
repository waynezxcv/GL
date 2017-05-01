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
#include "Window.hpp"
#include "Triangle.hpp"


const GLuint kWidth = 640;
const GLuint kHeight = 480;
const std::string kTitle = "A OpenGL Project";


using namespace std;

int main(int argc, const char * argv[]) {
    
    LWGL::Window* window = new LWGL::Window(kWidth,kHeight,kTitle);
    LWGL::Shader* triangleShader = new LWGL::Shader("/Users/waynezxcv/Code/LearnOpenGL/LearnOpenGL_/triangle.vert",
                                                    "/Users/waynezxcv/Code/LearnOpenGL/LearnOpenGL_/triangle.frag");
    
    
    
    LWGL::Triangle* triangle = new LWGL::Triangle(*triangleShader);
    window -> renderCallBack = [triangle]() -> void {
        triangle -> render();
    };
    
    
    window -> run();
    
    
    delete window;
    delete triangleShader;
    
    return 0;
}



