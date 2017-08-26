# RecognizeSimultaneously
## 该Demo实现了类似于微博客户端发现频道的效果
### 描述
- 框架为一个tableView，该TableView只有一个Cell，Cell上一个scrollView用于展示添加子分类tableView列表，可左右滑动切换分类；
- 此种两个tableView之间的嵌套滑动控制主要是实现UIGestureRecognizerDelegate中的方法：
>
```
optional public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
```
> 对于这个方法SDK中的解释是：
```
called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
```
> 如果这个代理方法返回YES的话就允许所有的gestureRecognizer识别响应手势，你也可以通过otherGestureRecognizer.view的类型来限制返回值，从而更加具体的限制到只有哪些类型需要实现嵌套滑动。
