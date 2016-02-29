# CALayerAndCAShapeLayer

###1.中间的图片使用CALayer.contents实现，图片周围的阴影使用另一个CALayer叠加实现

###2.在CALayer的delegate方法中使用了CGContextScaleCTM和CGContextTranslateCTM对图像上下文进行了垂直翻转和移动。

###3.使用CAShapeLayer和UIBezierPath实现了一个loading动画
