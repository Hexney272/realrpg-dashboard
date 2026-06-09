<template>
  <div class="vehicles-panel">
    <div class="panel-header">
      <div class="slot-info">
        <span>Jarmuvek: {{ vehicles.length }} / Slotok: {{ limit }}</span>
      </div>
      <button class="btn btn-blue" @click="buySlot">Slot vasarlas ({{ slotPrice }} PP)</button>
    </div>

    <div class="vehicles-layout">
      <!-- Vehicle List -->
      <div class="vehicle-list">
        <div
          v-for="(veh, index) in vehicles"
          :key="veh.vehicleId"
          :class="['item-row', { selected: selectedIndex === index }]"
          @click="selectVehicle(index)"
        >
          <div class="veh-info">
            <span class="veh-name">{{ veh.name || 'Ismeretlen' }}</span>
            <span class="veh-plate">{{ veh.plate }}</span>
          </div>
          <div class="veh-badges">
            <span v-if="veh.impounded" class="badge" style="background: var(--accent-red); color: white;">Lefoglalva</span>
          </div>
        </div>
        <div v-if="vehicles.length === 0" class="empty-state">
          Nincs jarmuved.
        </div>
      </div>

      <!-- Vehicle Details -->
      <div v-if="selectedVehicle" class="vehicle-details card">
        <h3 class="card-title">{{ selectedVehicle.name }}</h3>
        <div class="stat-row">
          <span class="stat-label">Rendszam:</span>
          <span class="stat-value">{{ selectedVehicle.plate }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Kilometeroraallas:</span>
          <span class="stat-value">{{ formatNumber(selectedVehicle.odometer || 0) }} km</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">ID:</span>
          <span class="stat-value">{{ selectedVehicle.vehicleId }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Uzemanyag:</span>
          <span class="stat-value">{{ selectedVehicle.fuelType }} ({{ Math.floor(selectedVehicle.fuelLevel || 0) }}%)</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Meghajtas:</span>
          <span class="stat-value">{{ selectedVehicle.driveType }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Lefoglalva:</span>
          <span :class="['stat-value', selectedVehicle.impounded ? 'red' : '']">
            {{ selectedVehicle.impounded ? 'Igen' : 'Nem' }}
          </span>
        </div>

        <div class="vehicle-actions">
          <button class="btn btn-blue" @click="markGPS">Megjeloles terkepen</button>
          <button class="btn btn-green" @click="showSellModal = true">Eladas</button>
        </div>
      </div>
    </div>

    <!-- Sell Modal -->
    <div v-if="showSellModal" class="modal-overlay" @click.self="showSellModal = false">
      <div class="modal card">
        <h3 class="card-title">Jarmu eladas</h3>
        <input v-model="sellTargetId" class="input-field" placeholder="Celjatek server ID" type="number" />
        <input v-model="sellPrice" class="input-field" placeholder="Eladasi ar ($)" type="number" style="margin-top: 8px" />
        <div style="margin-top: 12px; display: flex; gap: 8px">
          <button class="btn btn-green" @click="sellVehicle">Eladas</button>
          <button class="btn btn-red" @click="showSellModal = false">Megse</button>
        </div>
      </div>
    </div>

    <!-- Buy Slot Modal -->
    <div v-if="showBuySlotModal" class="modal-overlay" @click.self="showBuySlotModal = false">
      <div class="modal card">
        <h3 class="card-title">Slot vasarlas</h3>
        <p style="color: var(--text-secondary); margin-bottom: 10px">{{ slotPrice }} PP / jarmu slot</p>
        <input v-model="slotAmount" class="input-field" placeholder="Mennyiseg" type="number" min="1" />
        <p style="margin-top: 8px; color: var(--text-secondary)">
          Fizetendo: <span style="color: var(--accent-blue); font-weight: 700">{{ formatNumber((slotAmount || 0) * slotPrice) }} PP</span>
        </p>
        <div style="margin-top: 12px; display: flex; gap: 8px">
          <button class="btn btn-green" @click="confirmBuySlot">Vasarlas</button>
          <button class="btn btn-red" @click="showBuySlotModal = false">Megse</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  vehicles: { type: Array, default: () => [] },
  limit: { type: Number, default: 5 }
})

const slotPrice = 100
const selectedIndex = ref(0)
const showSellModal = ref(false)
const showBuySlotModal = ref(false)
const sellTargetId = ref('')
const sellPrice = ref('')
const slotAmount = ref(1)

const selectedVehicle = computed(() => props.vehicles[selectedIndex.value] || null)

function selectVehicle(index) {
  selectedIndex.value = index
}

function formatNumber(num) {
  if (!num) return '0'
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

function markGPS() {
  if (!selectedVehicle.value) return
  fetch(`https://${getResource()}/markVehicleGPS`, {
    method: 'POST',
    body: JSON.stringify({ vehicleId: selectedVehicle.value.vehicleId })
  })
}

function sellVehicle() {
  if (!selectedVehicle.value || !sellTargetId.value || !sellPrice.value) return
  fetch(`https://${getResource()}/sellVehicle`, {
    method: 'POST',
    body: JSON.stringify({
      vehicleId: selectedVehicle.value.vehicleId,
      targetId: parseInt(sellTargetId.value),
      price: parseInt(sellPrice.value)
    })
  })
  showSellModal.value = false
}

function buySlot() {
  showBuySlotModal.value = true
}

function confirmBuySlot() {
  const amt = parseInt(slotAmount.value) || 1
  fetch(`https://${getResource()}/buyVehicleSlot`, {
    method: 'POST',
    body: JSON.stringify({ amount: amt })
  })
  showBuySlotModal.value = false
}

function getResource() {
  return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard'
}
</script>

<style scoped>
.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}
.slot-info {
  color: var(--text-secondary);
  font-size: 14px;
}
.vehicles-layout {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 15px;
}
.vehicle-list {
  max-height: 500px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.veh-info {
  display: flex;
  flex-direction: column;
}
.veh-name {
  font-weight: 600;
  font-size: 13px;
}
.veh-plate {
  font-size: 11px;
  color: var(--accent-green);
}
.vehicle-actions {
  display: flex;
  gap: 8px;
  margin-top: 15px;
}
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.modal {
  width: 350px;
}
.empty-state {
  text-align: center;
  color: var(--text-muted);
  padding: 30px;
}
</style>
