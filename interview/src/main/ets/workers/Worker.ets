import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { request } from '@kit.BasicServicesKit';
import { logger } from '../common/utils/Logger';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (e: MessageEvents) => {
  // e.data就是你发的对象
  const messageInfo = e.data as MessageInfo
  if (messageInfo.action === 'start') {
    //   执行下载
    downloadFile(messageInfo.context)
  }else if(messageInfo.action ==='test'){
    logger.info('getMessage')
  }
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}

//TODO:下载编辑器
async function downloadFile(context: Context) {
  // bk1
  const task = await request.downloadFile(context, {
    url: 'https://contentcenter-vali-drcn.dbankcdn.cn/pvt_2/DeveloperAlliance_package_901_9/30/v3/kujb9DBbSyu85BhRl-dfaA/devecostudio-windows-5.0.3.810.zip?HW-CC-KV=V1&HW-CC-Date=20240924T112338Z&HW-CC-Expire=7200&HW-CC-Sign=DE48964E78DECC47527C5BA8E0CE1FADEF49B800B3F03E2E1BCBE340A93D811D',
    filePath: context.filesDir + '/test.zip'
  })
  // bk2
  task.on('progress', (current, total) => {
    const progress = (current / total * 100).toFixed(2) + '%'
    //4.通知页面（发消息）
    workerPort.postMessage({
      progress
    })
    if (current === total) {
      //   关闭worker
      workerPort.close()
    }
  })
}

export interface MessageInfo {
  action: string
  context: Context
}