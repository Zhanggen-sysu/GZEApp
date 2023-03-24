# AutoLayout开发秘籍阅读笔记

[toc]

## 第一章 AutoLayout介绍

- **translatesAutoresizingMaskIntoConstraints**可以将frame布局自动转换成约束布局，如果要使用约束布局就要设置为NO，不然会和自己设置的约束布局发生冲突（当然不设置frame，bounds，center也可以）。默认值是YES

* leading和trailing在英语等系统中分别指左右，而在阿拉伯语等系统指右左，所以国际化程序不要用left和right，而是用leading和trailing

* 测试视图约束是否充分：

  ````objective-c
  - (void)testAmbiguity {
  	  NSLog(@"TestAmbiguity<%@:0x%0x>: %@", self.class.description, (int)self, self.hasAmbiguousLayout ? @"Ambiguous": @"Unambiguous");
  	  for (UIView *view in self.subviews) {
          [view testAmbiguity];
      }
  }
  ````

* 找出视图及其子视图的所有约束：

  ````objective-c
  - (NSArray *)allConstraints {
  	  NSMutableArray *array = [NSMutableArray array];
      [array addObjectsFromArray:self.constraints];
      for (UIView *view in self.subviews) {
  	  	[array addObjectsFromArray:[view allConstraints]];
      }
      return array;
}
  ````

* 视图有内在内容时，AutoLayout会将视图框架尽可能与其自然内容相匹配，只需要设置两个属性的一个（如left或right），就是无歧义布局，改变内在内容，需要调用invalidateIntrinsicContentSize方法

* AutoLayout默认约束优先级是1000

* 压缩阻力可以抵抗压缩，可以通过下面方法设置阻力优先级（1-1000），防止内容被剪切，默认优先级为750：

  ````objective-c
  [btn setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
  
  // 示例，压缩阻力优先级高于宽度优先级，显示图(a)
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
  [btn setTitle:@"Test" forState:UIControlStateNormal];
  btn.backgroundColor = [UIColor blueColor];
  [btn setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisHorizontal];
  [self.view addSubview:btn];
  [btn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.view).offset(200);
      make.left.equalTo(self.view).offset(50);
      make.width.mas_equalTo(20).priority(250);
  }];
  ````

  如图所示，上面压缩阻力优先级高，下面优先级低（这里说的优先级是相对于视图的宽度约束来说的）

  ![image-20221226143533634](AutoLayout%E5%BC%80%E5%8F%91%E7%A7%98%E7%B1%8D%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20221226143533634.png)

* 内容吸附可以防止视图在其核心内容外做填充或直接伸展其内容，默认优先级为250，可以通过下面方法设置：

  ````objective-c
  [btn setContentHuggingPriority:501 forAxis:UILayoutConstraintAxisHorizontal];
  
  // 示例，宽度优先级高于内容吸附优先级，显示如图(b)
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
  [btn setTitle:@"Test" forState:UIControlStateNormal];
  btn.backgroundColor = [UIColor blueColor];
  [btn setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisHorizontal];
  [self.view addSubview:btn];
  [btn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.view).offset(200);
      make.left.equalTo(self.view).offset(50);
      make.width.mas_equalTo(200).priority(250);
  }];
  ````
  
  如图所示，上图内容吸附优先级高，下图优先级低
  
  ![image-20221226143515461](AutoLayout%E5%BC%80%E5%8F%91%E7%A7%98%E7%B1%8D%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20221226143515461.png)
  
* 上述两个优先级都是为了保持视图大小和其内在内容保持一致，一个避免被压缩，一个避免被拉伸

* 对齐矩形：当图像有阴影或其他装饰元素时，可以通过设置对齐矩阵的边界偏移使得视图按主元素正确居中：

  ```objective-c
  UIImage *image = [[UIImage imageNamed:@"Shadowed.png"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 20, 20)];
  ```

  ![image-20221226143445827](AutoLayout%E5%BC%80%E5%8F%91%E7%A7%98%E7%B1%8D%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20221226143445827.png)

* 根据对齐矩形构建边缘inset：

  ```objective-c
  - (UIEdgeInsets)buildInsets:(CGRect)alignmentRect imageBounds:(CGRect) imageBounds {
      CGRect targetRect = CGRectIntersection(alignmentRect, imageBounds);
      UIEdgeInsets insets;
      insets.left = CGRectGetMinX(imageBounds) - CGRectGetMinX(targetRect);
      insets.right = CGRectGetMaxX(imageBounds) - CGRectGetMaxX(targetRect);
      insets.top = CGRectGetMinY(imageBounds) - CGRectGetMinY(targetRect);
      insets.bottom = CGRectGetMaxY(imageBounds) - CGRectGetMaxY(targetRect);
    return insets;
  }
  
  // 以上图为例
  UIEdgeInsets inset = [self buildInsets:CGRectMake(0, 0, 180, 180) imageBounds:CGRectMake(0, 0, 200, 200)];
  ```

