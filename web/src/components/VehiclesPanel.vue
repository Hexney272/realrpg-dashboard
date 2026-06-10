<template>
  <div class="vehicles-panel">
    <div class="panel-top">
      <span class="slot-label">SLOTOK: <strong>{{ limit }}</strong></span>
      <button class="btn btn-blue" @click="showSlotBuy=true">Slot vásárlás</button>
    </div>
    <div class="split-layout">
      <!-- Vehicle list -->
      <div class="list-side">
        <div v-for="(v,i) in vehicles" :key="v.vehicleId" :class="['item-row',{selected:sel===i}]" @click="sel=i">
          <div class="row-left">
            <span class="row-name">{{ v.name || 'Ismeretlen' }}</span>
            <span class="row-sub">{{ v.plate }} | #{{ v.vehicleId }}</span>
          </div>
          <div class="row-badges">
            <span v-if="v.impounded" class="badge badge-red">{{ impoundLabel(v.impounded) }}</span>
            <span v-if="v.isRented" class="badge badge-blue">Bérelt</span>
          </div>
        </div>
        <div v-if="!vehicles.length" class="empty-state">Nincs járműved.</div>
      </div>

      <!-- Vehicle detail -->
      <div class="detail-side" v-if="selected">
        <div class="card">
          <h3 class="card-title">{{ selected.name }}</h3>

          <!-- General -->
          <div class="detail-section-title">Általános adatok:</div>
          <div class="stat-row"><span class="stat-label">Rendszám:</span><span class="stat-value">{{ selected.plate || '—' }}</span></div>
          <div class="stat-row"><span class="stat-label">Kilóméteróra állása:</span><span class="stat-value">{{ fmt(selected.odometer||0) }} km</span></div>
          <div class="stat-row"><span class="stat-label">Alvázszám (ID):</span><span class="stat-value">{{ selected.vehicleId }}</span></div>
          <div class="stat-row"><span class="stat-label">Protect:</span><span :class="['stat-value', selected.protected?'blue':'muted']">{{ selected.protected || 'nem' }}</span></div>
          <div class="stat-row"><span class="stat-label">Lefoglalva:</span><span :class="['stat-value', selected.impounded?'red':'muted']">{{ impoundLabel(selected.impounded) }}</span></div>
          <div class="stat-row"><span class="stat-label">Motor szerviz:</span><span :class="['stat-value', selected.inService?'blue':'muted']">{{ serviceLabel(selected.inService) }}</span></div>

          <!-- Engine -->
          <div class="detail-section-title">Motor/hajtáslánc:</div>
          <div class="stat-row"><span class="stat-label">Üzemanyag:</span><span class="stat-value">{{ fuelLabel(selected) }}</span></div>
          <div class="stat-row"><span class="stat-label">Meghajtás:</span><span class="stat-value">{{ selected.driveType || 'FWD' }}</span></div>

          <!-- Performance tuning -->
          <div class="detail-section-title">Teljesítmény tuning:</div>
          <div class="stat-row"><span class="stat-label">Motor:</span><span :class="['stat-value', tuningColor(selected.perfEngine)]">{{ tuningLabel(selected.perfEngine) }}</span></div>
          <div class="stat-row"><span class="stat-label">Turbo:</span><span :class="['stat-value', tuningColor(selected.perfTurbo)]">{{ tuningLabel(selected.perfTurbo) }}</span></div>
          <div class="stat-row"><span class="stat-label">ECU:</span><span :class="['stat-value', tuningColor(selected.perfEcu)]">{{ tuningLabel(selected.perfEcu) }}</span></div>
          <div class="stat-row"><span class="stat-label">Váltó:</span><span :class="['stat-value', tuningColor(selected.perfTransmission)]">{{ tuningLabel(selected.perfTransmission) }}</span></div>
          <div class="stat-row"><span class="stat-label">Felfüggesztés:</span><span :class="['stat-value', tuningColor(selected.perfSuspension)]">{{ tuningLabel(selected.perfSuspension) }}</span></div>
          <div class="stat-row"><span class="stat-label">Fék:</span><span :class="['stat-value', tuningColor(selected.perfBrakes)]">{{ tuningLabel(selected.perfBrakes) }}</span></div>
          <div class="stat-row"><span class="stat-label">Gumi:</span><span :class="['stat-value', tuningColor(selected.perfTire)]">{{ tuningLabel(selected.perfTire) }}</span></div>
          <div class="stat-row"><span class="stat-label">Súlycsökkentés:</span><span :class="['stat-value', tuningColor(selected.perfWeight)]">{{ tuningLabel(selected.perfWeight) }}</span></div>

          <!-- Extras -->
          <div class="detail-section-title">Extrák:</div>
          <div class="stat-row"><span class="stat-label">Backfire:</span><span :class="['stat-value', selected.backfire?'blue':'muted']">{{ backfireLabel(selected.backfire) }}</span></div>
          <div class="stat-row"><span class="stat-label">Hasmagasság:</span><span :class="['stat-value', selected.rideTuning?'blue':'muted']">{{ rideLabel(selected.rideTuning) }}</span></div>
          <div class="stat-row"><span class="stat-label">Paintjob:</span><span :class="['stat-value', selected.paintjob?'blue':'muted']">{{ paintjobLabel(selected) }}</span></div>
          <div class="stat-row"><span class="stat-label">Felni paintjob:</span><span :class="['stat-value', selected.wheelPaintjob?'blue':'muted']">{{ selected.wheelPaintjob ? 'van' : 'nincs' }}</span></div>
          <div class="stat-row"><span class="stat-label">Lámpa paintjob:</span><span :class="['stat-value', selected.headlightPaintjob?'blue':'muted']">{{ selected.headlightPaintjob ? 'van' : 'nincs' }}</span></div>
          <div class="stat-row"><span class="stat-label">LSD ajtó:</span><span :class="['stat-value', selected.lsdDoor?'blue':'muted']">{{ selected.lsdDoor ? 'van' : 'nincs' }}</span></div>
          <div class="stat-row"><span class="stat-label">Nitro:</span><span :class="['stat-value', selected.nitro?'blue':'muted']">{{ nitroLabel(selected) }}</span></div>
          <div class="stat-row"><span class="stat-label">Spinner:</span><span :class="['stat-value', selected.spinner?'blue':'muted']">{{ selected.spinner ? 'van' : 'nincs' }}</span></div>
          <div class="stat-row"><span class="stat-label">ABS:</span><span :class="['stat-value', selected.abs?'':'muted']">{{ absLabel(selected.abs) }}</span></div>
          <div class="stat-row"><span class="stat-label">Traffipax radar:</span><span :class="['stat-value', selected.traffiRadar?'blue':'muted']">{{ radarLabel(selected.traffiRadar) }}</span></div>

          <!-- Actions -->
          <div class="btn-row">
            <button class="btn btn-blue" @click="markGPS">Megjelölés térképen</button>
            <button class="btn btn-green" @click="showSell=true" v-if="!selected.isRented">Eladás</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Slot buy modal -->
    <div v-if="showSlotBuy" class="modal-overlay" @click.self="showSlotBuy=false">
      <div class="modal card">
        <h3 class="card-title">Jármű slot vásárlás</h3>
        <p class="modal-hint">100 RC / jármű slot</p>
        <input v-model="slotAmt" class="input-field" type="number" min="1" placeholder="Mennyiség"/>
        <p class="modal-cost">Fizetendő: <strong class="cost-val">{{ fmt((slotAmt||0)*100) }} RC</strong></p>
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

