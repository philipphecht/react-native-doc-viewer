
import { NativeModules } from 'react-native';
const { RNReactNativeDocViewer } = NativeModules;

export default {
  open: NativeModules.RNReactNativeDocViewer.open
}