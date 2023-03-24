# iOS核心动画高级技术阅读笔记

[toc]

## 图层树

1. CALayer是UIView的图层属性，即backing layer，负责视图的绘图、布局和动画，不能处理触摸事件。UIView封装了一些CALayer的方法，简化了动画的实现，但是还有一些功能没有暴露出来：
    - 阴影、圆角、带颜色的边框
    - 3D变换
    - 非矩形范围
    - 透明遮罩
    - 多级非线性动画
2. 在下面情况下，需要使用CALayer而不是UIView
    - 开发iOS和Mac OS运行的跨平台应用
    - 使用多种CALayer的子类（特殊layer），并且不想创建额外的UIView去封装
    - 做一些对性能很挑剔的工作

## 寄宿图

1. CAlayer有个类型为id的属性**contents**，对其赋值一个CGImage（实际应该是CGImageRef，指向CGImage的指针），就能渲染出图片，赋值其他类型则显示空白（Mac OS则可以赋值CGImage和NSImage）。UIImage的CGImage属性会返回CGImageRef，但是不能直接赋值给contents，因为它是Core Foundation类型，而不是Cocoa对象，需要进行转换：

    ```objective-c
    layer.contents = (__bridge id)image.CGImage;
    ```

2. 修改UIImgeView的contentMode可以改变视图的伸缩切割方式，对应CALayer则有**contentsGravity**相对应：

    ```objective-c
    	kCAGravityCenter 
        kCAGravityTop 
        kCAGravityBottom 
        kCAGravityLeft 
        kCAGravityRight 
        kCAGravityTopLeft 
        kCAGravityTopRight 
        kCAGravityBottomLeft 
        kCAGravityBottomRight 
        kCAGravityResize 
        kCAGravityResizeAspect 
        kCAGravityResizeAspectFill
    ```

3. **contentsScale**属性（对应UIView的contentScaleFactor）定义了寄宿图的像素尺寸和视图大小比例，属于支持高分辨率（Retina）屏幕机制的一部分，用来判断在绘制图层时应该为寄宿图创建的空间大小，和需要显示的图片的拉伸度。默认是1.0，表示会以每个点1个像素绘制图片，设置为2.0则会以每个点2个像素绘制图片。设置contentsScale不一定会改变寄宿图，假如设置了contentsGravity为kCAGravityResize等会拉伸图片的值就不会生效。

4. 由于CGImage没有拉伸的概念，而UIImage有，如果使用UIImage去读取高质量的Retina图片，然后用CGImage赋值给图层的contents，拉伸因素会丢失，导致图片最终渲染的效果会比较大且有像素的颗粒感，可以通过设置正确的contentsScale解决：

    ```objective-c
    layer.contentsScale = image.scale;
    
    // 使用代码设置寄宿图时，需要手动设置contentsScale属性，否则图片在Retina设备显示会不正确
    layer.contentsScale = [UIScreen mainScreen].scale;
    ```

5. **maskToBounds**（对应UIView的clipsToBounds）设置为YES可以使超出图层边界的内容被截断

