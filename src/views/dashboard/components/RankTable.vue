<template>
  <div class="box">
    <div class="head">
      <Title :config="config" />
      <SwitchDate @change="onChange" />
    </div>
    <el-table
      :data="tableData"
      class="table"
      style="width: 100%"
    >
      <el-table-column :label="$tc('Ranking')" width="80px">
        <template v-slot="scope">
          <span>{{ scope.$index + 1 }}</span>
        </template>
      </el-table-column>
      <el-table-column
        v-for="i in config.columns"
        :key="i.prop"
        :label="i.label"
        :prop="i.prop"
        :width="i.width"
      />
    </el-table>
  </div>
</template>

<script>
import Title from './Title.vue'
import SwitchDate from './SwitchDate.vue'

export default {
  components: {
    Title,
    SwitchDate
  },
  props: {
    config: {
      type: Object,
      default: () => {
      }
    },
    url: {
      type: String,
      default: ''
    }
  },
  data() {
    const days = localStorage.getItem('dashboardDays') || '7'
    return {
      tableData: [],
      tableUrl: this.config.url + `&days=${days}`
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.$axios.get(this.tableUrl).then(res => {
        this.tableData = this.config.data ? res?.[this.config.data] : res
      })
    },
    onChange(val) {
      this.tableUrl = this.config.url + `&days=${val}`
      this.getList()
      localStorage.setItem('dashboardDays', val)
    }
  }
}
</script>

<style lang="scss" scoped>
.box {
  margin-top: 16px;
  padding: 20px;
  background: #242525;

  .head {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
  }
}

::v-deep .el-table td, .el-table th {
  padding: 5px 0;
}

::v-deep .el-table th, .el-table tr {
  background-color: #242525 !important;

}

::v-deep .el-table .cell {
  white-space: nowrap;
}
</style>
