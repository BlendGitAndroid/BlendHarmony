import { relationalStore, ValuesBucket } from '@kit.ArkData'

// 隐私笔记的类型
// ValuesBucket 数据库类型约束
export interface PrivacyNoteDBInfo extends ValuesBucket {
  id: number | null // 新增时 id 设置为 null ，可实现 id 自增
  title: string
  content: string
  date_added: number
}

// 隐私笔记数据库封装
class PrivacyNoteDB {
  // public        公开的(外部可访问)
  // private       私有的(外部不可访问)
  // constructor() 构造器(new 时候自动运行)

  // 操作数据库的实例(数据库文件)
  private store: relationalStore.RdbStore | null = null
  // 数据库表名
  private tableName = 'privacy_note'
  // 创建数据库的语句
  private sqlCreate = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date_added INTEGER NOT NULL
      )`

  // 获取数据库操作的实例(创建/打开数据库文件)
  private async getStoreInstance() {
    // 如果 store 已保存，直接返回即可（性能优化）
    if (this.store) {
      return this.store
    }
    // 创建/打开数据库文件
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'guardian.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 安全等级(跨设备共享等级)
    })
    // return 操作数据库的实例
    return this.store
  }

  // 类的构造器，new 的时候会自动触发
  constructor() {
    // 创建/打开数据库文件
    this.getStoreInstance()
      .then(store => {
        // 执行 sql 语句，用于创建数据库的表
        store.executeSql(this.sqlCreate)
      })
  }

  // 新增数据
  async insert(value: PrivacyNoteDBInfo) {
    // 创建/打开数据库文件
    const store = await this.getStoreInstance()
    // 新增数据(表名, 数据)
    return store.insert(this.tableName, value)
  }

  // 查询数据
  async query(id?: number) {
    // 创建/打开数据库文件
    const store = await this.getStoreInstance()
    // 谓词(条件)
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    if (id) {
      predicates.equalTo('id', id) // 如果有 id，就根据 id 查找即可
    } else {
      predicates.orderByDesc('id') // 倒序：由大到小
    }
    // 根据谓词排序
    const resultSet = await store.query(predicates)
    // 准备对象数组
    const list: PrivacyNoteDBInfo[] = []
    // 指针移动到下一行
    while (resultSet.goToNextRow()) {
      // 按列提取数据
      // const item: PrivacyNoteDBInfo = {
      //   id: resultSet.getLong(0),
      //   title: resultSet.getString(1),
      //   content: resultSet.getString(2),
      //   date_added: resultSet.getLong(3),
      // }
      // API 11 新增：获取当前行的数据，代码化简
      const item = resultSet.getRow() as PrivacyNoteDBInfo
      // 数据追加
      list.push(item)
    }
    // 释放结果集，释放资源（性能优化）
    resultSet.close()
    // 循环结束后，返回数组
    return list
  }

  // 删除
  async delete(id: number) {
    // 创建/打开数据库文件
    const store = await this.getStoreInstance()
    // 谓词条件
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    // 匹配 id 用于删除
    predicates.equalTo('id', id)
    // 删除
    return store.delete(predicates)
  }

  // 修改
  async update(value: PrivacyNoteDBInfo) {
    if (!value.id) {
      return Promise.reject()
    }
    // 创建/打开数据库文件
    const store = await this.getStoreInstance()
    // 谓词条件
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    // 匹配 id 用于更新
    predicates.equalTo('id', value.id)
    // 更新
    return store.update(value, predicates)
  }

}

// 通过小写 p 开头的类实例操作数据库，创建数据库，建表，增、删、查、改
export const privacyNoteDB = new PrivacyNoteDB()