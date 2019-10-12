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

