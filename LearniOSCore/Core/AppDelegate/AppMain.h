//
// AppMain.h
// LearniOS
//
// Created by DEEP on 2023/12/27
// Copyright © 2023 DEEP. All rights reserved.
//
        
#ifndef AppMain_h
#define AppMain_h

#if defined(__cplusplus)
#define APPCORE_EXPORT extern "C"
#else
#define APPCORE_EXPORT extern
#endif

APPCORE_EXPORT __attribute__((used,visibility("default"))) int AppMain(int argc, char * _Nullable argv[_Nullable]);

#endif /* AppMain_h */
