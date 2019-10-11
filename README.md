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

## RxSwift: 使购物车计数有效 - BehaviorRelay

`TTShoppingCart.swift`中看到单例实例上的变量

```
var commodities: [Commodity] = []
```
目前，无法观察到商品数量的变化。可以在其定义中添加`didSet`闭包，但这仅在整个数组更新时才调用，而不是在其任何元素更新时调用。

`RxSwift`有一个解决方案，用此替换创建`commodities`变量的行

```
let commodities: BehaviorRelay<[Commodity]> = BehaviorRelay(value: [])
```

将其定义为`RxSwift BehaviorRelay`，其类型为`Swift`的`Commodity`对象数组。`BehaviorRelay`定义：

- 一个类，因此它使用引用语义。这意味着商品引用了`BehaviorRelay`的一个实例。

- 具有一个属性 `value`，将存储`Commodity`对象数组。

- 作用主要来自于方法`asObservable()`，无需每次手动检查值，都可以添加`Observer`来监听值变化。值更改时，`Observer`通知值发生变化做出相应更新。

- 不足之处， 如需要访问或更改该商品中的某些内容，则必须通过`accept(_:)`完成。

```
func setupCartObserver() {
    // 1.
    TTShoppingCart.shared.commodities.asObservable()
        .subscribe(onNext: { // 2.
            [unowned self] commondites in
            self.cardItem.title = "\(commondites.count)🍫"
        }) // 3.
        .disposed(by: disposeBag)
}
```

以上代码做了什么：

1. 购物车的变量`commodities`作为`Observable`，

2. 在该`Observable`上调用`subscription（onNext :)`，以发现对`Observable`值的更改。`subscription（onNext :)`接受每次值更改时执行的闭包，闭包的传入参数是`Observable`的新值。将一直收到这些通知，直到取消订阅或订阅`dispose`为止。

3. 将上一步中的`Observer`添加到`disposeBag`中，这将在取消分配订阅对象时处理您的订阅。

## RxCocoa：使TableView处于活动状态

`RxCocoa`具有用于几种不同类型UI元素的反应性API，这些使得可以创建表视图而不覆盖委托或数据源方法。

```
let europeanCommodities = Observable.just(Commodity.ofEurope)
```
`just(_:)`表示`Observable`的基础值不会有任何变化，但仍然希望将其作为`Observable`值进行访问。

```
func setupCellConfiguration() {
    // 1.
    europeanCommodities
        .bind(to: listView
            .rx // 2.
            .items(cellIdentifier: TTListViewCell.reuseIdentifier,
                   cellType: TTListViewCell.self)) { // 3.
                    (row, commodity, cell) in
            cell.configure(with: commodity) // 4.
    }
    .disposed(by: disposeBag) // 5.
}
```

1. 调用`bind(to: )`将可观察到的`europeanCommodities`与执行表视图中每一行的代码相关联。

2. 通过调用`rx`，可以访问相关类的`RxCocoa`扩展。在这种情况下，它是一个UITableView。

3. 调用`rx`方法`items(cellIdentifier:cellType:)`，传入单元格标识符和要使用的单元格类型的类。`rx`框架调用出队方法，就像您的表视图具有其原始数据源一样。

4. 为每个`item`传递一个`block`，该`item`的商品和单元格的信息将返回。

5. 将`bind(to:)`返回的`Disposable`添加到`disposeBag`中。