* alignmentRectForFrame和frameForAlignmentRect是互逆的，一般重写前者

## 第二章 约束

- 约束类型

    1. 布局约束（NSLayoutConstraint）：公有，最常用，指定视图位置尺寸等关系或数值

    2. 内容大小约束（NSContentSizeLayoutConstraint）：私有，包括内容压缩阻力，内容吸附

    3. 自动尺寸调整约束（NSAutoresizingMaskLayoutConstrain）：私有，frame转autolayout

    4. 布局支持约束（_UILayoutSupportConstraint）：私有，iOS7新增，用于引导顶部和底部状态栏的实际边界（to pLayoutGuide和bottomLayoutGuide）

    5. 原型约束（NSIBPrototypingLayoutConstraint）：私有，IB添加的约束

- 布局约束：

    ![image-20221226185725172](AutoLayout%E5%BC%80%E5%8F%91%E7%A7%98%E7%B1%8D%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20221226185725172.png)

    ![image-20221226185901160](AutoLayout%E5%BC%80%E5%8F%91%E7%A7%98%E7%B1%8D%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0.assets/image-20221226185901160.png)

-  发生约束冲突时，优先级高的约束会比优先级低的约束优先处理，可以使用数值设置，也可以使用枚举设置

    ```objective-c
    enum {
        UILayoutPriorityRequired = 1000,
        UILayoutPriorityDefaultHigh = 750,
        UILayoutPriorityDefaultLow = 250,
        UILayoutPriorityFittingSizeLevel = 50,
    }
    ```

- UIView默认没有内在内容intrinsicContentSize为(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)，也即(-1, -1)

- 视图的约束必须建立在两种合法情况下：一个视图是另一个视图的父视图，或二者是有共同父视图的兄弟视图

    ```objective-c
    // UIView扩展，找两个View的最近父视图（可以判断两个视图能不能合法建立约束）
    - (NSArray *)superViews {
        NSMutableArray *array = [NSMutableArray array];
        UIView *view = self.superview;
        while (view) {
            [array addObject:view];
            view = view.superview;
        }
        return array;
    }
    
    - (BOOL)isAncestorOfView:(UIView *)view {
        return [[view superViews] containsObject:self];
    }
    
    - (UIView *)nearestCommonAncestorToView:(UIView *)aView {
        if ([self isEqual:aView]) {
            return self;
        }
        if ([self isAncestorOfView:aView]) {
            return self;
        }
        if ([aView isAncestorOfView:self]) {
            return aView;
        }
        NSArray *ancestors = self.superViews;
        for (UIView *view in aView.superViews) {
            if ([ancestors containsObject:view]) {
                return view;
            }
        }
        return nil;
    }
    ```

- 一元约束（大小）添加到视图本身，而二元约束（位置）添加到两个视图的最近共同祖先视图

    ```objective-c
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:@"Test" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    NSLog(@"Test %lu", (unsigned long)btn.constraints.count);
    for (MASConstraint *constraint in btn.constraints) {
        NSLog(@"Test %@",constraint);
    }
    NSLog(@"Test %lu", (unsigned long)self.view.constraints.count);
    for (MASConstraint *constraint in self.view.constraints) {
        NSLog(@"Test %@",constraint);
    }
    [btn removeFromSuperview];
    NSLog(@"Test %lu", (unsigned long)btn.constraints.count);
    for (MASConstraint *constraint in btn.constraints) {
        NSLog(@"Test %@",constraint);
    }
    NSLog(@"Test %lu", (unsigned long)self.view.constraints.count);
    for (MASConstraint *constraint in self.view.constraints) {
        NSLog(@"Test %@",constraint);
    }
    
    // 输出：
    2022-12-26 19:17:03.821287+0800 OpenSourcePlayGround[9005:353348] Test 2
    2022-12-26 19:17:03.821527+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dcc60 UIButton:0x7fdcb0e0bae0.width == 100>
    2022-12-26 19:17:03.821653+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dccc0 UIButton:0x7fdcb0e0bae0.height == 100>
    2022-12-26 19:17:03.821734+0800 OpenSourcePlayGround[9005:353348] Test 2
    2022-12-26 19:17:03.821871+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dcae0 UIButton:0x7fdcb0e0bae0.centerX == UIView:0x7fdcb0e0b970.centerX>
    2022-12-26 19:17:03.821983+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dcc00 UIButton:0x7fdcb0e0bae0.centerY == UIView:0x7fdcb0e0b970.centerY>
    2022-12-26 19:17:03.822154+0800 OpenSourcePlayGround[9005:353348] Test 2
    2022-12-26 19:17:03.822258+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dcc60 UIButton:0x7fdcb0e0bae0.width == 100>
    2022-12-26 19:17:03.822353+0800 OpenSourcePlayGround[9005:353348] Test <MASLayoutConstraint:0x6000027dccc0 UIButton:0x7fdcb0e0bae0.height == 100>
    2022-12-26 19:17:03.822429+0800 OpenSourcePlayGround[9005:353348] Test 0
    ```

    可以看到，按钮的宽高约束是添加到视图本身，而位置约束则是添加到父视图上，按钮从父视图移除后，父视图添加的约束会自动移除，而按钮本身的约束不会改变

