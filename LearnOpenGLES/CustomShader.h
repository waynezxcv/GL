//
//  CustomShader.h
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import <GLKit/GLKit.h>



//GLKit中的GLKBaseEffect即使封装了基本的着色器程序




@interface CustomShader : NSObject


@property (nonatomic,assign) GLuint program;

- (id)initWithVertexPath:(NSString *)vertexPath fragmentPath:(NSString *)fragmentPath;

- (void)useProgram;

@end
