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

`RxCocoa`向`UITableView`添加了另一种扩展方法，称为`modelSelected(_:)`，这将返回一个`Observable`，可以用来订阅有关选定模型对象的信息。

```
func setupCellTapHandling() {
    listView
        .rx
        .modelSelected(Commodity.self) // 1.
        .subscribe(onNext: { [unowned self] (commodity) in // 2.
            let newValue = TTShoppingCart.shared.commodities.value + [commodity]
            TTShoppingCart.shared.commodities.accept(newValue) // 3.
            
            if let selectedRowIndexpath = self.listView.indexPathForSelectedRow {
                self.listView.deselectRow(at: selectedRowIndexpath, animated: true)
            } // 4.
        })
        .disposed(by: disposeBag) // 5.
}
```

1. 调用表格视图的反应性扩展的`modelSelected(_:)`，传入`commodity`模型类型，以获取正确的项目类型，返回一个`Observable`。

2. 将该`Observable`视为可观察对象，请调用`subscription(onNext:)`，并在每次选择模型（例如，点击一个单元格）时关闭应该执行的操作。

3. 在传递给`subscription(onNext:)`的闭包中，将选定的商品添加到购物车中。

4. 同样在闭包中，取消选择点击的行。

5. 将`subscription(onNext:)`返回一个`Disposable`添加到`disposeBag`。

## RxSwift和直接文本输入

用户可以根据已知的信用卡类型查看他们要输入的信用卡类型：

```
func setupCardImageDisplay() {
    cardType
        .asObservable() // 1.
        .subscribe(onNext: { [unowned self] (cardType) in // 2.
            self.creditCardImageView.image = cardType.image
        })
        .disposed(by: disposeBag) // 3.
}
```

>1. 将`cardType`对象作为一个`Observable`。

> 2. 订阅该`Observable`以监听对`cardType`的更改。

> 3. 确保将观察者丢弃到`disposeBag`中。

由于用户可能会快速键入内容，因此每次按键运行验证的计算量可能很大，并且会导致UI滞后。为了解决这一问题，可以抑制用户输入在验证过程中移动的速度，这意味着将仅在限制时间间隔内验证输入，而不是在每次更改时验证输入。这样，快速打字不会使整个应用程序停顿下来。

节流是`RxSwift`的专长，因为当事情发生变化时，通常会运行大量逻辑。

`
private let throttleIntervalInMilliseconds = 100
`

```
func setupTextChangeHandling() {
    let creditCardValid = creditCardNumberTextField
        .rx
        .text // 1.
        .observeOn(MainScheduler.asyncInstance)
        .distinctUntilChanged()
        .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance) // 2.
        .map { [unowned self] in
        self.validate(cardText: $0) // 3.
    }
    
    creditCardValid
        .subscribe(onNext: { [unowned self] in
            self.creditCardNumberTextField.valid = $0 // 4.
        })
        .disposed(by: disposeBag) // 5.
}
```

>1. 返回文本字段的内容作为`Observable`值。 `text`是另一个`RxCocoa`扩展，这次是`UITextField`。

>2. 限制输入以设置验证以根据上面定义的时间间隔运行。 `Scheduler`参数是一个更高级的概念，但简短的版本是它与线程绑定。要将所有内容保留在主线程上，请使用`MainScheduler`。

>3. 通过将受限制的输入应用于类提供的`validate(cardText:)`来对其进行转换。如果卡输入有效，则监听到的布尔值的最终值为`true`。

>4. 订阅创建的`Observable`值，然后根据输入的值更新文本字段的有效性。

>5. 将生成的`Disposable`添加到`disposeBag`中。

```
let everythingValid = Observable
    .combineLatest(creditCardValid, expirationDateValid, cvvValid) {
        $0 && $1 && $2
}

everythingValid
    .bind(to: purchaseButton.rx.isEnabled)
    .disposed(by: disposeBag)
```
这使用`Observable`的`CombineLatest(_:)`来获取已经创建的三个`Observable`，并生成第四个。生成的`Observable（称为everythingValid）`为true或false，具体取决于所有三个输入是否有效。
`everythingValid`反映了`UIButton`的反应式扩展程序中的`isEnabled`属性， `everythingValid`的值控制着购买按钮的状态。
