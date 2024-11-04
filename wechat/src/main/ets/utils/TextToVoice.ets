import { textToSpeech } from '@kit.CoreSpeechKit'
import { util } from '@kit.ArkTS'

export class TextToVoice {
  static ttsEngine: textToSpeech.TextToSpeechEngine
  static voiceInitParamsInfo: textToSpeech.CreateEngineParams = {
    language: 'zh-CN',
    person: 0,
    online: 1,
    extraParams: {}
  }
  static speakParams: textToSpeech.SpeakParams = {
    requestId: util.generateRandomUUID(),
    extraParams: {
      "speed": 1,
      "volume": 1,
      "pitch": 1,
      "languageContext": 'zh-CN',
      "audioType": "pcm"
    }
  }

  static async start(text: string) {
    if (!TextToVoice.ttsEngine) {
      TextToVoice.ttsEngine = await textToSpeech.createEngine(TextToVoice.voiceInitParamsInfo)
    }
    TextToVoice.ttsEngine.speak(text, TextToVoice.speakParams)
  }
}