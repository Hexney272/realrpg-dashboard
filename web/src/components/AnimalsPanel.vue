<template>
  <div class="animals-panel">
    <div class="split-layout">
      <div class="list-side">
        <div v-for="(a,i) in animals" :key="a.animalId" :class="['item-row',{selected:sel===i}]" @click="sel=i">
          <img :src="getAnimalImg(a.type)" class="animal-thumb" />
          <div class="row-left">
            <span class="row-name">{{ a.name }}</span>
            <span class="row-sub">{{ a.type }} - #{{ a.animalId }}</span>
          </div>
        </div>
        <div class="item-row buy-row" @click="showBuy=true">
          <span class="buy-label">+ Háziállat vásárlás</span>
        </div>
        <div class="list-footer">Háziállatok: {{ animals.length }}</div>
      </div>
      <div class="detail-side" v-if="selected">
        <div class="card">
          <div class="animal-detail-header">
            <img :src="getAnimalImg(selected.type)" class="animal-detail-img" />
            <h3 class="card-title">{{ selected.name }}</h3>
          </div>
          <div class="stat-row"><span class="stat-label">ID:</span><span class="stat-value">{{ selected.animalId }}</span></div>
          <div class="stat-row"><span class="stat-label">Fajta:</span><span class="stat-value">{{ selected.type }}</span></div>
          <!-- Health bar -->
          <div class="bar-group">
            <span class="bar-label">Életerő: <strong :class="barColor(selected.health)">{{ Math.floor(selected.health) }}%</strong></span>
            <div class="bar-track"><div class="bar-fill green" :style="{width: selected.health+'%'}"></div></div>
          </div>
          <div class="bar-group">
            <span class="bar-label">Éhség: <strong :class="barColor(selected.hunger)">{{ Math.floor(selected.hunger) }}%</strong></span>
            <div class="bar-track"><div class="bar-fill blue" :style="{width: selected.hunger+'%'}"></div></div>
          </div>
          <div class="bar-group">
            <span class="bar-label">Szeretet: <strong :class="barColor(selected.love)">{{ Math.floor(selected.love) }}%</strong></span>
            <div class="bar-track"><div class="bar-fill red" :style="{width: selected.love+'%'}"></div></div>
          </div>
          <div class="btn-row">
            <button class="btn btn-green" @click="post('spawnAnimal',{animalId:selected.animalId})">Spawn</button>
            <button class="btn btn-red" @click="post('despawnAnimal',{animalId:selected.animalId})">Despawn</button>
            <button class="btn btn-blue" @click="showRename=true">Átnevezés</button>
          </div>
        </div>
      </div>
    </div>
    <!-- Buy modal -->
    <div v-if="showBuy" class="modal-overlay" @click.self="showBuy=false">
      <div class="modal card">
        <h3 class="card-title">Háziállat vásárlás</h3>
        <select v-model="buyType" class="input-field">
          <option v-for="a in types" :key="a.name" :value="a.name">{{ a.name }} - {{ a.price }} RC</option>
        </select>
        <input v-model="buyName" class="input-field" placeholder="Állat neve" style="margin-top:8px"/>
        <div class="btn-row"><button class="btn btn-green" @click="doBuy">Vásárlás</button><button class="btn btn-red" @click="showBuy=false">Mégsem</button></div>
      </div>
    </div>
    <!-- Rename modal -->
    <div v-if="showRename" class="modal-overlay" @click.self="showRename=false">
      <div class="modal card">
        <h3 class="card-title">Átnevezés</h3>
        <input v-model="newName" class="input-field" placeholder="Új név"/>
        <div class="btn-row"><button class="btn btn-green" @click="doRename">Mentés</button><button class="btn btn-red" @click="showRename=false">Mégsem</button></div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
const props = defineProps({animals:{type:Array,default:()=>[]}})
const sel=ref(0);const showBuy=ref(false);const showRename=ref(false)
const buyType=ref('Husky');const buyName=ref('');const newName=ref('')
const types=[{name:'Husky',price:9000},{name:'Rottweiler',price:6000},{name:'Doberman',price:8000},{name:'Bull Terrier',price:9000},{name:'Boxer',price:7000},{name:'Francia Bulldog',price:10000}]
const selected=computed(()=>props.animals[sel.value]||null)
function barColor(v){return v<=25?'c-red':v<=75?'c-yellow':'c-green'}
function getAnimalImg(type){
  const map={'Husky':'husky','Rottweiler':'rottweiler','Doberman':'doberman','Bull Terrier':'bullterrier','Boxer':'boxer','Francia Bulldog':'franciabulldog'}
  return `./img/dogs/${map[type]||'husky'}.png`
}
function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}
function doBuy(){post('buyAnimal',{animalType:buyType.value,name:buyName.value});showBuy.value=false}
function doRename(){if(selected.value)post('renameAnimal',{animalId:selected.value.animalId,newName:newName.value});showRename.value=false}
</script>
<style scoped>
.split-layout{display:grid;grid-template-columns:1fr 1.6fr;gap:12px;min-height:300px}
.list-side{display:flex;flex-direction:column;gap:4px;max-height:55vh;overflow-y:auto}
.row-left{display:flex;flex-direction:column}
.animal-thumb{width:36px;height:36px;border-radius:4px;object-fit:cover;margin-right:10px;background:var(--sightgrey3)}
.row-name{font-weight:700;font-size:13px}
.row-sub{font-size:11px;color:var(--sightgreen);opacity:.8}
.buy-row{border:1px dashed var(--sightblue);justify-content:center}
.buy-label{color:var(--sightblue);font-weight:700;font-size:13px}
.list-footer{text-align:center;padding:8px;color:var(--text-muted);font-size:11px;background:var(--sightgrey3);border-radius:3px;margin-top:4px}
.animal-detail-header{display:flex;align-items:center;gap:12px;margin-bottom:12px}
.animal-detail-img{width:64px;height:64px;border-radius:6px;object-fit:cover;border:2px solid var(--sightgrey4);background:var(--sightgrey1)}
.bar-group{margin:10px 0}
.bar-label{font-size:12px;color:var(--text-secondary);display:flex;justify-content:space-between;margin-bottom:4px}
.bar-track{height:12px;background:var(--sightgrey3);border-radius:2px;overflow:hidden}
.bar-fill{height:100%;border-radius:2px;transition:width .4s ease}
.bar-fill.green{background:var(--sightgreen)}
.bar-fill.blue{background:var(--sightblue)}
.bar-fill.red{background:var(--sightred)}
.c-red{color:var(--sightred)}.c-yellow{color:var(--sightyellow)}.c-green{color:var(--sightgreen)}
.btn-row{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap}
</style>
