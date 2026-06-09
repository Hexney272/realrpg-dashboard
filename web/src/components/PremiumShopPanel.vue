<template>
  <div class="shop-panel">
    <div class="shop-header">
      <div class="shop-tabs">
        <button v-for="(menu, i) in shop" :key="i" :class="['btn', activeMenu === i ? 'btn-blue' : '']" @click="activeMenu = i" style="font-size: 12px">
          {{ menu.name }}
        </button>
      </div>
      <div class="pp-info">Egyenleg: <span style="color: var(--accent-blue); font-weight: 700">{{ formatNumber(balance) }} PP</span></div>
    </div>

    <div v-if="currentItems.length > 0" class="shop-grid">
      <div v-for="(item, i) in currentItems" :key="i" class="shop-item card">
        <div class="item-name">{{ item.item }}</div>
        <div class="item-price">{{ formatNumber(item.price) }} PP</div>
        <button
          :class="['btn', item.price <= balance ? 'btn-green' : 'btn-disabled btn-red']"
          @click="buyItem(i)"
          :disabled="item.price > balance"
        >
          {{ item.price <= balance ? 'Vasarlas' : 'Nincs eleg PP' }}
        </button>
      </div>
    </div>
    <div v-else class="empty-state">Nincs elem ebben a kategoriaban.</div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({
  shop: { type: Array, default: () => [] },
  balance: { type: Number, default: 0 }
})
const activeMenu = ref(0)
const currentItems = computed(() => (props.shop[activeMenu.value]?.items) || [])

function formatNumber(num) { return (num || 0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') }
function buyItem(itemIndex) {
  fetch(`https://${getResource()}/buyPremiumItem`, {
    method: 'POST',
    body: JSON.stringify({ menuIndex: activeMenu.value + 1, itemIndex: itemIndex + 1, amount: 1 })
  })
}
function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
</script>

<style scoped>
.shop-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; flex-wrap: wrap; gap: 8px; }
.shop-tabs { display: flex; gap: 6px; flex-wrap: wrap; }
.pp-info { font-size: 13px; color: var(--text-secondary); }
.shop-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 12px; }
.shop-item { text-align: center; padding: 16px; }
.item-name { font-weight: 600; font-size: 13px; margin-bottom: 6px; color: var(--text-primary); text-transform: uppercase; }
.item-price { color: var(--accent-green); font-weight: 700; margin-bottom: 10px; font-size: 14px; }
.empty-state { text-align: center; color: var(--text-muted); padding: 40px; }
</style>
