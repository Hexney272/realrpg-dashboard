<template>
  <div class="interiors-panel">
    <div class="panel-top">
      <span class="slot-label">SAJÁT TULAJDON: <strong>{{ interiors.length }}</strong> | SLOTOK: <strong>{{ limit }}</strong></span>
      <button class="btn btn-blue" @click="showBuy=true">Slot vásárlás</button>
    </div>
    <div class="split-layout">
      <div class="list-side">
        <div v-for="(it,i) in interiors" :key="it.interiorId" :class="['item-row',{selected:sel===i}]" @click="sel=i">
          <div class="row-left">
            <span class="row-name">{{ it.name }}</span>
            <span class="row-sub">#{{ it.interiorId }} - {{ typeLabel(it.type) }}</span>
          </div>
        </div>
        <div v-if="!interiors.length" class="empty-state">Nincs interiorod.</div>
      </div>
      <div class="detail-side" v-if="selected">
        <div class="card">
          <h3 class="card-title">[{{ selected.interiorId }}] {{ selected.name }}</h3>
          <div class="stat-row"><span class="stat-label">Típus:</span><span class="stat-value">{{ typeLabel(selected.type) }}</span></div>
          <div class="stat-row"><span class="stat-label">Zárva:</span><span :class="['stat-value',selected.locked?'':'red']">{{ selected.locked?'Igen':'Nem' }}</span></div>
          <div class="btn-row"><button class="btn btn-blue" @click="mark">Megjelölés térképen</button></div>
        </div>
      </div>
    </div>
    <div v-if="showBuy" class="modal-overlay" @click.self="showBuy=false">
      <div class="modal card">
        <h3 class="card-title">Interior slot vásárlás</h3>
        <p class="modal-hint">100 RC / interior slot</p>
        <input v-model="amt" class="input-field" type="number" min="1" placeholder="Mennyiség"/>
        <div class="btn-row"><button class="btn btn-green" @click="buy">Vásárlás</button><button class="btn btn-red" @click="showBuy=false">Mégsem</button></div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
const props = defineProps({interiors:{type:Array,default:()=>[]},limit:{type:Number,default:3}})
const sel=ref(0);const showBuy=ref(false);const amt=ref(1)
const selected=computed(()=>props.interiors[sel.value]||null)
function typeLabel(t){return{house:'Ház',business:'Üzlet',garage:'Garázs',garage2:'Garázs',farm:'Farm',rentable:'Bérlemény'}[t]||t}
function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}
function mark(){if(selected.value)post('markInteriorGPS',{interiorId:selected.value.interiorId})}
function buy(){post('buyInteriorSlot',{amount:parseInt(amt.value)||1});showBuy.value=false}
</script>
<style scoped>
.panel-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.slot-label{color:var(--text-secondary);font-size:14px;text-transform:uppercase;letter-spacing:1px}
.slot-label strong{color:var(--sightgreen)}
.split-layout{display:grid;grid-template-columns:1fr 1.6fr;gap:12px;min-height:300px}
.list-side{display:flex;flex-direction:column;gap:4px;max-height:55vh;overflow-y:auto}
.row-left{display:flex;flex-direction:column}
.row-name{font-weight:700;font-size:13px}
.row-sub{font-size:11px;color:var(--sightblue);opacity:.8}
.btn-row{display:flex;gap:8px;margin-top:14px}
.modal-hint{color:var(--text-secondary);font-size:12px;margin-bottom:8px}
</style>