- 综上，约束安装移除代码如下：

    ```objective-c
    // NSLayoutConstraint分类，可以去看下Masonry源代码
    // 因为firstItem和secondItem是id类型，所以新增了下面的方法，增加可读性
    // 其中UIView可以写成VIEW_CLASS，按如下定义，可以兼容macOS
    #if TARGET_OS_IPHONE
    	#define VIEW_CLASS UIView
    #elif TARGET_OS_MAC
    	#define VIEW_CLASS NSView
    #endif
    // 或者
    #if TARGET_OS_IPHONE
    	@compatibility_alias VIEW_CLASS UIView
    #elif TARGET_OS_MAC
    	@compatibility_alias VIEW_CLASS NSView
    #endif
    
    - (UIView *)firstView {
        return self.firstItem;
    }
    
    - (UIView *)secondView {
        return self.secondItem;
    }
    
    - (BOOL)install {
        // 判断是一元约束，判断布局是大小约束，且第二个约束属性为空
        if (self.isUnary) {
            [self.firstView addConstraint:self];
            return YES;
        }
        UIView *view = [self.firstView nearestCommonAncestorToView:self.secondView];
        if (!view) {
            return NO;
        }
        [view addConstraint:self];
        return YES;
    }
    
    - (void)uninstall {
        if (self.isUnary) {
            UIView *view = self.firstView;
            [view removeConstraint:self];
            return;
        }
        UIView *view = [self.firstView nearestCommonAncestorToView:self.secondView];
        if (!view) {
            return;
        }
        [view removeConstraint:self];
    }
    ```

- 添加和移除约束需要针对某个约束对象（创建时存起来），移除等价约束是无法达到移除效果的

- 约束比较：

    ```objective-c
    // NSLayoutConstraint分类
    - (BOOL)isEqualToLayoutConstraint:(NSLayoutConstraint *)constraint {
        if (self.firstItem != constraint.firstItem)return NO;
        if (self.secondItem != constraint.secondItem)return NO;
        if (self.firstAttribute != constraint.firstAttribute)return NO;
        if (self.secondAttribute != constraint.secondAttribute)return NO;
        if (self.relation != constraint.relation)return NO;
        if (self.multiplier != constraint.multiplier)return NO;
        if (self.constant != constraint.constant)return NO;
        return YES;
    }
    ```

- 查找并删除匹配的约束：

    ```objective-c
    // UIView分类
    // 删除某个匹配的约束
    - (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint {
        NSLayoutConstraint *match = [self constraintMatchingConstraint:aConstraint];
        if (match) {
            [self removeConstraint:match];
            [self.superview removeConstraint:match];
        }
    }
    
    - (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if ([constraint isEqualToLayoutConstraint:aConstraint]) {
                return constraint;
            }
        }
        // 搜索父view
        for (UIView *view in self.superviews) {
            for (NSLayoutConstraint *constraint in view.constraints) {
                if ([constraint isEqualToLayoutConstraint:aConstraint]) {
                    return constraint;
                }
        	}
        }
        return nil;
    }
    
    // 找寻特定view相关的约束
    - (NSArray *)constraintsReferencingView:(UIView *)view {
        NSMutableArray *array = [NSMutableArray array];
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (([constraint.firstItem isEqual:view]) || ([constraint.second isEqual:view])) {
                [array addObject:constraint];
            }
        }
        return array;
    }
    ```

## 第三章 IB布局 略

## 第四章 可视化格式约束

