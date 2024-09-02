<template>
  <div class="content">
    <echarts
      ref="echarts"
      theme="dark"
      :options="options"
      :autoresize="true"
    />
  </div>
</template>

<script>
// eslint-disable-next-line no-unused-vars
import * as echarts from 'echarts'

export default {
  components: {},
  props: {
    datesMetrics: {
      type: Array,
      default: () => []
    },
    primaryName: {
      type: String,
      default: ''
    },
    primaryData: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {}
  },
  computed: {
    mixColors() {
      const documentStyle = document.documentElement.style
      const primary = documentStyle.getPropertyValue('--color-primary')
      return {
        primary
      }
    },
    options() {
      const { primary } = this.mixColors
      return {
        backgroundColor: 'rgba(0,0,0,0)',
        grid: {
          left: '2%',
          top: '3%',
          right: '2%',
          bottom: '1%',
          containLabel: true
        },
        tooltip: {
          show: true
        },
        xAxis: [{
          type: 'category',
          name: '',
          nameLocation: 'center',
          nameGap: 35,
          nameTextStyle: {
            color: '#aebcd3',
            fontSize: '16'
          },
          axisLabel: {
            textStyle: {
              color: '#aebcd3',
              fontSize: '14'
            }
          },
          data: this.datesMetrics,
          axisLine: {
            lineStyle: {
              width: 2,
              color: '#cdd1d5'
            }
          },
          axisTick: {
            show: false
          }
        }],
        yAxis: [{
          type: 'value',
          name: '',
          nameLocation: 'middle',
          nameGap: 45,
          nameTextStyle: {
            color: '#aebcd3',
            fontSize: '16'
          },
          axisLabel: {
            textStyle: {
              color: '#aebcd3',
              fontSize: '14'
            }
          },
          axisTick: {
            show: false
          },
          axisLine: {
            show: false
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(160,160,160,0.3)'
            }
          }
        }],
        series: [{
          type: 'bar',
          name: this.primaryName,
          stack: 1,
          barWidth: '20%',
          borderWidth: 0,
          itemStyle: {
            normal: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(31,126,107,0.6)'
              }, {
                offset: 0.6,
                color: 'rgba(31,126,107, 0.2)'
              },
              {
                offset: 1,
                color: 'rgba(31,126,107,0.1)'
              }
              ], false),
              shadowColor: 'rgba(31,126,107, 0.1)',
              shadowBlur: 6
            }
          },
          label: {
            normal: {
              show: false
            }
          },
          data: this.primaryData
        },
        {
          type: 'pictorialBar',
          name: this.primaryName,
          symbol: 'rect',
          symbolSize: ['25%', 6],
          symbolOffset: [0, -6],
          z: 12,
          itemStyle: {
            normal: {
              color: primary
            }
          },
          label: {
            show: false,
            position: 'top',
            fontSize: 16
          },
          symbolPosition: 'end',
          data: this.primaryData
        }
        ]
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.echarts {
  width: 100%;
  height: 272px;
}
</style>
