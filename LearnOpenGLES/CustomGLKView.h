//
//  CustomGLKView.h
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/10.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import <GLKit/GLKit.h>





@class CustomGLKView;

@protocol CustomGLKViewDelegate <NSObject>

@required

- (void)customGlkView:(CustomGLKView *)glkView drawInRect:(CGRect)rect;

@end


@interface CustomGLKView : UIView


@property (nonatomic,weak) id <CustomGLKViewDelegate> delegate;



- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context;


@end
