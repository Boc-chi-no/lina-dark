<template>
  <div>
    <echarts
      ref="echarts"
      theme="dark"
      :autoresize="true"
      :options="options"
    />
  </div>
</template>

<script>
import 'echarts/lib/chart/line'
import 'echarts/lib/component/legend'

import Decimal from 'decimal.js'

export default {
  props: {
    config: {
      type: Object,
      default: () => {}
    }
  },
  computed: {
    options() {
      const { total = 0, active = 0, title, color } = this.config
      const activeDecimal = new Decimal(active)
      const totalDecimal = new Decimal(total)

      let percentage = activeDecimal.dividedBy(totalDecimal).times(100)
      percentage = isNaN(percentage) ? 0 : percentage
      percentage = percentage.toFixed(2)
      return {
        backgroundColor: 'rgba(0,0,0,0)',
        title: [
          {
            text: this.config.chartTitle,
            textStyle: {
              color: '#dbdfe5',
              fontSize: 12
            },
            textAlign: 'center',
            left: '48%',
            top: '32%'
          },
          {
            left: '48%',
            top: '42%',
            textAlign: 'center',
            text: active,
            textStyle: {
              fontSize: 24,
              color: '#ffffff'
            },
            subtext: this.$t('Proportion') + ' ' + percentage + '%',
            subtextStyle: {
              fontSize: 12,
              color: '#dbe1e8'
            }
          }
        ],
        legend: {
          show: false
        },
        color: [color, 'rgba(185,225,208,0.05)'],
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {d}%'
        },
        series: [
          {
            name: title,
            type: 'pie',
            radius: ['72%', '90%'],
            avoidLabelOverlap: false,
            itemStyle: {
              normal: {
                label: {
                  show: false
                },
                labelLine: {
                  show: false
                }

              }
            },
            emphasis: {
              label: {
                show: false
              }
            },
            labelLine: {
              show: false
            },
            startAngle: 180,
            data: this.config.data
          }
        ]
      }
    }
  }
}
</script>
