declare module 'react-native-larapush' {
    export default class LaraPush {
      static initialize(panelUrl: string, applicationId: string, debug?: boolean): Promise<boolean>;
      static setTags(...tags: string[]): Promise<boolean>;
      static getTags(): Promise<string[]>;
      static clearTags(): Promise<boolean>;
      static getToken(): Promise<string>;
    }
  }