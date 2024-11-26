// 封装任务 - 1.声明一个函数@concurrent
import { taskpool } from '@kit.ArkTS'
import { emitter } from '@kit.BasicServicesKit'

@Concurrent
async function getData(params1: string) {
  // 模拟请求等待3秒
  await new Promise<boolean>((resolve) => {
    setTimeout(() => {
      resolve(true)
    }, 3000)
  })
  // 2次元世界：通知页面
  // 不同线程不能用线程内通信
  // getContext().eventHub.emit('taskpool')
  emitter.emit('taskpool')
  return params1 + ':' + Math.random().toFixed(2)
}

@Entry
@Component
struct TaskPoolCasePage {
  // ---------------1.添加Task函数---------------
  @State
  addTaskResult: string = ''

  // 添加Task函数（自动分配）
  async addTask() {
    // 2.将函数添加到taskpool队列
    const result = await taskpool.execute(getData, 'addTask')
    this.addTaskResult = result.toString()
  }

  // ---------------2.创建Task任务----------------
  @State
  createTaskResult: string = ''

  // 创建Task任务（自主分配）
  async createTask() {
    // 2.创建任务，将任务加到taskpool队列
    // 将函数转化为任务 === 将函数添加队列的  语法！！！
    const task = new taskpool.Task(getData, 'createTask')

    const result = await taskpool.execute(task, taskpool.Priority.IDLE)

    this.createTaskResult = result.toString()
  }

  // ---------------3.创建Task任务组--------------
  @State
  taskResultGroup: string[] = []

  async creatTaskGroup() {
    // 3.创建任务组，添加任务，将任务组加到taskpool队列
    const group = new taskpool.TaskGroup()
    group.addTask(getData, 'createTskGroup4')
    group.addTask(getData, 'createTskGroup1')
    group.addTask(getData, 'createTskGroup2')
    group.addTask(getData, 'createTskGroup3')
    // 设置优先级是给组设置的
    const result = await taskpool.execute(group)
    this.taskResultGroup = result.map(item => item.toString())
  }

  // ---------------4.检测执行权重--------------
  // 存放执行结果的数组
  @State
  priorityResultList: string[] = []
  taskArray: taskpool.Task[] = []

  // 发起100个不同权重的task任务
  checkPriority() {
    const taskArray: taskpool.Task[] = []
    // 创建100个任务
    for (let i = 0; i < 100; i++) {
      const task = new taskpool.Task(getData, 'priority' + i)
      taskArray.push(task)
    }
    this.taskArray = taskArray
    // 以不同优先级加入队列
    for (let i = 0; i < taskArray.length; i += 4) {
      taskpool.execute(taskArray[i], taskpool.Priority.HIGH)
        .then(res => {
          this.priorityResultList.push(res.toString())
        })
      taskpool.execute(taskArray[i+1], taskpool.Priority.MEDIUM)
        .then(res => {
          this.priorityResultList.push(res.toString())
        })
      taskpool.execute(taskArray[i+2], taskpool.Priority.LOW)
        .then(res => {
          this.priorityResultList.push(res.toString())
        })
      taskpool.execute(taskArray[i+3], taskpool.Priority.IDLE)
        .then(res => {
          this.priorityResultList.push(res.toString())
        })
    }
  }

  @State
  emitNum: number = 0

  aboutToAppear(): void {
    // 线程内通信：当前在主线程
    // getContext().eventHub.on('taskpool', () => {
    //   this.emitNum++
    // })
    // taskpool是二次元（另一个线程，和主线程没关系了）
    emitter.on('taskpool', () => {
      this.emitNum++
    })
  }

  build() {
    Column({ space: 12 }) {
      Text('当前被通知次数：' + this.emitNum)
      Text('添加Task函数的结果:' + this.addTaskResult)
      Button('添加Task函数')
        .onClick(async () => {
          // this.addTaskResult = await this.getData()
          this.addTask()
        })
      Text('创建Task任务的结果:' + this.createTaskResult)
      Button('创建Task任务')
        .onClick(() => {
          this.createTask()
        })
      Text('创建Task任务组的结果:')
      Column() {
        ForEach(this.taskResultGroup, (item: string) => {
          Text(item)
        })
      }

      Button('创建Task任务组')
        .onClick(() => {
          this.creatTaskGroup()
        })
      Text('Task任务Priority结果：' + this.priorityResultList.length)
      List() {
        ForEach(this.priorityResultList, (item: string) => {
          ListItem() {
            Text(item)
          }
        })
      }.layoutWeight(1)

      Button('检测Priority')
        .onClick(() => {
          this.checkPriority()
        })
      Button('取消执行队列15')
        .onClick(() => {
          taskpool.cancel(this.taskArray[15])
        })
    }
    .height('100%')
    .width('100%')
    .padding(40)
  }
}