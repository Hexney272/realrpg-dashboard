<template>
  <div class="settings-panel">
    <div class="card">
      <h3 class="card-title">Megjelenés / Játékmenet</h3>
      <div class="setting-item">
        <span>Streamer mód</span>
        <label class="toggle"><input type="checkbox" :checked="localSettings.streamerMode" @change="toggleSetting('streamerMode',$event.target.checked)"/><span class="slider"></span></label>
      </div>
      <div class="setting-item">
        <span>HUD megjelenítése</span>
        <label class="toggle"><input type="checkbox" :checked="localSettings.hudVisible" @change="toggleSetting('hudVisible',$event.target.checked)"/><span class="slider"></span></label>
      </div>
      <div class="setting-item">
        <span>Nevek megjelenítése</span>
        <label class="toggle"><input type="checkbox" :checked="localSettings.nametagsVisible" @change="toggleSetting('nametagsVisible',$event.target.checked)"/><span class="slider"></span></label>
      </div>
      <div class="setting-item">
        <span>3D blipek megjelenítése</span>
        <label class="toggle"><input type="checkbox" :checked="localSettings.blips3d" @change="toggleSetting('blips3d',$event.target.checked)"/><span class="slider"></span></label>
      </div>
      <div class="setting-item">
        <span>Rendszámtáblák megjelenítése</span>
        <label class="toggle"><input type="checkbox" :checked="localSettings.platesVisible" @change="toggleSetting('platesVisible',$event.target.checked)"/><span class="slider"></span></label>
      </div>
    </div>
    <div class="card">
      <h3 class="card-title">Sétastílus</h3>
      <div class="style-grid">
        <button v-for="(s,i) in styles" :key="i" :class="['style-btn',{active:localSettings.walkingStyle===(i+1)}]" @click="setWalk(i+1)">{{ s }}</button>
      </div>
    </div>
    <div class="card">
      <h3 class="card-title">Voice hangerő</h3>
      <div class="slider-row">
        <input type="range" min="0" max="100" :value="localSettings.voiceVolume||50" @input="saveSlider('voiceVolume',+$event.target.value)" class="range"/>
        <span class="range-val">{{ localSettings.voiceVolume||50 }}%</span>
      </div>
    </div>
    <div class="card">
      <h3 class="card-title">Látóhatár</h3>
      <div class="slider-row">
        <input type="range" min="300" max="6000" :value="localSettings.farClip||3000" @input="saveSlider('farClip',+$event.target.value)" class="range"/>
        <span class="range-val">{{ localSettings.farClip||3000 }}</span>
      </div>
    </div>
    <div class="card">
      <h3 class="card-title">Köd távolság</h3>
      <div class="slider-row">
        <input type="range" min="10" max="5000" :value="localSettings.fogDistance||2000" @input="saveSlider('fogDistance',+$event.target.value)" class="range"/>
        <span class="range-val">{{ localSettings.fogDistance||2000 }}</span>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, watch } from 'vue'
const props = defineProps({settings:{type:Object,default:()=>({})}})

// Local reactive copy of settings
const localSettings = ref({...props.settings})
watch(()=>props.settings,(v)=>{localSettings.value={...v}},{deep:true})

const styles=['Stílus #1','Stílus #2','Stílus #3','Stílus #4','Stílus #5','Stílus #6','Stílus #7','Stílus #8','Stílus #9','Stílus #10','Stílus #11','Stílus #12','Stílus #13','Stílus #14','Stílus #15','Stílus #16','Stílus #17']

function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}

function toggleSetting(key, value){
  localSettings.value[key] = value
  post('saveSetting',{key,value})
}

function saveSlider(key, value){
  localSettings.value[key] = value
  post('saveSetting',{key,value})
}

function setWalk(i){
  localSettings.value.walkingStyle = i
  post('setWalkingStyle',{index:i})
  post('saveSetting',{key:'walkingStyle',value:i})
}
</script>
<style scoped>
.setting-item{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--sightgrey3);font-size:13px;color:var(--text-secondary)}
.setting-item:last-child{border-bottom:none}
.toggle{position:relative;width:40px;height:22px;display:inline-block}
.toggle input{opacity:0;width:0;height:0}
.slider{position:absolute;top:0;left:0;right:0;bottom:0;background:var(--sightgrey4);border-radius:11px;cursor:pointer;transition:.3s}
.slider::before{content:'';position:absolute;width:16px;height:16px;left:3px;bottom:3px;background:#fff;border-radius:50%;transition:.3s}
.toggle input:checked+.slider{background:var(--sightgreen)}
.toggle input:checked+.slider::before{transform:translateX(18px)}
.style-grid{display:flex;flex-wrap:wrap;gap:6px}
.style-btn{padding:6px 12px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:11px;cursor:pointer;transition:all .2s;font-weight:600}
.style-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.style-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.slider-row{display:flex;align-items:center;gap:12px}
.range{flex:1;accent-color:var(--sightgreen);height:4px}
.range-val{color:var(--sightgreen);font-weight:700;font-size:14px;min-width:50px;text-align:right}
</style>
