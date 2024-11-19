export class ListDataSource<T> implements IDataSource {
  private originArr: T[] = []
  private listeners: DataChangeListener[] = []

  totalCount(): number {
    return this.originArr.length
  }

  getData(index: number): T {
    return this.originArr[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    let index = this.listeners.indexOf(listener)
    if (index > -1) {
      this.listeners.splice(index, 1)
    }
  }

  // 加载数据的方法
  loadData(data: T[]) {
    this.originArr = data
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  // 添加了一个添加数组的方法
  addArr(data: T[]) {
    let index = this.totalCount() // 先得到总数
    this.originArr.push(...data) // 从0 开始 加的  10条
    this.listeners.forEach(listener => {
      listener.onDataAdd(index) // 组件需要知道从哪里开始加的
      // listener.onDataReloaded()
    })
  }
}

