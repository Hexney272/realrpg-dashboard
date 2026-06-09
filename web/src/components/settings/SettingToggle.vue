<template>
  <div class="setting-item">
    <span>{{ label }}</span>
    <label class="toggle">
      <input type="checkbox" :checked="value" @change="$emit('change',$event.target.checked)"/>
      <span class="slider"></span>
    </label>
  </div>
</template>
<script setup>
defineProps({ label: String, value: Boolean })
defineEmits(['change'])
</script>
<style scoped>
.setting-item{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--sightgrey3);font-size:13px;color:var(--text-secondary)}
.setting-item:last-child{border-bottom:none}
.toggle{position:relative;width:40px;height:22px;display:inline-block;flex-shrink:0}
.toggle input{opacity:0;width:0;height:0}
.slider{position:absolute;top:0;left:0;right:0;bottom:0;background:var(--sightgrey4);border-radius:11px;cursor:pointer;transition:.3s}
.slider::before{content:'';position:absolute;width:16px;height:16px;left:3px;bottom:3px;background:#fff;border-radius:50%;transition:.3s}
.toggle input:checked+.slider{background:var(--sightgreen)}
.toggle input:checked+.slider::before{transform:translateX(18px)}
</style>
