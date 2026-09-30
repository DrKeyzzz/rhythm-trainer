// Ring-buffer delay line. Records every incoming sample and plays it back
// `delay` seconds later. Changing the delay crossfades between the old and new
// read positions so jumps don't click.
class RadioDelayProcessor extends AudioWorkletProcessor {
  constructor(options) {
    super();
    const maxSeconds = options.processorOptions.maxSeconds;
    this.size = Math.ceil(maxSeconds * sampleRate) + 256;
    // Mono 16-bit keeps 10 minutes at 48 kHz under 60 MB, and is plenty for play-by-play.
    this.buf = new Int16Array(this.size);
    this.w = 0;
    this.written = 0;
    this.delay = 0;
    this.oldDelay = 0;
    this.fadeLen = Math.round(sampleRate * 0.04);
    this.fade = 0;
    this.sinceReport = 0;
    this.port.onmessage = (e) => {
      if (typeof e.data.delay === 'number') {
        const d = Math.max(0, Math.min(this.size - 256, Math.round(e.data.delay * sampleRate)));
        if (d === this.delay) return;
        this.oldDelay = this.delay;
        this.delay = d;
        this.fade = this.fadeLen;
      }
      if (e.data.reset) {
        this.buf.fill(0);
        this.written = 0;
      }
    };
  }

  read(d) {
    if (d > this.written) return 0; // not recorded that far back yet
    let i = this.w - d;
    if (i < 0) i += this.size;
    return this.buf[i] / 32767;
  }

  process(inputs, outputs) {
    const input = inputs[0];
    const output = outputs[0];
    const n = output[0].length;
    const chans = input.length;
    for (let s = 0; s < n; s++) {
      let v = 0;
      for (let c = 0; c < chans; c++) v += input[c][s];
      const m = chans ? v / chans : 0;
      this.buf[this.w] = Math.max(-1, Math.min(1, m)) * 32767;
      this.written++;

      let out;
      if (this.fade > 0) {
        const g = this.fade / this.fadeLen;
        out = this.read(this.oldDelay) * g + this.read(this.delay) * (1 - g);
        this.fade--;
      } else {
        out = this.read(this.delay);
      }
      for (let c = 0; c < output.length; c++) output[c][s] = out;

      this.w++;
      if (this.w === this.size) this.w = 0;
    }

    this.sinceReport += n;
    if (this.sinceReport >= sampleRate / 4) {
      this.sinceReport = 0;
      this.port.postMessage({ buffered: Math.min(this.written, this.size - 256) / sampleRate });
    }
    return true;
  }
}

registerProcessor('radio-delay', RadioDelayProcessor);
