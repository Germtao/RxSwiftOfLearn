# RxSwift入门

## Observables 和 Observers

- `Observables`(可观察者): 发出更改通知

- `Observers`(观察者): 订阅一个可观察对象，并在该可观察对象发生变化时获取通知

可以有`多个Observers`监听`一个Observables`，当`Observables`发生更改时，它将通知其所有`Observers`。


## DisposeBag

`DisposeBag`是`RxSwift`提供的附加工具，可帮助处理`ARC`和`内存管理`。取消分配父对象会导致`DisposeBag`中`Observer`对象的处置。

在持有`DisposeBag`的对象上调用`deinit()`时，每个可弃用的`Observer`自动从其观察中退订。这使`ARC`可以像往常一样收回内存。

没有`DisposeBag`将造成两个结果之一：

- `Observer`将创建一个保留周期，然后无限期的观察。

- `Observer`可能会被释放，从而导致崩溃。

要想很好的利用`ARC`管理，请记住在设置对象时将所有`Observable`添加到`DisposeBag`中，`DisposeBag`将很好地为您清理。