6. **contentsRect**允许在图层边框里显示寄宿图的一个子域。它使用的是单位坐标，即0-1之间的相对值。默认值是{0, 0, 1, 1}，表示整个寄宿图都是默认可见的，如果设置为{0, 0, 0.5, 0.5}则图片会被裁减，只能看到左上部分。利用该属性可以做图片拼合，即把多张图片打包整合到一张大图一次性载入（减少内存使用，载入时间，提高渲染性能），再通过子域分别读取。

    ```
    补充知识：iOS的坐标系统
    点 —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称 作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一 个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备 和普通设备上能有一致的视觉效果。
    像素 —— 一些底层的图片表示如CGImage就会使用像素，所以在Retina设备和普通设备上，他们表现出来了不同的大小。
    单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式，当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。
    ```

    拼合技术开源库：[LayerSprites](https://github.com/nicklockwood/LayerSprites)

7. **contentsCenter**是一个CGRect，定义了一个固定的边框和一个在图层上可拉伸的区域，默认是{0, 0, 1, 1}，表示大小改变时（contentsGravity发生变化）寄宿图会被均匀拉伸，当如下图区域缩小时，改变大小，周围边框厚度不变，只有区域内被拉伸

    ![image-20230222162238345](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230222162238345.png)

8. 除了直接给contents赋值，还可以使用Core Graphic直接绘制寄宿图。通过继承UIView并实现**drawRect**方法来自定义绘制。drawRect没有默认实现，因为对于UIView，寄宿图不是必须的（比如纯色视图就不需要寄宿图）。如果drawRect被调用，UIView会分配一个寄宿图，大小等于视图大小乘以contentsScale的值，所以没有寄宿图就不要写个空的drawRect，会浪费CPU和内存资源。

9. drawRect其实是CALayerDelegate的方法中自动调用的，如果使用UIView，则其CALayer属性的代理就是UIView本身，所以只要实现drawRect就可以被自动调用。如果是自己创建的图层，则需要自己显示调用display方法，强制重绘图层，并实现drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx代理方法

    ```objective-c
    ...
    {
        ...
        layer.delegate = self;
        [layer display];
    }
    
    - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
    {
      //draw a thick red circle
      CGContextSetLineWidth(ctx, 10.0f);
      CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
      CGContextStrokeEllipseInRect(ctx, layer.bounds);
    }
    ```

## 图层几何学

1. UIView**布局**有三个重要属性：frame，bounds和center，对应CALayer的frame，bounds和position。frame代表图层的外部坐标，bounds代表图层的内部坐标，center和position代表相对于父图层anchorPoint所在的位置，由于默认情况下anchorPoint在图层中心，且position和anchorPoint重合，UIView也不暴露anchorPoint，所以属性名为center。

2. ⚠️frame是一个虚拟属性，是根据bounds，position和transform计算来的，当其中一个值发生改变，frame都会变化，改变frame也会影响三个值，如旋转图层后，frame实际代表覆盖在图层旋转后的轴对齐的矩形区域，即**frame和bounds宽高不一定一致**

    ![image-20230222170403140](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230222170403140.png)

3. **锚点**anchorPoint通过position来控制图层的frame位置，可以认为是用来移动图层的把柄。默认位于图层的中点，即图层会以这个点为中心放置，如果移到frame的左上角，则图层的内容将会向右下角的position方向移动。

    ![image-20230222171453192](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230222171453192.png)

    anchorPoint使用的也是单位坐标，和position互不影响，两者发生变化改变的都只有frame的坐标：

    ```objective-c
    frame.origin.x = position.x - anchorPoint.x * bounds.size.width；  
    frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    ```

    如果要修改anchorPoint又不想移动layer即不改变frame.origin，只需要改变anchorPoint后再设置一遍frame就可以了，position会自动改变。

4. 锚点应用实例：改变锚点位置使得钟表以针尾为中心旋转：

    ```objective-c
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    ```

    ![image-20230222173647030](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230222173647030.png)

5. 图层的position依赖于它父图层的bounds，父视图移动，所有子视图都会跟着移动。下面方法可以转换不同图层间的坐标

    ```objective-c
    - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;
    - (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;
    - (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
    - (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
    ```

6. CALayer存在于一个三维空间，有**zPosition**和**anchorPointZ**两个三维属性，在三维空间移动或旋转图层时会用到，也可以用来改变图层的显示顺序（图层出现的顺序是画家算法，新出现的图层会盖在旧图层上面）。只需要将旧图层的zPosition设置为1（即前移1个像素），就可以让其处于新图层前面。⚠️改变zPosition可以改变屏幕图层顺序，但是不能改变事件传递的顺序。

    ```objective-c
    self.greenView.layer.zPosition = 1.0f;
    ```

7. 图层不能直接处理手势和触摸事件，但是提供了一系列方法帮忙处理事件：

    - containsPoint接收一个本图层坐标系的CGPoint，如果点在图层frame范围内就返回YES，不过需要把触摸坐标转换成每个图层坐标系下的坐标。
    - hitTest也是接受CGPoint，不过返回的是图层本身，或包含该坐标点的叶子节点图层。

8. UIView的自动布局可以通过UIViewAutoresizingMask和NSLayoutConstraint API实现。CALayer则需要实现CALayerDelegate的layoutSublayersOfLayer控制布局，当图层bounds改变或图层的setNeedsLayout被调用时，这个函数会被执行，允许开发者手动重新摆放或重新调整子图层大小，无法做到UIView那样自适应。

## 视觉效果

1. **cornerRadius**的属性控制图层角的曲率，默认是0，即直角，该属性默认只影响背景颜色而不影响背景图片或子图层，如果maskToBounds设置成YES的话，整个图层则会被截取。
2. **borderWidth**和**borderColor**共同定义了图层边的绘制样式，前者定义边框粗细（默认为0），后者定义边框颜色（默认为黑色）。borderColor是CGColorRef类型（声明要用assign关键字），边框绘制在图层边界里面，且在所有子内容/子图层之前。
3. **shadowOpacity**默认为0，表示阴影不可见，设置为0-1表示阴影含透明度，设置为1表示阴影完全不透明。shadowColor表示阴影颜色，默认为黑色。**shadowOffset**表示阴影偏移，默认是{0，-3}，表示Y轴向上偏移3个像素（Mac OS则是向下偏移，因为原点在左下角）。**shadowRadius**表示阴影模糊度，为0时表示阴影有明显的边界线，值变大时阴影会更模糊自然。
4. 阴影形状是根据寄宿图形状轮廓确定的（不是边界和角半径），阴影通常在图层边界外，如果maskToBounds为YES，阴影就会被裁剪。解决办法是用两个图层，外层显示阴影，内层显示裁剪后的内容。
5. 阴影计算比较消耗资源，如果事先知道阴影形状，可以指定**shadowPath**来提升性能，其本质上是CGPathRef（指向CGPath的指针）类型。
6. **mask**，图层蒙版，是CALayer类型的图层属性，通过设置mask定义一个图层的轮廓，轮廓内的区域会被保留，轮廓外的区域会被裁剪。
7. 当需要显示伸缩后的非真实大小的图片时（比如头像的缩略图），可以通过设置**minificationFilter**（缩小）和**magnificationFilter**（放大）实现，两者都有三个选项：
    - kCAFilterLinear （默认值，采用双线性滤波算法，一般表现不错，但放大倍数较大时会模糊不清）
    - kCAFilterNearest （取样最近单像素点，快且不会模糊，但压缩图片效果比较遭，放大后会显示块状或马赛克严重，不过对于没有斜线的小图，效果最佳）
    - kCAFilterTrilinear  （采用三线性滤波算法，较双线性滤波算法，存储了多个大小情况下的图片，并三维采样，能从一系列接近最终大小的图片中得到想要的结果，提供性能，避免取样失灵）
8. UIView通过alpha属性确定视图的透明度，对应CALayer的opacity属性，该属性设置后会影响子图层，子父视图的透明度会混合叠加，比如纯白背景的子视图opacity设置为0.5，则图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色，如果还有个纯白0.5透明度的子视图，则子视图展示的是0.75纯白颜色，因为除了父视图的0.5纯白，还有子视图的0.25纯白。

![image-20230223165126536](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230223165126536.png)

9. 解决透明度混合的办法：

    - 设置Info.plist的**UIViewGroupOpacity**为YES，不过影响的是全局，iOS 7默认是YES。

    - 设置**shouldResterize**属性为YES，在应用透明度时图层和子图层会被整合成一个整体。药注意同时设置**rasterizationScale**属性以匹配Retina屏幕。

        ```objective-c
        button2.layer.shouldRasterize = YES;
        button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
        ```

    - 如果同时设置UIViewGroupOpacity和shouldResterize，则会有性能问题。

## 变换

### 仿射变换

1. 所谓的仿射变换就是无论变换矩阵用什么值，图层中平行的两条线变换后依然保持平行。计算公式如下，图层的每一个像素坐标乘以矩阵后得到新坐标：

    ![image-20230223172625034](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230223172625034.png)

2. Core Graphics提供一些方法创建CGAffineTransform实例:

    ```objective-c
    // 旋转（参数用弧度M_PI）
    CGAffineTransformMakeRotation(CGFloat angle)
    // 缩放
    CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
    // 平移
    CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
    ```

    使用方法：

    ```objective-c
    // 顺时针旋转45度
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.layerView.layer.affineTransform = transform;
    ```

3. Core Graphics提供一系列方法可以在变换基础上再变换：

    ```objective-c
    CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
    CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
    CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
    ```

    混合一系列变换：

    ```objective-c
    // 创建空值，即单位矩阵，不会做任何变换
    CGAffineTransform transform = CGAffineTransformIdentity;
    // 缩小一半
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    // 旋转30度
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    // 右移200像素
    transform = CGAffineTransformTranslate(transform, 200, 0);
    self.layerView.layer.affineTransform = transform;
    ```

    ⚠️变换顺序会影响最后展示的结果

### 3D变换

1. 计算公式：

![image-20230224113107119](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230224113107119.png)

2. Core Animation提供一系列方法创建CATransform3D：

    ```objective-c
    // 旋转（参数用弧度M_PI），x，y，z表示在三个坐标轴方向上的旋转
    CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
    // 缩放
    CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
    // 平移
    CATransform3DMakeTranslation(CGFloat tx, CGFloat ty, CGFloat tz)
        
    // 混合变换
    CATransform3DRotate(CATransform3D transform, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
    CATransform3DScale(CATransform3D transform, CGFloat sx, CGFloat sy, CGFloat sz)
    CATransform3DTranslate(CATransform3D transform, CGFloat tx, CGFloat ty, CGFloat tz)
    ```

    沿y轴旋转45度，左边由于没有透视，所以看起来变扁了，右边则是透视后的效果

    ```objective-c
    CATransform3DMakeRotation(M_PI_4, 0, 1, 0)
    ```

    ![image-20230224115256121](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230224115256121.png)    ![image-20230224115430409](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230224115430409.png)

3. m<sub>34</sub>用于按比例缩放X和Y值来计算视距，默认为0，设置为-1.0/d可以显示透视效果，d表示视距。应用透视效果后再旋转：

    ```objective-c
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
    ```

4. 在透视角度，近大远小，当远离到极限时，所有物体会汇聚在一个点（灭点）。通常在屏幕中点，Core Animation定义该点位于变换图层的anchorPoint，图层变换时，这个点永远位于图层变换前anchorPoint的位置。图层position改变时，灭点也会改变，所以视图做3D变换前，要先将它置于屏幕中央，然后通过平移移动到指定位置，不能直接改变其position，这样所有3D图层才能共享一个灭点。

5. **sublayerTransform**变换影响所有子图层，也就是说可以一次性对多个子图层做相同变换。比如可以把视图都放到一个容器视图，对容器视图设置sublayerTransform做透视变换，这样其他视图都不用先放到屏幕中点做平移，直接设置position或frame放置就能共享灭点，实例：

    ```objective-c
    // 在一个容器中并排放两个视图，对容器的所有子图层做透视变换
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = - 1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    // 分别旋转
    self.layerView1.layer.transform = transform1;
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.layerView2.layer.transform = transform2;
    ```

    ![image-20230224150232921](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230224150232921.png)

6. 将视图沿Y轴做180度旋转后即可获得背面图像（正面的镜像图片），默认情况下，图层是双面绘制的，可以通过设置**doubleSided**属性为NO，使图层背面不被绘制。

7. 在2D场景中，有父子两个视图，父视图顺时针转45度，子视图逆时针转45度，二者效果会抵消，子视图会保持不动。但是在3D场景中，因为图层并不是存在于同一个3D空间（每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面，比如倾斜手机不能看到屏幕里内容的侧面），所以二者会分别旋转，效果如下：

    ```objective-c
    	//rotate the outer layer 45 degrees
        CATransform3D outer = CATransform3DIdentity;
        outer.m34 = -1.0 / 500.0;
        outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
        self.outerView.layer.transform = outer;
        //rotate the inner layer -45 degrees
        CATransform3D inner = CATransform3DIdentity;
        inner.m34 = -1.0 / 500.0;
        inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
        self.innerView.layer.transform = inner;
    ```

    ![image-20230227101315181](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227101315181.png)

    CATransformLayer可以解决这个问题，所有加入到这种图层的图层都共享同一个标准3D坐标系。

### 固体对象

- 创建一个3D立方体：

    ```objective-c
    - (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
    {
        //get the face view and add it to the container
        UIView *face = self.faces[index];
        [self.containerView addSubview:face];
        //center the face view within the container
        CGSize containerSize = self.containerView.bounds.size;
    	face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
        // apply the transform
        face.layer.transform = transform;
    }
    
    - (void)viewDidLoad
    {
        [super viewDidLoad];
        //set up the container sublayer transform
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.containerView.layer.sublayerTransform = perspective;
        //add cube face 1
        CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
        [self addFace:0 withTransform:transform];
        //add cube face 2
        transform = CATransform3DMakeTranslation(100, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        [self addFace:1 withTransform:transform];
        //add cube face 3
        transform = CATransform3DMakeTranslation(0, -100, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
        [self addFace:2 withTransform:transform];
        //add cube face 4
        transform = CATransform3DMakeTranslation(0, 100, 0);
        transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
        [self addFace:3 withTransform:transform];
        //add cube face 5
        transform = CATransform3DMakeTranslation(-100, 0, 0);
        transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
        [self addFace:4 withTransform:transform];
        //add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -100);
        transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
        [self addFace:5 withTransform:transform];
    }
    ```

    此时观察到的立方体如下：

    ![image-20230227160842966](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227160842966.png)

    修改透视矩阵，使得相机位置绕Y轴转45度，绕X轴转45度，得到真实面貌

    ```objective-c
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    ```

    ![image-20230227161003652](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227161003652.png)

- 如果想要立方体效果更真实，就需要添加光亮和阴影，一个是直接用有颜色的图片，另一个是根据每个视图的方向应用不同的alpha值，首先找到每个面的正态向量，然后根据想象的光源计算出两个向量的叉乘，计算方法如下：

    ```objective-c
    #define LIGHT_DIRECTION 0, 1, -0.5
    #define AMBIENT_LIGHT 0.5
    
    - (void)applyLightingToFace:(CALayer *)face
    {
        //add lighting layer
        CALayer *layer = [CALayer layer];
        layer.frame = face.bounds;
        [face addSublayer:layer];
        //convert the face transform to matrix
        //(GLKMatrix4 has the same structure as CATransform3D)，获得图层方向
        CATransform3D transform = face.transform;
        GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
        GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
        //get face normal，计算法线
        GLKVector3 normal = GLKVector3Make(0, 0, 1);
        normal = GLKMatrix3MultiplyVector3(matrix3, normal);
        normal = GLKVector3Normalize(normal);
        //get dot product with light direction，计算叉乘
        GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
        float dotProduct = GLKVector3DotProduct(light, normal);
        //set lighting layer opacity
        CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
        UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
        layer.backgroundColor = color.CGColor;
    }
    
    // addFace的时候对每个面调用
    [self applyLightingToFace:face.layer];
    
    ```

    ![image-20230227163450306](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227163450306.png)

- 立方体表面3上有个按钮，但是点击按钮并不会响应，而会被后添加的表面4，5，6拦截，设置doubleSized为NO也不能解决这个问题，因为视图不渲染的背面也会响应点击事件，解决办法可以是将除3外的userInteractionEnabled设置为false，也可以将3置于最前面。

## 专用图层

### CAShapeLayer

1. CAShapeLayer优点：
    - 渲染快速，CAShapeLayer 使用了硬件加速，绘制同一图形会比用Core Graphics直接绘制快很多。
    - 高效使用内存。一个 CAShapeLayer 不需要像普通 CALayer 一样创建一个寄宿图形，而是通过矢量图形绘制，所以无论有多大，都不会占用太多的内存。
    - 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉，比如设置contentsGravity，layer可能会被裁剪。
    - 不会出现像素化。当你给 CAShapeLayer 做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。

2. CAShapeLayer可以绘制所有CGPath能表示的形状，一个图层可以绘制多个不同的形状，但是lineWidth（线宽），lineCap（线条结尾样式），lineJoin（线条结合样式）等属性只能设置一种，如果要用不同颜色和风格绘制多个形状，则需要多个图层。

3. 绘制火柴人（CAShapeLayer是CGPathRef类型，使用UIBezierPath则不用人工释放）：

    ```objective-c
    //使用UIBezierPath创建涂层
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //开始画图，先指定一个点开始
    [path moveToPoint:CGPointMake(175, 100)];   
    //先画一个圆，指定圆心，半径，起始的角度和结束角度
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //画好圆之后，移动这一点到圆的最下方，来画火柴人的身子
    [path moveToPoint:CGPointMake(150, 125)];
    //先画一条直线，可以看到，x值相等，竖直方向画了一条直线
    [path addLineToPoint:CGPointMake(150, 175)];
    //这是一条斜线，位于左下角，通过坐标变换可以看出来
    [path addLineToPoint:CGPointMake(125, 225)];
    //画好左下角的斜线后移动到斜线的起始点
    [path moveToPoint:CGPointMake(150, 175)];
    //画右下角的那条斜线，通过坐标来观察
    [path addLineToPoint:CGPointMake(175, 225)];
    //画好之后火柴人就剩下胳膊了，现在移动到这个点来画一条直线
    [path moveToPoint:CGPointMake(100, 150)];
    //这是一条直线，y不变，x变了100，说明这是一条水平长100的直线
    [path addLineToPoint:CGPointMake(200, 150)];
    //这里我们的线条已经画完了，现在需要把我们画的线条显示出来
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //设置线条的颜色
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    //设置填充色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //设置线条宽度
    shapeLayer.lineWidth = 5;
    //设置线条起点终点样式
    shapeLayer.lineJoin = kCALineJoinRound;
    //设置线条拐角样式
    shapeLayer.lineCap = kCALineCapRound;
    //把线条的路径交给CAShapeLayer处理成图像
    shapeLayer.path = path.CGPath;    
    [self.view.layer addSublayer:shapeLayer];
    ```

    ![image-20230227172034287](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227172034287.png)

4. 绘制圆角可以指定有圆角的角：

    ```objective-c
    //define path parameters
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    //create path
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    //创建图层
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.frame = rect;
    shapeLayer.path = path.CGPath;
    //应用圆角
    self.someView.layer.mask = shapeLayer;
    ```

### CATextLayer

1. CATextLayer以图层的形式包含了 UILabel 几乎所有的绘制特性，并且额外提供了一些新的特性，渲染速度也比UILable快（UILabel通过图层代理将字符串使用Core Graphics写入图层内容）。

2. 使用CATextLayer实现一个UILabel：

    ```objective-c
      //create a text layer
      CATextLayer *textLayer = [CATextLayer layer];
      textLayer.frame = self.labelView.bounds;
      [self.labelView.layer addSublayer:textLayer];
      //set text attributes
      textLayer.foregroundColor = [UIColor blackColor].CGColor;
      textLayer.alignmentMode = kCAAlignmentJustified;
      textLayer.wrapped = YES;
      //choose a font
      UIFont *font = [UIFont systemFontOfSize:15];
      //set layer font
      //注意字体可以是CGFontRef，也可以是CTFontRef（CoreText字体），二者均不含点大小，需要另外设置字体大小
      CFStringRef fontName = (__bridge CFStringRef)font.fontName;
      CGFontRef fontRef = CGFontCreateWithFontName(fontName);
      //Core Text类型
      //CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
      textLayer.font = fontRef;
      textLayer.fontSize = font.pointSize;
      CGFontRelease(fontRef);
      //choose some text
      NSString *text = @"Lorem ipsum dolor sit amet, consectetur ...";
      //set layer text
      //string 是id类型，可以是NSString也可以是NSAttributedString
      textLayer.string = text;
      //这样绘制的文字有些地方会像素化，需要设置contentScale，以Retina方式渲染
      textLayer.contentsScale = [UIScreen mainScreen].scale;
    ```

3. 编写一个以CATextLayer而不是CALayer为宿主图层的UILabel的替代品（首先继承UILabel，然后重写**layerClass**方法（⚠️记住这个方法），使宿主图层创建为CATextLayer类型）：

    ```objective-c
    @implementation LayerLabel
    + (Class)layerClass
    {
    	return [CATextLayer class];
    }
    
    - (CATextLayer *)textLayer
    {
    	return (CATextLayer *)self.layer;
    }
    
    - (id)initWithFrame:(CGRect)frame
    {
        //called when creating label programmatically
        if (self = [super initWithFrame:frame]) {
            [self setUp];
        }
        return self;
    }
    
    - (void)setUp
    {
        //set defaults from UILabel settings
        self.text = self.text;
        self.textColor = self.textColor;
        self.font = self.font;
        //we should really derive these from the UILabel settings too 
        //but that's complicated, so for now we'll just hard-code them 
        [self textLayer].alignmentMode = kCAAlignmentJustified;
        [self textLayer].wrapped = YES;
        [self.layer display];
    }
    
    - (void)setText:(NSString *)text
    {
        super.text = text;
        //set layer text
        [self textLayer].string = text;
    }
    
    - (void)setTextColor:(UIColor *)textColor
    {
        super.textColor = textColor;
        //set layer text color
        [self textLayer].foregroundColor = textColor.CGColor;
    }
    
    - (void)setFont:(UIFont *)font
    {
        super.font = font;
        //set layer font
        CFStringRef fontName = (__bridge CFStringRef)font.fontName; 
        CGFontRef fontRef = CGFontCreateWithFontName(fontName); 
        [self textLayer].font = fontRef;
        [self textLayer].fontSize = font.pointSize;
        CGFontRelease(fontRef);
    }
    
    @end
    ```

    把CATextLayer作为宿主图层会自动设置contentScale属性，不会像素化

### CATransformLayer

1. CATransformLayer不能显示自己的内容，它不会扁平化它的子图层，也就是说它的子图层会共用一个标准坐标系，做变换时，其所有子图层会作为一个整体一起变换，可以用来构造层级的3D结构。

2. 创建一个已CATransformLayer为宿主图层的方法可以参考上一节的例子，重写layerClass。

    下面是创建两个立方体，然后两个立方体分别作为整体进行变换的例子：

    ```objective-c
    - (CALayer *)cubeWithTransform:(CATransform3D)transform
    {
        //create cube layer
        CATransformLayer *cube = [CATransformLayer layer];
        //add cube face 1
        CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
        [cube addSublayer:[self faceWithTransform:ct]];
        //add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0);
        ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
        [cube addSublayer:[self faceWithTransform:ct]];
        // ···
        //add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50);
        ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
        [cube addSublayer:[self faceWithTransform:ct]];
        //center the cube layer within the container
        CGSize containerSize = self.containerView.bounds.size;
        cube.position = CGPointMake(containerSize.width / 2.0, container
    Size.height / 2.0);
        //apply the transform and return
        cube.transform = transform;
        return cube;
    }
    
    - (CALayer *)faceWithTransform:(CATransform3D)transform
    {
        //create cube face layer
        CALayer *face = [CALayer layer];
        face.frame = CGRectMake(-50, -50, 100, 100);
        //apply a random color
        CGFloat red = (rand() / (double)INT_MAX);
        CGFloat green = (rand() / (double)INT_MAX);
        CGFloat blue = (rand() / (double)INT_MAX);
        face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        //apply the transform and return 
        face.transform = transform; 
        return face;
    }
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        //set up the perspective transform
        CATransform3D pt = CATransform3DIdentity;
        pt.m34 = -1.0 / 500.0;
        self.containerView.layer.sublayerTransform = pt;
        //set up the transform for cube 1 and add it
        CATransform3D c1t = CATransform3DIdentity;
        c1t = CATransform3DTranslate(c1t, -100, 0, 0);
        CALayer *cube1 = [self cubeWithTransform:c1t];
        [self.containerView.layer addSublayer:cube1];
        //set up the transform for cube 2 and add it
        CATransform3D c2t = CATransform3DIdentity;
        c2t = CATransform3DTranslate(c2t, 100, 0, 0);
        c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
        c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
        CALayer *cube2 = [self cubeWithTransform:c2t];
        [self.containerView.layer addSublayer:cube2];
    }
    ```

    ![image-20230227195046517](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227195046517.png)

### CAGradientLayer

1. CAGradientLayer可以用来生产多种颜色平滑渐变的效果，绘制时也使用了硬件加速。

2. 基础渐变，绘制左上角红，右下角蓝的渐变图层：

    ```objective-c
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:gradientLayer];
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor
                             , (__bridge id)[UIColor blueColor].CGColor];
    //set gradient start and end points
    //（0，0）表示起点在左上角，（1，1）表示终点在右下角
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    ```

    ![image-20230227195522154](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230227195522154.png)

3. 多重渐变，设置locations数组，可以实现多种颜色渐变，注意locations数组要和colors数组的元素个数一致。

    ```objective-c
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor
                             , (__bridge id)[UIColor yellowColor].CGColor
                             , (__bridge id)[UIColor greenColor].CGColor]];
    //set locations
    gradientLayer.locations = @[@0.0, @0.25, @0.5];
    ```

### CAReplicatorLayer

1. CAReplicatorLayer可以生成多个相似图层，instanceCount指定重复次数，instanceTransform指定CATransform3D变换，变换是递增的，表示新实例相对上一个实例的布局变换。

2. 生成一圈方块：

    ```objective-c
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:replicator];
    //configure the replicator
    replicator.instanceCount = 10;
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
    ```

    ![image-20230228100718170](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230228100718170.png)

3. 应用一个负比例的复制图层，可以创建指定视图内容的镜像图片，即反射。创建一个以CAReplicatorLayer为寄宿图层的UIView子类，可以实时生成子视图的反射：

    ```objective-c
    + (Class)layerClass
    {
        return [CAReplicatorLayer class];
    }
    - (void)setUp
    {
        //configure replicator
        CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
        layer.instanceCount = 2;
        //move reflection instance below original and flip vertically
        CATransform3D transform = CATransform3DIdentity;
        CGFloat verticalOffset = self.bounds.size.height + 2;
        transform = CATransform3DTranslate(transform, 0, verticalOffse
    t, 0);
        // 反转
        transform = CATransform3DScale(transform, 1, -1, 0);
        layer.instanceTransform = transform;
        //reduce alpha of reflection layer
        layer.instanceAlphaOffset = -0.6;
    }
    - (id)initWithFrame:(CGRect)frame
    {
        //this is called when view is created in code
        if ((self = [super initWithFrame:frame])) {
            [self setUp];
        }
        return self;
    }
    ```

    ![image-20230228101927674](iOS%E6%A0%B8%E5%BF%83%E5%8A%A8%E7%94%BB%E9%AB%98%E7%BA%A7%E6%8A%80%E6%9C%AF%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20230228101927674.png)

    自适应渐变淡出效果：[ReflectionView](https://github.com/nicklockwood/ReflectionView)

### CAScrollLayer

1. CAScrollLayer有一个scrollToPoint方法，会自动适应图层bounds原点以便图层内容出现在滑动的地方，比如用小窗观察大图，手指滑动时，小窗会跟随手势移动位置。

2. 可以自定义UIView的子类，使用CAScrollLayer作为寄宿图层，创建出UIScrollView的替代品。

    ```objective-c
    + (Class)layerClass
    {
        return [CAScrollLayer class];
    }
    - (void)setUp
    {
        //enable clipping
        self.layer.masksToBounds = YES;
        //attach pan gesture recognizer
        UIPanGestureRecognizer *recognizer = nil;
        recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:recognizer];
    }
    - (id)initWithFrame:(CGRect)frame
    {
        //this is called when view is created in code
        if ((self = [super initWithFrame:frame])) {
            [self setUp];
        }
        return self;
    }
    - (void)awakeFromNib {
        //this is called when view is created from a nib
        [self setUp];
    }
    - (void)pan:(UIPanGestureRecognizer *)recognizer
    {
        //get the offset by subtracting the pan gesture
        //translation from the current bounds origin
        CGPoint offset = self.bounds.origin;
        offset.x -= [recognizer translationInView:self].x;
        offset.y -= [recognizer translationInView:self].y;
        //scroll the layer
        [(CAScrollLayer *)self.layer scrollToPoint:offset];
        //reset the pan gesture translation
        [recognizer setTranslation:CGPointZero inView:self];
    }
    ```

    因为没有边界检查，所以

