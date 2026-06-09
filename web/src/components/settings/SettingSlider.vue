<template>
  <div class="setting-item">
    <span class="slider-label">{{ label }}</span>
    <div class="slider-right">
      <input type="range" :min="min" :max="max" :value="value" @input="$emit('change',+$event.target.value)" class="range"/>
      <span class="range-val">{{ value }}</span>
    </div>
  </div>
</template>
<script setup>
defineProps({ label: String, value: Number, min: { type: Number, default: 0 }, max: { type: Number, default: 100 } })
defineEmits(['change'])
</script>
<style scoped>
.setting-item{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--sightgrey3);font-size:13px;color:var(--text-secondary);gap:12px}
.slider-label{white-space:nowrap;min-width:120px}
.slider-right{display:flex;align-items:center;gap:8px;flex:1;justify-content:flex-end}
.range{width:120px;accent-color:var(--sightgreen);height:4px}
.range-val{color:var(--sightgreen);font-weight:700;font-size:12px;min-width:36px;text-align:right}
</style>
