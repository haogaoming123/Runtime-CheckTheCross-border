# Runtime-CheckTheCross-border
runtime 检查数组越界、字典插入nil等崩溃问题

在做iOS的时候，因为OC是运行时语言，往往在数组中去数值或者向字典中插入数值的时候，会有nil的现象，这种时候可以通过runtime来避免。
如何使用：
  
    1.在AppDelegate的didFinishLaunchingWithOptions方法中，打开安全检查：
    #pragma 打开安全检查
    [CheckCrossBorder setXcodeSafetyLog:YES];
    
    2.导入CheckCrossBorder.h CheckCrossBorder.m 文件到你的项目中
    
    3.run go!
    
