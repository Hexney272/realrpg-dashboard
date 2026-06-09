<template>
  <div class="settings-panel">
    <!-- Category tabs -->
    <div class="settings-tabs">
      <button v-for="(cat,i) in categories" :key="i" :class="['tab-btn',{active:activeTab===i}]" @click="activeTab=i">{{ cat.name }}</button>
    </div>

    <!-- 1. Megjelenés -->
    <div v-if="activeTab===0" class="settings-content">
      <div class="card">
        <h3 class="card-title">Megjelenés</h3>
        <SettingToggle label="Vignette effekt" :value="s.vignetteState" @change="v=>save('vignetteState',v)" />
        <SettingSlider label="Vignette erősség" :value="s.vignetteLevel||50" :min="0" :max="100" @change="v=>save('vignetteLevel',v)" />
        <div class="setting-separator"></div>
        <SettingToggle label="WonderLife grafika" :value="s.movieShaderState" @change="v=>save('movieShaderState',v)" />
        <SettingSlider label="Árnyalat (Hue)" :value="s.movieShaderHue||0" :min="0" :max="360" @change="v=>save('movieShaderHue',v)" />
        <SettingSlider label="Fényerő" :value="s.movieShaderBrightness||0" :min="-100" :max="100" @change="v=>save('movieShaderBrightness',v)" />
        <SettingSlider label="Kontraszt" :value="s.movieShaderContrast||50" :min="-100" :max="100" @change="v=>save('movieShaderContrast',v)" />
        <SettingSlider label="Telítettség" :value="s.movieShaderSaturation||50" :min="0" :max="100" @change="v=>save('movieShaderSaturation',v)" />
        <SettingSlider label="Vörös" :value="s.movieShaderR||50" :min="0" :max="100" @change="v=>save('movieShaderR',v)" />
        <SettingSlider label="Zöld" :value="s.movieShaderG||50" :min="0" :max="100" @change="v=>save('movieShaderG',v)" />
        <SettingSlider label="Kék" :value="s.movieShaderB||50" :min="0" :max="100" @change="v=>save('movieShaderB',v)" />
        <SettingSlider label="Fényesség" :value="s.movieShaderL||50" :min="0" :max="100" @change="v=>save('movieShaderL',v)" />
        <SettingSlider label="Zaj (noise)" :value="s.movieShaderNoise||0" :min="0" :max="100" @change="v=>save('movieShaderNoise',v)" />
        <div class="setting-separator"></div>
        <SettingToggle label="Mélységélesség (DOF)" :value="s.dofState" @change="v=>save('dofState',v)" />
        <SettingToggle label="Jármű tükröződés" :value="s.carPaint" @change="v=>save('carPaint',v)" />
        <SettingToggle label="Víz tükröződés" :value="s.osws" @change="v=>save('osws',v)" />
        <SettingToggle label="Napfény" :value="s.roadShine" @change="v=>save('roadShine',v)" />
        <SettingToggle label="Mozgási elmosódás" :value="s.radialBlur" @change="v=>save('radialBlur',v)" />
        <SettingToggle label="Vízcseppek" :value="s.waterEffects" @change="v=>save('waterEffects',v)" />
        <SettingToggle label="Környezet árnyékai (SSAO)" :value="s.ssaoEffects" @change="v=>save('ssaoEffects',v)" />
        <SettingToggle label="Hirdetőtáblák" :value="s.billboardState!==false" @change="v=>save('billboardState',v)" />
      </div>
    </div>

    <!-- 2. Színséma -->
    <div v-if="activeTab===1" class="settings-content">
      <div class="card">
        <h3 class="card-title">Színséma</h3>
        <p class="hint">Válaszd ki a kedvenc színsémádat a felület megjelenéséhez.</p>
        <div class="colorset-grid">
          <div v-for="(cs,i) in colorSets" :key="i" :class="['colorset-item',{active:s.colorSet===i}]" @click="save('colorSet',i)">
            <div class="colorset-preview" :style="{background:cs.gradient}"></div>
            <span class="colorset-name">{{ cs.name }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 3. Felület -->
    <div v-if="activeTab===2" class="settings-content">
      <div class="card">
        <h3 class="card-title">Felület</h3>
        <SettingToggle label="HUD megjelenítése" :value="s.hudVisible!==false" @change="v=>save('hudVisible',v)" />
        <SettingToggle label="Mozgó HUD" :value="s.hudMovement!==false" @change="v=>save('hudMovement',v)" />
        <div class="setting-separator"></div>
        <SettingEnum label="Radar ikonok színe" :value="s.blipColorState||0" :options="['Színes','Fehér','Fekete','Szürke']" @change="v=>save('blipColorState',v)" />
        <SettingToggle label="3D blipek megjelenítése" :value="s.blips3d!==false" @change="v=>save('blips3d',v)" />
        <SettingSlider label="3D blipek átlátszósága" :value="s.blips3dAlpha||200" :min="75" :max="255" @change="v=>save('blips3dAlpha',v)" />
        <div class="setting-separator"></div>
        <SettingEnum label="Kilométeróra mértékegység" :value="s.speedoUnit==='MPH'?1:0" :options="['KM/H','MPH']" @change="v=>save('speedoUnit',v===1?'MPH':'KM/H')" />
        <div class="setting-separator"></div>
        <SettingToggle label="Nevek megjelenítése" :value="s.nametagsVisible!==false" @change="v=>save('nametagsVisible',v)" />
        <SettingSlider label="Név méret" :value="s.nameSize||50" :min="0" :max="100" @change="v=>save('nameSize',v)" />
        <SettingSlider label="Név átlátszóság" :value="s.nameAlpha||200" :min="75" :max="255" @change="v=>save('nameAlpha',v)" />
        <div class="setting-separator"></div>
        <SettingToggle label="Rendszámtáblák megjelenítése" :value="s.platesVisible!==false" @change="v=>save('platesVisible',v)" />
        <SettingToggle label="Egységszámok megjelenítése" :value="s.squadsVisible" @change="v=>save('squadsVisible',v)" />
      </div>
    </div>

    <!-- 4. Chat -->
    <div v-if="activeTab===3" class="settings-content">
      <div class="card">
        <h3 class="card-title">Chat beállítások</h3>
        <SettingToggle label="Infoboxok kiírása chatre" :value="s.infoboxChat" @change="v=>save('infoboxChat',v)" />
        <SettingToggle label="Infoboxok hangja" :value="s.infoboxSound!==false" @change="v=>save('infoboxSound',v)" />
        <SettingToggle label="Kick üzenetek" :value="s.kickMessages" @change="v=>save('kickMessages',v)" />
        <div class="setting-separator"></div>
        <SettingToggle label="Frakció üzenetek" :value="s.groupMessages!==false" @change="v=>save('groupMessages',v)" />
        <SettingToggle label="/d2 megjelenítése" :value="s.d2State" @change="v=>save('d2State',v)" />
        <SettingToggle label="Légtér értesítések" :value="s.airfieldState" @change="v=>save('airfieldState',v)" />
        <SettingToggle label="Traffipax értesítések (Rendvédelem)" :value="s.togTraffi" @change="v=>save('togTraffi',v)" />
        <SettingToggle label="Határ értesítések (Rendvédelem)" :value="s.togHatar" @change="v=>save('togHatar',v)" />
        <div class="setting-separator"></div>
        <SettingToggle label="OOC Chat időbélyegek" :value="s.oocTimestamps" @change="v=>save('oocTimestamps',v)" />
      </div>
    </div>

    <!-- 5. Karakter és játékmenet -->
    <div v-if="activeTab===4" class="settings-content">
      <div class="card">
        <h3 class="card-title">Karakter és játékmenet</h3>
        <SettingSlider label="Látóhatár" :value="s.farClip||3000" :min="300" :max="6000" @change="v=>save('farClip',v)" />
        <SettingSlider label="Köd távolság" :value="s.fogDistance||2000" :min="10" :max="5000" @change="v=>save('fogDistance',v)" />
        <div class="setting-separator"></div>
        <SettingSlider label="Voice hangerő" :value="s.voiceVolume||50" :min="0" :max="100" @change="v=>save('voiceVolume',v)" />
        <div class="setting-separator"></div>
        <SettingEnum label="GPS hang" :value="gpsSoundIndex" :options="['Női','Férfi','Kikapcsolva']" @change="v=>save('gpsSoundPack',['Női','Férfi','Kikapcsolva'][v])" />
        <div class="setting-separator"></div>
        <SettingToggle label="Streamer mód" :value="s.streamerMode" @change="v=>save('streamerMode',v)" />
        <p class="hint" style="margin:4px 0 10px">Streamer módban az összes jogvédett zene lenémításra kerül.</p>
        <div class="setting-separator"></div>
        <div class="setting-section-label">Sétastílus</div>
        <div class="style-grid">
          <button v-for="(st,i) in 17" :key="i" :class="['style-btn',{active:(s.walkingStyle||1)===(i+1)}]" @click="setWalk(i+1)">Stílus #{{ i+1 }}</button>
        </div>
        <div class="setting-section-label" style="margin-top:12px">Harcstílus</div>
        <div class="style-grid">
          <button v-for="(fs,i) in fightStyles" :key="i" :class="['style-btn',{active:(s.fightStyle||0)===i}]" @click="save('fightStyle',i)">{{ fs }}</button>
        </div>
        <div class="setting-section-label" style="margin-top:12px">Beszéd animáció</div>
        <div class="style-grid">
          <button v-for="i in 13" :key="i" :class="['style-btn',{active:(s.chatAnim||1)===i}]" @click="save('chatAnim',i)">{{ i<=11?'Anim #'+i : i===12?'Random':'Ki' }}</button>
        </div>
        <div class="setting-separator"></div>
        <SettingSlider label="First Person magasság" :value="s.fpHeight||50" :min="0" :max="100" @change="v=>save('fpHeight',v)" />
        <SettingSlider label="First Person magasság járműben" :value="s.fpHeightCar||50" :min="0" :max="100" @change="v=>save('fpHeightCar',v)" />
        <SettingSlider label="First Person egérérzékenység" :value="s.fpMouseSens||50" :min="0" :max="100" @change="v=>save('fpMouseSens',v)" />
      </div>
    </div>

    <!-- 6. Irányítás -->
    <div v-if="activeTab===5" class="settings-content">
      <div class="card">
        <h3 class="card-title">Irányítás (Billentyűkiosztás)</h3>
        <p class="hint">A billentyűk módosításához kattints a gombra, majd nyomd meg az új billentyűt.</p>
        <div class="keybind-list">
          <div v-for="bind in keybinds" :key="bind.id" class="keybind-row">
            <span class="bind-label">{{ bind.label }}</span>
            <button class="bind-btn" @click="startRebind(bind)">
              {{ getBindDisplay(bind) }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import SettingToggle from './settings/SettingToggle.vue'
import SettingSlider from './settings/SettingSlider.vue'
import SettingEnum from './settings/SettingEnum.vue'

const props = defineProps({
  settings: { type: Object, default: () => ({}) },
  keybinds: { type: Array, default: () => [] }
})

const activeTab = ref(0)
const s = ref({...props.settings})
watch(()=>props.settings, v=>{s.value={...v}}, {deep:true})

const categories = [
  { name: 'Megjelenés' },
  { name: 'Színséma' },
  { name: 'Felület' },
  { name: 'Chat' },
  { name: 'Karakter' },
  { name: 'Irányítás' },
]

const fightStyles = ['Normál','Boksz','MMA','Utcai','Karate']

const colorSets = [
  { name: 'Zöld (alapértelmezett)', gradient: 'linear-gradient(135deg, #1a1a24, #4ae06c)' },
  { name: 'Kék', gradient: 'linear-gradient(135deg, #1a1a24, #4a9ef5)' },
  { name: 'Piros', gradient: 'linear-gradient(135deg, #1a1a24, #f54a4a)' },
  { name: 'Sárga', gradient: 'linear-gradient(135deg, #1a1a24, #f5d44a)' },
  { name: 'Narancssárga', gradient: 'linear-gradient(135deg, #1a1a24, #f5944a)' },
  { name: 'Lila', gradient: 'linear-gradient(135deg, #1a1a24, #a855f7)' },
  { name: 'Cián', gradient: 'linear-gradient(135deg, #1a1a24, #22d3ee)' },
  { name: 'Rózsaszín', gradient: 'linear-gradient(135deg, #1a1a24, #ec4899)' },
]

const gpsSoundIndex = computed(()=>{
  const v = s.value.gpsSoundPack || 'Női'
  if(v==='Férfi') return 1
  if(v==='Kikapcsolva') return 2
  return 0
})

const keybinds = computed(()=>props.keybinds.length ? props.keybinds : [
  { id:'voice', label:'Voice egyedi nyomógomb', default:'Q' },
  { id:'animcircle', label:'Animációk gyors elérése', default:'MOUSE3' },
  { id:'animpanel', label:'Animáció lista', default:'F2' },
  { id:'cuccaim', label:'Kiegészítők', default:'F9' },
  { id:'pointing', label:'Mutatás', default:'X' },
  { id:'tempotoggle', label:'Tempomat be/ki', default:'C' },
  { id:'tempoup', label:'Tempomat sebesség +', default:'NUM+' },
  { id:'tempodown', label:'Tempomat sebesség -', default:'NUM-' },
  { id:'activespoiler', label:'Active Spoiler', default:'NUM5' },
  { id:'seatbelt', label:'Biztonsági öv', default:'F5' },
  { id:'downshift', label:'Sebességváltó -', default:'LCTRL' },
  { id:'upshift', label:'Sebességváltó +', default:'LSHIFT' },
  { id:'togcursor', label:'Kurzor mód (nyomva tartva)', default:'LALT' },
  { id:'pullkey', label:'Pullozás', default:'X' },
  { id:'sirenKey', label:'Villogó', default:'P' },
])

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

function getBindDisplay(bind){
  return s.value['bind_'+bind.id] || bind.default || '—'
}

function startRebind(bind){
  // In FiveM NUI we can't directly capture keys, so we send to client
  post('startKeybind',{bindId:bind.id})
}
</script>

<style scoped>
.settings-tabs{display:flex;gap:4px;margin-bottom:14px;flex-wrap:wrap}
.tab-btn{padding:8px 14px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:12px;font-weight:700;cursor:pointer;transition:all .2s;text-transform:uppercase}
.tab-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.tab-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.settings-content{animation:fadeIn .2s ease}
@keyframes fadeIn{from{opacity:0;transform:translateY(5px)}to{opacity:1;transform:translateY(0)}}
.setting-separator{height:1px;background:var(--sightgrey3);margin:10px 0}
.setting-section-label{font-size:12px;font-weight:700;color:var(--sightgreen);text-transform:uppercase;margin-bottom:6px;letter-spacing:.5px}
.hint{color:var(--text-secondary);font-size:11px;line-height:1.4}
.style-grid{display:flex;flex-wrap:wrap;gap:5px}
.style-btn{padding:5px 10px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:10px;cursor:pointer;transition:all .2s;font-weight:600}
.style-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.style-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.colorset-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:8px;margin-top:10px}
.colorset-item{padding:8px;border:2px solid var(--sightgrey3);border-radius:4px;cursor:pointer;transition:all .2s;text-align:center}
.colorset-item:hover{border-color:var(--sightgreen)}
.colorset-item.active{border-color:var(--sightgreen);box-shadow:0 0 10px rgba(74,224,108,.3)}
.colorset-preview{height:32px;border-radius:3px;margin-bottom:6px}
.colorset-name{font-size:11px;color:var(--text-secondary);font-weight:600}
.keybind-list{display:flex;flex-direction:column;gap:4px}
.keybind-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--sightgrey3)}
.keybind-row:last-child{border-bottom:none}
.bind-label{font-size:12px;color:var(--text-secondary)}
.bind-btn{padding:5px 12px;background:#fff;color:var(--sightgrey1);border:none;border-radius:3px;font-size:12px;font-weight:800;cursor:pointer;min-width:60px;text-align:center;text-transform:uppercase;transition:all .2s}
.bind-btn:hover{background:var(--sightgreen);color:#000}
</style>
