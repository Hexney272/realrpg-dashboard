<template>
  <div class="settings-panel">
    <!-- Category tabs -->
    <div class="settings-tabs">
      <button v-for="(cat,i) in categories" :key="i" :class="['tab-btn',{active:activeTab===i}]" @click="activeTab=i">{{ cat }}</button>
    </div>

    <!-- 1. Megjelenés -->
    <div v-if="activeTab===0" class="settings-content">
      <div class="card">
        <h3 class="card-title">Megjelenés</h3>
        <SettingToggle label="HUD megjelenítése" :value="s.hudVisible!==false" @change="v=>save('hudVisible',v)" />
        <SettingToggle label="Nevek megjelenítése" :value="s.nametagsVisible!==false" @change="v=>save('nametagsVisible',v)" />
        <SettingToggle label="Rendszámtáblák megjelenítése" :value="s.platesVisible!==false" @change="v=>save('platesVisible',v)" />
        <SettingToggle label="Streamer mód" :value="s.streamerMode" @change="v=>save('streamerMode',v)" />
        <p class="hint">Streamer módban az összes jogvédett zene és érzékeny adat el lesz rejtve.</p>
      </div>
    </div>

    <!-- 2. Karakter -->
    <div v-if="activeTab===1" class="settings-content">
      <div class="card">
        <h3 class="card-title">Sétastílus</h3>
        <p class="hint">Válassz stílust a karaktered mozgásához.</p>
        <div class="style-grid">
          <button v-for="(st,i) in walkStyles" :key="i" :class="['style-btn',{active:(s.walkingStyle||1)===(i+1)}]" @click="setWalk(i+1)">{{ st }}</button>
        </div>
      </div>
      <div class="card">
        <h3 class="card-title">Beszéd animáció</h3>
        <p class="hint">Chat használatakor milyen animáció játszódjon le.</p>
        <div class="style-grid">
          <button v-for="(a,i) in chatAnims" :key="i" :class="['style-btn',{active:(s.chatAnim||1)===(i+1)}]" @click="save('chatAnim',i+1)">{{ a }}</button>
        </div>
      </div>
    </div>

    <!-- 3. Hang -->
    <div v-if="activeTab===2" class="settings-content">
      <div class="card">
        <h3 class="card-title">Hang beállítások</h3>
        <SettingSlider label="Voice hangerő" :value="s.voiceVolume||50" :min="0" :max="100" unit="%" @change="v=>save('voiceVolume',v)" />
        <SettingEnum label="Kilométeróra mértékegység" :value="s.speedoUnit==='MPH'?1:0" :options="['KM/H','MPH']" @change="v=>save('speedoUnit',v===1?'MPH':'KM/H')" />
      </div>
    </div>

    <!-- 4. Irányítás -->
    <div v-if="activeTab===3" class="settings-content">
      <div class="card">
        <h3 class="card-title">Billentyűkiosztás</h3>
        <p class="hint">Az alapértelmezett billentyűk a FiveM beállításokban módosíthatók (Settings > Key Bindings > FiveM).</p>
        <div class="keybind-list">
          <div v-for="bind in keybindList" :key="bind.id" class="keybind-row">
            <span class="bind-label">{{ bind.label }}</span>
            <span class="bind-key">{{ bind.default }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import SettingToggle from './settings/SettingToggle.vue'
import SettingSlider from './settings/SettingSlider.vue'
import SettingEnum from './settings/SettingEnum.vue'

const props = defineProps({
  settings: { type: Object, default: () => ({}) },
})

const activeTab = ref(0)
const s = ref({...props.settings})
watch(()=>props.settings, v=>{s.value={...v}}, {deep:true})

const categories = ['Megjelenés', 'Karakter', 'Hang', 'Irányítás']

const walkStyles = [
  'Magabiztos', 'Sietős', 'Részeg', 'Nehéz', 'Gengszter #1', 'Gengszter #2',
  'Gengszter #3', 'Hipszter', 'Rohanós', 'Sérült', 'Fenyegető', 'Gazdag',
  'Izmos', 'Elegáns', 'Gyors', 'Szomorú', 'Laza'
]

const chatAnims = [
  'Kéz a szájnál', 'Hello', 'Mutogat magára', 'Bólint', 'Mutat',
  'Vállat von (erős)', 'Vállat von (gyenge)', 'Integet', 'Miért?',
  'Pihenős #1', 'Pihenős #2', 'Véletlenszerű', 'Kikapcsolva'
]

const keybindList = [
  { id: 'voice', label: 'Voice (push-to-talk)', default: 'N' },
  { id: 'dashboard', label: 'Dashboard megnyitás', default: 'F1' },
  { id: 'animpanel', label: 'Animáció panel', default: 'F2' },
  { id: 'inventory', label: 'Inventory / Kiegészítők', default: 'F2 / TAB' },
  { id: 'seatbelt', label: 'Biztonsági öv', default: 'B' },
  { id: 'pointing', label: 'Mutatás', default: 'B' },
  { id: 'cruise', label: 'Tempomat', default: 'C' },
  { id: 'engine', label: 'Motor be/ki', default: 'M' },
  { id: 'lock', label: 'Jármű zárolás', default: 'L' },
]

function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}

function save(key, value){
  s.value[key] = value
  post('saveSetting',{key,value})
}

function setWalk(i){
  s.value.walkingStyle = i
  post('setWalkingStyle',{index:i})
  post('saveSetting',{key:'walkingStyle',value:i})
}
</script>

<style scoped>
.settings-tabs{display:flex;gap:4px;margin-bottom:14px;flex-wrap:wrap}
.tab-btn{padding:8px 14px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:12px;font-weight:700;cursor:pointer;transition:all .2s;text-transform:uppercase}
.tab-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.tab-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.settings-content{animation:fadeIn .2s ease}
@keyframes fadeIn{from{opacity:0;transform:translateY(5px)}to{opacity:1;transform:translateY(0)}}
.hint{color:var(--text-muted);font-size:11px;line-height:1.4;margin:4px 0 10px}
.style-grid{display:flex;flex-wrap:wrap;gap:5px;margin-top:6px}
.style-btn{padding:6px 11px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:11px;cursor:pointer;transition:all .2s;font-weight:600}
.style-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.style-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.keybind-list{display:flex;flex-direction:column;gap:2px;margin-top:8px}
.keybind-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--sightgrey3)}
.keybind-row:last-child{border-bottom:none}
.bind-label{font-size:13px;color:var(--text-secondary)}
.bind-key{padding:4px 12px;background:#fff;color:var(--sightgrey1);border-radius:3px;font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:.5px}
</style>
