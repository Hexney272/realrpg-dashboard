<template>
  <div class="interiors-panel">
    <div class="panel-header">
      <span class="slot-info">Interiorok: {{ interiors.length }} / Slotok: {{ limit }}</span>
      <button class="btn btn-blue" @click="showBuySlot = true">Slot vasarlas (100 PP)</button>
    </div>

    <div class="vehicles-layout">
      <div class="vehicle-list">
        <div
          v-for="(inti, index) in interiors"
          :key="inti.interiorId"
          :class="['item-row', { selected: selectedIndex === index }]"
          @click="selectedIndex = index"
        >
          <div class="veh-info">
            <span class="veh-name">{{ inti.name }}</span>
            <span class="veh-plate">#{{ inti.interiorId }} - {{ typeLabel(inti.type) }}</span>
          </div>
        </div>
        <div v-if="interiors.length === 0" class="empty-state">Nincs interiorod.</div>
      </div>

      <div v-if="selected" class="card">
        <h3 class="card-title">[{{ selected.interiorId }}] {{ selected.name }}</h3>
        <div class="stat-row">
          <span class="stat-label">Tipus:</span>
          <span class="stat-value">{{ typeLabel(selected.type) }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Zarva:</span>
          <span :class="['stat-value', selected.locked ? '' : 'red']">{{ selected.locked ? 'Igen' : 'Nem' }}</span>
        </div>
        <button class="btn btn-blue" style="margin-top: 12px" @click="markGPS">Megjeloles terkepen</button>
      </div>
    </div>

    <!-- Buy slot modal -->
    <div v-if="showBuySlot" class="modal-overlay" @click.self="showBuySlot = false">
      <div class="modal card">
        <h3 class="card-title">Interior slot vasarlas</h3>
        <input v-model="slotAmount" class="input-field" placeholder="Mennyiseg" type="number" min="1" />
        <div style="margin-top: 12px; display: flex; gap: 8px">
          <button class="btn btn-green" @click="buySlot">Vasarlas</button>
          <button class="btn btn-red" @click="showBuySlot = false">Megse</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({
  interiors: { type: Array, default: () => [] },
  limit: { type: Number, default: 3 }
})
const selectedIndex = ref(0)
const showBuySlot = ref(false)
const slotAmount = ref(1)
const selected = computed(() => props.interiors[selectedIndex.value] || null)

function typeLabel(type) {
  const labels = { house: 'Haz', business: 'Uzlet', garage: 'Garazs', garage2: 'Garazs', farm: 'Farm', rentable: 'Berlemenyes' }
  return labels[type] || type
}
function markGPS() {
  if (!selected.value) return
  fetch(`https://${getResource()}/markInteriorGPS`, { method: 'POST', body: JSON.stringify({ interiorId: selected.value.interiorId }) })
}
function buySlot() {
  fetch(`https://${getResource()}/buyInteriorSlot`, { method: 'POST', body: JSON.stringify({ amount: parseInt(slotAmount.value) || 1 }) })
  showBuySlot.value = false
}
function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
</script>

<style scoped>
.panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
.slot-info { color: var(--text-secondary); font-size: 14px; }
.vehicles-layout { display: grid; grid-template-columns: 1fr 1.5fr; gap: 15px; }
.vehicle-list { max-height: 500px; overflow-y: auto; display: flex; flex-direction: column; gap: 6px; }
.veh-info { display: flex; flex-direction: column; }
.veh-name { font-weight: 600; font-size: 13px; }
.veh-plate { font-size: 11px; color: var(--accent-blue); }
.empty-state { text-align: center; color: var(--text-muted); padding: 30px; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; z-index: 100; }
.modal { width: 350px; }
</style>