- 所谓的可视化约束，就是由一个描述视图布局的文本组成的字符串，允许一次创建多个约束：

    ```objective-c
    // 创建由view1，view2组成的左对齐的一列，并保持8点间隔
    // 前缀"V:"表示纵坐标，"H:"表示横坐标
    // "[view1]"表示变量名，"|"表示父视图，视图名出现的顺序是从顶到底，从左到右（阿拉伯等地区从右到左），注意要和视图的变量名保持一致，可以直接指定视图尺寸[view1(100)]，或[view1(==100)]，或[view1(>=100,<=200)]，或[view1(view2)]（循环定义也可以），或[view1(view2@200)]（表示view1和view2高度/宽度相等且优先级是200，@表示优先级），不能使用运算符
    // "-8-"表示间隔，没有表示空连接，就是直接贴合，"-"表示标准间隔（视图到视图是8，视图到父视图是20），数值为负数时必须加括号，如"-(-5)-"，-(>=0)-"表示至少为0，可以让视图更灵活调整间隔，"-(>=0,<=100)-"表示间隔在0-100之间，"-(==0@1000)-"表示间隔为0，优先级为1000
    // option指定对齐方式，多种对齐方式用 ｜ 隔开，0表示忽略选项
    // metric表示度量，可以用新增变量myOffset，用"myOffset"替代"8"，然后在该参数传入字典将myOffset赋值为8，如下面代码
    // views表示绑定视图，用于将变量名字符串和它代表的视图绑定起来（这样字符串中就可以使用我们自己的命名），NSDictionaryOfVariableBindings(view1, view2) 相当于@{@"view1":view1, @"view2":view2}，注意！可以多一些没有的绑定，但是不能缺少字符串用到的绑定
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view1]-8-[view2]" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(view1, view2)]];
    
    // metric用法
    NSNumber *myOffset = @(8);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view1]-myOffset-[view2]" options:NSLayoutFormatAlignAllLeading metrics:NSDictionaryOfVariableBindings(myOffset) views:NSDictionaryOfVariableBindings(view1, view2)]];
    // 或者直接
    @{@"myOffset":@(8)}
    ```

- 注意：

    1. 坐标和对齐选项应当正交使用，使用横坐标，对齐选项就只能选择顶部，中部和底部，使用纵坐标，对齐选项就只能使用前端和后端，左边和右边

    2. 可视化格式只能处理简单的名称到实例的转换，无法处理没有显示声明在上下文的项，举例来说，字符串不能使用数组索引，比如view[0]这种，可以这样处理：

        ```objective-c
        NSMutableString *formatString = [NSMutableString string];
        NSMutableDictionary *bingdings = [NSMutableDictionary dictionary];
        int i = 0;
        formatString appendString:@"H:|-"];
        for (UIView *view in views) {
        	NSString *viewName = [NSString stringWithFormat:@"view%d", i++];
        	[formatString appendFormat:@"[%@]%@", viewName, (i < views.count) ? @"-" : @""];
        	bindings[viewName] = view;
        }
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString options:NSLayoutFormatAlignAllLeading metrics:nil views:bindings];
        [self.view addConstraints:constraints];
        ```

- 下面方法可以把视图约束到父视图，保证不会出现视图丢失问题：

    ```objective-c
    // minimuSize传40-100，保证视图能被看到，priority传1，不影响其他约束，又能兜底执行
    void constrainToSuperview:(UIView *view, float minimumSize, NSUInteger priority) {
        if (!view || !view.superview) {
            return;
        }
        for (NSString *format in @[
            @"H:|->=0@priority-[view(==minimumSize@priority)]",
            @"H:[view]->=0@priority-|",
            @"V:|->=0@priority-[view(==minimumSize@priority)]",
            @"V:[view]->=0@priority-|",
        ]) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"priority":@(priority), @"minimumSize":@(minimumSize)} views:@{@"view":view}];
            [view.superview addConstraints:constraints];
        }
    }
    ```

- 可视化格式约束无法实现沿某个坐标轴等间隔分布视图，因为每个约束只能作用于两个视图。可以将父视图等分，依赖父视图对齐；也可以在视图中间添加透明视图。

- 练习：

    ```objective-c
    // 产生1个约束，添加option NSLayoutFormatAlignAllBaseline后为2个
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]-myOffset-[btn1]" options:0 metrics:NSDictionaryOfVariableBindings(myOffset) views:NSDictionaryOfVariableBindings(btn, btn1)];
    // 加不加选项都不产生约束
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    // 三个view顶部和底部对齐，注意需要设置translatesAutoresizingMaskIntoConstraints为NO，不然会有冲突
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[btn(100)]-[btn1(100)]-[view1(100)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:NSDictionaryOfVariableBindings(myOffset) views:NSDictionaryOfVariableBindings(btn, view1, btn1)];
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[btn(100)]" options:0 metrics:NSDictionaryOfVariableBindings(myOffset) views:NSDictionaryOfVariableBindings(btn, view1, btn1)];
    [self.view addConstraints:constraints];
    [self.view addConstraints:constraints1];
    // [btn1(>=20, <=10)]会crash
    ```

## 第五章 调试约束

- 日志出现NSAutoresizingMaskLayoutConstraint，说明自动转换的自动布局和自己写的自动布局发生了冲突，设置translatesAutoresizingMaskIntoConstraints为NO（masonry使用mas_xxx方法时第一句就是设置这个）
- 





