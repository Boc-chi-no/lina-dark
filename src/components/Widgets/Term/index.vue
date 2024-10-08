<template>
  <div style="position: relative;">
    <div v-if="showToolBar" class="actions">
      <div
        v-for="(item,index) in toolbar"
        :key="index"
        style="display: inline-block"
      >
        <el-tooltip :content="item.tip" :open-delay="500">
          <el-button
            v-if="!item.isScrollButton || showScrollButton"
            size="mini"
            type="default"
            @click="item.callback()"
          >
            <svg-icon :icon-class="item.icon" />
          </el-button>
        </el-tooltip>
      </div>
    </div>
    <div id="terminal" ref="terminal" class="xterm" />
  </div>
</template>

<script>
import 'xterm/css/xterm.css'
import { Terminal } from 'xterm'
import { FitAddon } from 'xterm-addon-fit'
import { downloadText } from '@/utils/common'

export default {
  name: 'Term',
  props: {
    showToolBar: {
      type: [Boolean, Object],
      default: () => {
        return false
      }
    },
    xtermConfig: {
      type: Object,
      default: () => {
      }
    }
  },
  data() {
    return {
      xterm: new Terminal(Object.assign({
        fontFamily: 'monaco, Consolas, "Lucida Console", monospace',
        lineHeight: 1.2,
        fontSize: 13,
        rightClickSelectsWord: true,
        theme: {
          background: '#000',
          foreground: '#fff',
          selection: '#cbd1da'
        }
      }, this.xtermConfig)),
      toolbar: [
        {
          tip: this.$tc('ScrollToTop'),
          icon: 'arrow-up',
          callback: () => {
            this.xterm.scrollToTop()
          },
          isScrollButton: true
        },
        {
          tip: this.$tc('ScrollToBottom'),
          icon: 'arrow-down',
          callback: () => {
            this.xterm.scrollToBottom()
          },
          isScrollButton: true
        },
        {
          tip: this.$tc('ClearScreen'),
          icon: 'refresh',
          callback: () => {
            this.xterm.reset()
          }
        },
        {
          tip: this.$tc('Export'),
          icon: 'download',
          callback: () => {
            this.xterm.selectAll()
            const text = this.xterm.getSelection()
            const filename = `${this.xtermConfig?.type}_${this.xtermConfig?.taskId}.log`
            downloadText(text, filename)
          }
        }
      ],
      showScrollButton: false
    }
  },
  mounted: function() {
    const terminalContainer = this.$refs.terminal
    const fitAddon = new FitAddon()
    this.xterm.loadAddon(fitAddon)
    this.xterm.open(terminalContainer)
    fitAddon.fit()
    this.xterm.scrollToBottom()
    this.xterm.onScroll(this.checkScroll)
  },
  beforeDestroy() {
    this.xterm.dispose()
  },
  methods: {
    reset: function() {
      this.xterm.reset()
    },
    write: function(val) {
      this.xterm.write(val)
    },
    checkScroll(position) {
      this.showScrollButton = position > 0
    }
  }
}

</script>

<style scoped>
.xterm {
  overflow: auto;
  padding-left: 5px;
  background-color: #242525;
}

.actions {
  text-align: right;
  background-color: #242525;
  padding-right: 5px;
  padding-top: 2px
}

.el-button {
  border: none;
  padding: 2px;
  font-size: 14px;
  width: 26px;
  height: 26px;
  color: #c8cacc;
  background-color: transparent;
  margin-left: 2px;
}
</style>
