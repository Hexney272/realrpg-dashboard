<template>
  <div class="vehicles-panel">
    <div class="panel-top">
      <span class="slot-label">SLOTOK: <strong>{{ limit }}</strong></span>
      <button class="btn btn-blue" @click="showSlotBuy=true">Slot vásárlás</button>
    </div>
    <div class="split-layout">
      <div class="list-side">
        <div v-for="(v,i) in vehicles" :key="v.vehicleId" :class="['item-row',{selected:sel===i}]" @click="sel=i">
          <div class="row-left">
            <span class="row-name">{{ v.name || 'Ismeretlen' }}</span>
            <span class="row-sub">{{ v.plate }} | #{{ v.vehicleId }}</span>
          </div>
          <span v-if="v.impounded" class="badge badge-red">PF</span>
        </div>
        <div v-if="!vehicles.length" class="empty-state">Nincs járműved.</div>
      </div>
      <div class="detail-side" v-if="selected">
        <div class="card">
          <h3 class="card-title">{{ selected.name }}</h3>
          <div class="stat-row"><span class="stat-label">Rendszám:</span><span class="stat-value">{{ selected.plate }}</span></div>
          <div class="stat-row"><span class="stat-label">Kilóméteróra:</span><span class="stat-value">{{ fmt(selected.odometer||0) }} km</span></div>
          <div class="stat-row"><span class="stat-label">Alvázszám (ID):</span><span class="stat-value">{{ selected.vehicleId }}</span></div>
          <div class="stat-row"><span class="stat-label">Üzemanyag:</span><span class="stat-value">{{ selected.fuelType }} ({{ Math.floor(selected.fuelLevel||0) }}%)</span></div>
          <div class="stat-row"><span class="stat-label">Meghajtás:</span><span class="stat-value">{{ selected.driveType }}</span></div>
          <div class="stat-row"><span class="stat-label">Lefoglalva:</span><span :class="['stat-value', selected.impounded?'red':'']">{{ selected.impounded?'Igen':'Nem' }}</span></div>
          <div class="btn-row">
            <button class="btn btn-blue" @click="markGPS">Megjelölés térképen</button>
            <button class="btn btn-green" @click="showSell=true">Eladás</button>
          </div>
        </div>
      </div>
    </div>
    <!-- Slot buy modal -->
    <div v-if="showSlotBuy" class="modal-overlay" @click.self="showSlotBuy=false">
      <div class="modal card">
        <h3 class="card-title">Jármű slot vásárlás</h3>
        <p class="modal-hint">100 PP / jármű slot</p>
        <input v-model="slotAmt" class="input-field" type="number" min="1" placeholder="Mennyiség"/>
        <p class="modal-cost">Fizetendő: <strong class="cost-val">{{ fmt((slotAmt||0)*100) }} PP</strong></p>
        <div class="btn-row"><button class="btn btn-green" @click="buySlot">Vásárlás</button><button class="btn btn-red" @click="showSlotBuy=false">Mégsem</button></div>
      </div>
    </div>
    <!-- Sell modal -->
    <div v-if="showSell" class="modal-overlay" @click.self="showSell=false">
      <div class="modal card">
        <h3 class="card-title">Jármű eladás</h3>
        <input v-model="sellTarget" class="input-field" type="number" placeholder="Céljátékos server ID"/>
        <input v-model="sellPrice" class="input-field" type="number" placeholder="Eladási ár ($)" style="margin-top:8px"/>
        <div class="btn-row"><button class="btn btn-green" @click="doSell">Eladás</button><button class="btn btn-red" @click="showSell=false">Mégsem</button></div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
const props = defineProps({ vehicles:{type:Array,default:()=>[]}, limit:{type:Number,default:5} })
const sel = ref(0)
const showSlotBuy = ref(false)
const showSell = ref(false)
const slotAmt = ref(1)
const sellTarget = ref('')
const sellPrice = ref('')
const selected = computed(()=>props.vehicles[sel.value]||null)
function fmt(n){return(n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.')}
function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}
function markGPS(){if(selected.value)post('markVehicleGPS',{vehicleId:selected.value.vehicleId})}
function buySlot(){post('buyVehicleSlot',{amount:parseInt(slotAmt.value)||1});showSlotBuy.value=false}
function doSell(){if(selected.value&&sellTarget.value&&sellPrice.value)post('sellVehicle',{vehicleId:selected.value.vehicleId,targetId:+sellTarget.value,price:+sellPrice.value});showSell.value=false}
</script>
<style scoped>
.panel-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.slot-label{color:var(--text-secondary);font-size:14px;text-transform:uppercase;letter-spacing:1px}
.slot-label strong{color:var(--sightgreen)}
.split-layout{display:grid;grid-template-columns:1fr 1.6fr;gap:12px;min-height:300px}
.list-side{display:flex;flex-direction:column;gap:4px;max-height:55vh;overflow-y:auto}
.row-left{display:flex;flex-direction:column}
.row-name{font-weight:700;font-size:13px}
.row-sub{font-size:11px;color:var(--sightgreen);opacity:.8}
.badge-red{background:var(--sightred);color:#fff}
.btn-row{display:flex;gap:8px;margin-top:14px}
.modal-hint{color:var(--text-secondary);font-size:12px;margin-bottom:8px}
.modal-cost{margin-top:8px;font-size:13px;color:var(--text-secondary)}
.cost-val{color:var(--sightblue)}
</style>