// Label helpers matching MTA original
function impoundLabel(v){
  if(!v) return 'nem'
  if(v===1) return 'PF'
  if(v===2) return 'PD'
  if(v===3) return 'átállás'
  return 'igen'
}

function serviceLabel(v){
  if(!v) return 'nincs szervizben'
  return 'szervizben'
}

function fuelLabel(veh){
  if(!veh) return '—'
  const type = veh.isElectric ? 'elektromos' : (veh.fuelType==='diesel' ? 'dízel' : 'benzin')
  const level = Math.floor(veh.fuelLevel||0)
  if(veh.isElectric) return `${type} (${Math.floor(level/75*100)}%)`
  return `${type} (${level}L / ${veh.tankSize||60}L)`
}

const tuningLevels = ['gyári','profi','verseny','venom']
const tuningColors = ['muted','','yellow','blue']
function tuningLabel(v){ return tuningLevels[v||0] || 'gyári' }
function tuningColor(v){ return tuningColors[v||0] || 'muted' }

function backfireLabel(v){
  if(v===2) return 'egyedi'
  if(v===1) return 'normál'
  return 'nincs'
}

function rideLabel(v){
  if(v===5) return 'AirRide'
  if(v && v>0) return `ültetőrugó ${v}`
  return 'gyári'
}

function paintjobLabel(veh){
  if(veh.customPaintjob) return 'egyedi'
  if(veh.paintjob) return 'normál'
  return 'nincs'
}

function nitroLabel(veh){
  if(!veh.nitro) return 'nincs'
  if(veh.nitroLevel>0) return `van (${veh.nitroLevel}/4)`
  return 'van, üres'
}

function absLabel(v){
  if(!v) return 'nincs'
  const levels = ['','Gyenge','Normál','Erős']
  return levels[v] || 'van'
}

function radarLabel(v){
  if(v===1) return 'van, normál'
  if(v===2) return 'van, prémium'
  return 'nincs'
}
</script>

<style scoped>
.panel-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.slot-label{color:var(--text-secondary);font-size:14px;text-transform:uppercase;letter-spacing:1px}
.slot-label strong{color:var(--sightgreen)}
.split-layout{display:grid;grid-template-columns:280px 1fr;gap:12px;min-height:400px}
.list-side{display:flex;flex-direction:column;gap:4px;max-height:65vh;overflow-y:auto}
.row-left{display:flex;flex-direction:column;flex:1}
.row-name{font-weight:700;font-size:13px}
.row-sub{font-size:11px;color:var(--sightgreen);opacity:.8}
.row-badges{display:flex;gap:4px;align-items:center}
.badge-red{background:var(--sightred);color:#fff;padding:2px 6px;border-radius:2px;font-size:9px;font-weight:700}
.badge-blue{background:var(--sightblue);color:#fff;padding:2px 6px;border-radius:2px;font-size:9px;font-weight:700}
.detail-side{max-height:65vh;overflow-y:auto}
.detail-section-title{font-size:12px;font-weight:700;color:var(--sightgreen);text-transform:uppercase;letter-spacing:.5px;margin:12px 0 6px;padding-top:8px;border-top:1px solid var(--sightgrey3)}
.detail-section-title:first-of-type{border-top:none;margin-top:8px}
.stat-value.muted{color:var(--sightlightgrey)}
.stat-value.blue{color:var(--sightblue)}
.stat-value.yellow{color:var(--sightyellow)}
.btn-row{display:flex;gap:8px;margin-top:14px}
.modal-overlay{position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.7);display:flex;align-items:center;justify-content:center;z-index:200}
.modal{width:380px}
.modal-hint{color:var(--text-secondary);font-size:12px;margin-bottom:8px}
.modal-cost{margin-top:8px;font-size:13px;color:var(--text-secondary)}
.cost-val{color:var(--sightblue)}
</style>
