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
