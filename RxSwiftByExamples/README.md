# RxSwift 基础

## Observable（可观察的） 和 Observer（观察者）

### 定义

比如智能手机是`Observable（可观察到的）`，它发出如qq通知、消息、Snapchat通知之类的信号。你自然会去订阅它在主屏幕中收到所有通知，可以决定如何处理这些信号，你是`Observer（观察者）`。

## Observable（可观察的） and the Bind（绑定）

在开始之前，我们需要与一些定义取得联系。我们了解了可观察对象和观察者，今天我们将了解其他类型：

- `Subject`：既是`Observable`可观察对象，又是`Observer`观察者。

- `BehaviorSubject`：订阅后，获取`Subject`发出的最新值，然后是订阅后发出的值。

- `PublishSubject`：订阅后，只获得订阅后发出的值。

- `ReplaySubject`：订阅后，获得订阅后发出的值，以及订阅前发出的值。将获得多少个旧值？这取决于订阅的`ReplaySubject`的缓冲区大小。可以在Subject的init中指定它。

- `Variable`：变量，对`BehaviorSubject`的包装。变量在释放后会自动发送`.onCompleted()`事件。

> 创建一个简单的应用，该应用将球的颜色与视图中的位置相关联，还将视图的背景颜色与球的颜色相关联。

```
var centerVariable: BehaviorRelay<CGPoint?> = BehaviorRelay(value: .zero)
var backgroundColorObservale: Observable<UIColor>!
```
> 将`CGPoint`的每个新值映射到`UIColor`。获得了`Observable`产生的新值，然后基于（不是那么）非常复杂的数学计算创建了`新的UIColor`。

```
backgroundColorObservale =
    centerVariable.asObservable().map { center in
        guard let center = center else { return UIColor.systemBackground }
        
        let red: CGFloat = max(center.x, center.y).truncatingRemainder(dividingBy: 255.0) / 255.0
        let green: CGFloat = 0.0
        let blue: CGFloat = 0.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}
```

> 订阅`backgroundObservable`从`ViewModel`获取新颜色。

```
circleViewModel.backgroundColorObservale
    .subscribe(onNext: { [unowned self] backgroundColor in
        UIView.animate(withDuration: 0.1) {
            self.circleView.backgroundColor = backgroundColor
            let viewBgColor = backgroundColor.withAlphaComponent(0.2)
            self.view.backgroundColor = viewBgColor
        }
    })
    .disposed(by: disposeBag)
```

> 将`CircleView`的中心点绑定到中心对象

```
circleView
    .rx
    .observe(CGPoint.self, "center")
    .bind(to: circleViewModel.centerVariable)
    .disposed(by: disposeBag)
```

## Networking（网络）

### Moya

`Moya`是通常需要自己控制的所有网络工作之上的抽象层。基本上通过使用此库，将立即与API建立连接，并通过包含`RxSwift`和`ModelMapper`的扩展来建立我们的完整请求服务。

### Setup

需要一个`Provider`，其中包括存根，端点关闭等设置来设置`Moya`（将在进行测试时提供更多信息）。

1.  对于我们的简单情况，我们实际上根本不需要任何东西，因此，这只是使用`RxSwift`初始化`Provider`。

2. 然后，我们需要做的第二件事是终点配置 – 具有我们可能的终点目标的枚举。

我们只需要创建符合`TargetType`的枚举就可以了，这是一个具有`url`、`方法`、`任务（是请求/上传/下载）`，`参数`和`parameterEncoding`（因此是URL请求的基本内容）的协议，需要指定的最后一个参数是`sampleData`。

### Example


