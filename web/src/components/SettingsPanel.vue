<template>
  <div class="settings-panel">
    <div class="card">
      <h3 class="card-title">Karakter es jatekmenet</h3>
      <div class="setting-item">
        <span>Streamer mod</span>
        <label class="toggle">
          <input type="checkbox" :checked="settings.streamerMode" @change="save('streamerMode', $event.target.checked)" />
          <span class="toggle-slider"></span>
        </label>
      </div>
      <div class="setting-item">
        <span>HUD megjelenitese</span>
        <label class="toggle">
          <input type="checkbox" :checked="settings.hudVisible" @change="save('hudVisible', $event.target.checked)" />
          <span class="toggle-slider"></span>
        </label>
      </div>
      <div class="setting-item">
        <span>Nevek megjelenitese</span>
        <label class="toggle">
          <input type="checkbox" :checked="settings.nametagsVisible" @change="save('nametagsVisible', $event.target.checked)" />
          <span class="toggle-slider"></span>
        </label>
      </div>
    </div>

    <div class="card">
      <h3 class="card-title">Setastilus</h3>
      <div class="walking-styles">
        <button
          v-for="(style, i) in walkingStyles"
          :key="i"
          :class="['btn', settings.walkingStyle === (i+1) ? 'btn-green' : 'btn-blue']"
          @click="setWalking(i+1)"
        >{{ style.label }}</button>
      </div>
    </div>

    <div class="card">
      <h3 class="card-title">Hang</h3>
      <div class="setting-item">
        <span>Voice hangsuly</span>
        <input
          type="range"
          min="0"
          max="100"
          :value="settings.voiceVolume || 50"
          @input="save('voiceVolume', parseInt($event.target.value))"
          class="range-slider"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  settings: { type: Object, default: () => ({}) }
})

const walkingStyles = [
  { label: 'Stilus #1' }, { label: 'Stilus #2' }, { label: 'Stilus #3' },
  { label: 'Stilus #4' }, { label: 'Stilus #5' }, { label: 'Stilus #6' },
  { label: 'Stilus #7' }, { label: 'Stilus #8' }, { label: 'Stilus #9' },
  { label: 'Stilus #10' }, { label: 'Stilus #11' }, { label: 'Stilus #12' },
]

function save(key, value) {
  fetch(`https://${getResource()}/saveSetting`, { method: 'POST', body: JSON.stringify({ key, value }) })
}

function setWalking(index) {
  fetch(`https://${getResource()}/setWalkingStyle`, { method: 'POST', body: JSON.stringify({ index }) })
  save('walkingStyle', index)
}

function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
</script>

<style scoped>
.setting-item { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid var(--border-color); }
.setting-item:last-child { border-bottom: none; }
.setting-item span { font-size: 13px; color: var(--text-secondary); }
.toggle { position: relative; width: 44px; height: 24px; display: inline-block; }
.toggle input { opacity: 0; width: 0; height: 0; }
.toggle-slider { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: var(--bg-hover); border-radius: 12px; cursor: pointer; transition: 0.3s; }
.toggle-slider::before { content: ''; position: absolute; width: 18px; height: 18px; left: 3px; bottom: 3px; background: white; border-radius: 50%; transition: 0.3s; }
.toggle input:checked + .toggle-slider { background: var(--accent-green); }
.toggle input:checked + .toggle-slider::before { transform: translateX(20px); }
.walking-styles { display: flex; flex-wrap: wrap; gap: 6px; }
.range-slider { width: 150px; accent-color: var(--accent-green); }
</style>
