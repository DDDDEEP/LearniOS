//
// ExampleGLKViewController.m
// Pods
//
// Created by DEEP on 2024/1/22
// Copyright © 2024 DEEP. All rights reserved.
//
        

#import "ExampleGLKViewController.h"

typedef struct{
    GLKVector3 positionCoords;
}sceneVertex;

//三角形的三个顶点
static const sceneVertex vertices[] = {
    {{{-0.5f,-0.5f,0.0}}},
    {{{0.5f,-0.5f,0.0}}},
    {{{-0.5f,0.5f,0.0}}},
};

@interface ExampleGLKViewController (){
    GLuint vertextBufferID;
}

@property (nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation ExampleGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view  = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"ViewController's View is Not A GLKView");
    //创建OpenGL ES2.0上下文
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //设置背景色
    glClearColor(0.0f,0.0f,0.0f,1.0f);
    
    
    //Gen Bind Initial Memory
    
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID); //绑定指定标识符的缓存为当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
 
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    //Clear Frame Buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    //enable
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //设置指针
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE, //小数点固定数据是否被改变
                          sizeof(sceneVertex),
                          NULL);  //从开始位置
    //绘图
    glDrawArrays(GL_TRIANGLES,
                 0,
                 3);
    
}


- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        glDeleteBuffers(1,
                        &vertextBufferID);
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}


@end

