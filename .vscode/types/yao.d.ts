// 不要直接使用export * from 的语法。
import {
  Process,
  Exception,
  $L,
  FS,
  http,
  log,
  Query,
  Store,
  Studio,
  WebSocket,
  ssWrite
} from '@yaoapps/client';

export * from './neo';
export * from './io';

export function Require(script: string) {}

export {
  Process,
  Exception,
  $L,
  FS,
  http,
  log,
  Query,
  Store,
  Studio,
  WebSocket,
  ssWrite
};

export class Job {
  /**
   *
   * 作业会使用golang 的协程进行调用执行
   *
   * 参数1是处理器的名称，剩余的是处理器的参数。
   *
   * @param processor 处理器的名称
   * @param args 处理器的参数
   */
  constructor(processor: string, ...args: any[]) {
    throw new Exception(`Job Not support debug`);
  }
  /**
   * 状态检查回调函数
   *
   * 当作业在执行过程中会不断的检查作业状态，如果作业还没完成，就会不断的调用回调函数。
   *
   * 作业的状态回调方法Pending,方法的参数1必须是函数
   *
   * 可以在回调函数中使用 return false 打断状态检查。
   * @param f
   */
  Pending(f: () => void) {
    throw new Exception(`Job Not support debug`);
  }
  /**
   * 读取作业完成后的数据
   */
  Data() {
    throw new Exception(`Job Not support debug`);
  }
  /**
   * 取消作业
   */
  Cancle() {
    throw new Exception(`Job Not support debug`);
  }
}

export const time = {
  After(ms: number, process: string, ...args: any[]) {
    this.Sleep(ms);
    Process(process, ...args);
  },
  Sleep(delay: number) {
    const start = new Date().getTime();
    while (new Date().getTime() - start < delay) {
      continue;
    }
  }
};
