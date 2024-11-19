export enum BreakPointEnum {
  xs = "xs",
  sm = "sm",
  md = "md",
  lg = "lg"
}

// 声明一个interface  对应每个断点的值
interface BreakPointValue<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
}

// 断点工具
export class BreakPointType<T> {
  options: BreakPointValue<T>

  constructor(opt: BreakPointValue<T>) {
    this.options = opt // 把四个断点对应的值给了这个对象
  }

  // 提供一个获取断点值
  getValue(breakPoint: string): T {
    //this.options[breakPoint]
    return (this.options as object)[breakPoint] // 偷懒的方式
    // if (breakPoint === "xs") {
    //   return this.options.xs!
    // } else if (breakPoint === "sm") {
    //   return this.options.sm!
    // } else if (breakPoint === "md") {
    //   return this.options.md!
    // } else {
    //   return this.options.lg!
    // }
  }
}