<template>
  <el-popover
    :title="title"
    placement="left-start"
    trigger="click"
    @show="getAsyncItems"
  >
    <div class="detail-content">
      <div v-if="accountData.length === 0" class="empty-item">
        <span>{{ $t('No accounts') }}</span>
      </div>
      <div v-for="account of accountData" :key="account.id" class="detail-item">
        <span>{{ account.name }}({{ account.username }})</span>
      </div>
    </div>
    <el-button slot="reference" class="link-btn" size="mini" type="text">{{ $t('View') }}</el-button>
  </el-popover>
</template>

<script>
import BaseFormatter from './base.vue'

export default {
  name: 'SwitchFormatter',
  extends: BaseFormatter,
  data() {
    return {
      formatterArgs: Object.assign(this.formatterArgsDefault, this.col.formatterArgs),
      value: this.cellValue,
      accountData: []
    }
  },
  computed: {
    title() {
      return this.formatterArgs.title || this.col.label
    }
  },
  methods: {
    async getAsyncItems() {
      const userId = this.$route.params.id || 'self'
      const url = `/api/v1/perms/users/${userId}/assets/${this.row.id}`
      this.$axios.get(url).then(res => {
        this.accountData = res?.permed_accounts || []
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.detail-content {
  max-height: 150px;
  overflow-y: auto;
  min-width: 300px;
}

.detail-item {
  border-bottom: 1px solid #EBEEF5;
  padding: 5px 0;
  margin-bottom: 0;

  &:hover {
    background-color: #3c6461;
  }
}
</style>
