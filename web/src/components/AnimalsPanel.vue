<template>
  <div class="animals-panel">
    <div class="vehicles-layout">
      <div class="vehicle-list">
        <div v-for="(animal, i) in animals" :key="animal.animalId" :class="['item-row', { selected: selectedIndex === i }]" @click="selectedIndex = i">
          <div class="veh-info">
            <span class="veh-name">{{ animal.name }}</span>
            <span class="veh-plate">{{ animal.type }} - #{{ animal.animalId }}</span>
          </div>
        </div>
        <div class="item-row" style="border-color: var(--accent-blue); cursor:pointer" @click="showBuyModal = true">
          <span style="color: var(--accent-blue); font-weight: 600">+ Haziallat vasarlas</span>
        </div>
      </div>

      <div v-if="selected" class="card">
        <h3 class="card-title">{{ selected.name }}</h3>
        <div class="stat-row"><span class="stat-label">ID:</span><span class="stat-value">{{ selected.animalId }}</span></div>
        <div class="stat-row"><span class="stat-label">Fajta:</span><span class="stat-value">{{ selected.type }}</span></div>
        <div class="stat-row"><span class="stat-label">Eletero:</span><span :class="['stat-value', selected.health <= 25 ? 'red' : '']">{{ Math.floor(selected.health) }}%</span></div>
        <div class="stat-row"><span class="stat-label">Ehseg:</span><span class="stat-value blue">{{ Math.floor(selected.hunger) }}%</span></div>
        <div class="stat-row"><span class="stat-label">Szeretet:</span><span class="stat-value yellow">{{ Math.floor(selected.love) }}%</span></div>
        <div class="vehicle-actions">
          <button class="btn btn-green" @click="spawnAnimal">Spawn</button>
          <button class="btn btn-red" @click="despawnAnimal">Despawn</button>
          <button class="btn btn-blue" @click="showRename = true">Atnevezes</button>
        </div>
      </div>
    </div>

    <!-- Buy Modal -->
    <div v-if="showBuyModal" class="modal-overlay" @click.self="showBuyModal = false">
      <div class="modal card">
        <h3 class="card-title">Haziallat vasarlas</h3>
        <select v-model="buyType" class="input-field">
          <option v-for="a in animalTypes" :key="a.name" :value="a.name">{{ a.name }} - {{ a.price }} PP</option>
        </select>
        <input v-model="buyName" class="input-field" placeholder="Allat neve" style="margin-top:8px"/>
        <div style="margin-top: 12px; display: flex; gap: 8px">
          <button class="btn btn-green" @click="buyAnimal">Vasarlas</button>
          <button class="btn btn-red" @click="showBuyModal = false">Megse</button>
        </div>
      </div>
    </div>

    <!-- Rename Modal -->
    <div v-if="showRename" class="modal-overlay" @click.self="showRename = false">
      <div class="modal card">
        <h3 class="card-title">Allat atnevezese</h3>
        <input v-model="newName" class="input-field" placeholder="Uj nev" />
        <div style="margin-top: 12px; display: flex; gap: 8px">
          <button class="btn btn-green" @click="renameAnimal">Mentes</button>
          <button class="btn btn-red" @click="showRename = false">Megse</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({ animals: { type: Array, default: () => [] } })
const selectedIndex = ref(0)
const showBuyModal = ref(false)
const showRename = ref(false)
const buyType = ref('Husky')
const buyName = ref('')
const newName = ref('')
const animalTypes = [
  { name: 'Husky', price: 9000 }, { name: 'Rottweiler', price: 6000 },
  { name: 'Doberman', price: 8000 }, { name: 'Bull Terrier', price: 9000 },
  { name: 'Boxer', price: 7000 }, { name: 'Francia Bulldog', price: 10000 },
]
const selected = computed(() => props.animals[selectedIndex.value] || null)

function post(endpoint, data) { fetch(`https://${getResource()}/${endpoint}`, { method: 'POST', body: JSON.stringify(data) }) }
function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
function spawnAnimal() { if (selected.value) post('spawnAnimal', { animalId: selected.value.animalId }) }
function despawnAnimal() { if (selected.value) post('despawnAnimal', { animalId: selected.value.animalId }) }
function buyAnimal() { post('buyAnimal', { animalType: buyType.value, name: buyName.value }); showBuyModal.value = false }
function renameAnimal() { if (selected.value) post('renameAnimal', { animalId: selected.value.animalId, newName: newName.value }); showRename.value = false }
</script>

<style scoped>
.vehicles-layout { display: grid; grid-template-columns: 1fr 1.5fr; gap: 15px; }
.vehicle-list { max-height: 500px; overflow-y: auto; display: flex; flex-direction: column; gap: 6px; }
.veh-info { display: flex; flex-direction: column; }
.veh-name { font-weight: 600; font-size: 13px; }
.veh-plate { font-size: 11px; color: var(--accent-green); }
.vehicle-actions { display: flex; gap: 8px; margin-top: 15px; flex-wrap: wrap; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; z-index: 100; }
.modal { width: 350px; }
</style>
