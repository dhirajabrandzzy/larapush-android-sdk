import { NativeModules } from 'react-native';

const { LaraPushModule } = NativeModules;

export default class LaraPush {
  static initialize(panelUrl, applicationId, debug = false) {
    return LaraPushModule.initialize(panelUrl, applicationId, debug);
  }

  static setTags(...tags) {
    return LaraPushModule.setTags(tags);
  }

  static getTags() {
    return LaraPushModule.getTags();
  }

  static clearTags() {
    return LaraPushModule.clearTags();
  }

  static getToken() {
    return LaraPushModule.getToken();
  }
}