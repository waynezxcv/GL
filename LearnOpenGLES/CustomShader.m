//
//  CustomShader.m
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "CustomShader.h"

@implementation CustomShader

- (id)initWithVertexPath:(NSString *)vertexPath fragmentPath:(NSString *)fragmentPath {
    self = [super init];
    if (self) {
        
        //1.从文件路径中获取顶点着色器和片段着色器
        NSString* vertexContent = [NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:nil];
        NSString* fragmentContent = [NSString stringWithContentsOfFile:fragmentPath encoding:NSUTF8StringEncoding error:nil];
        
        const GLchar* vertextSource = [vertexContent UTF8String];
        const GLchar* fragmentSource = [fragmentContent UTF8String];
        
        //2.编译和链接着色器程序
        GLuint vertextShader , fragmentShader;
        GLchar message[512];
        GLint sucess;
        
        
        
        //顶点着色器
        vertextShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertextShader, 1, &vertextSource, NULL);
        glCompileShader(vertextShader);
        glGetShaderiv(vertextShader, GL_COMPILE_STATUS, &sucess);
        if (!sucess) {
            glGetShaderInfoLog(vertextShader, 512, NULL, message);
            NSLog(@"error : vertext shader compile failed : %@",[NSString stringWithUTF8String:message]);
            
            return nil;
            
        }
        
        
        //片段着色器
        fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader, 1, &fragmentSource, NULL);
        glCompileShader(fragmentShader);
        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &sucess);
        if (!sucess) {
            glGetShaderInfoLog(fragmentShader, 512, NULL, message);
            NSLog(@"error : fragment shader compile failed : %@",[NSString stringWithUTF8String:message]);
            
            return nil;
            
        }
        
        //创建着色器程序
        self.program = glCreateProgram();
        //连接着色器
        glAttachShader(self.program, vertextShader);
        glAttachShader(self.program, fragmentShader);
        glLinkProgram(self.program);
        glGetProgramiv(self.program, GL_LINK_STATUS, &sucess);
        if (!sucess) {
            glGetProgramInfoLog(self.program, 512, NULL, message);
            NSLog(@"error : program link failed : %@",[NSString stringWithUTF8String:message]);
            
            return nil;
        }
        
        //删除着色器
        glDeleteShader(vertextShader);
        glDeleteShader(fragmentShader);
        
    }
    return self;
}


- (void)useProgram {
    glUseProgram(self.program);
}



@end
