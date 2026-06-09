<template>
  <div class="setting-item">
    <span>{{ label }}</span>
    <div class="enum-buttons">
      <button v-for="(opt,i) in options" :key="i" :class="['enum-btn',{active:value===i}]" @click="$emit('change',i)">{{ opt }}</button>
    </div>
  </div>
</template>
<script setup>
defineProps({ label: String, value: Number, options: Array })
defineEmits(['change'])
</script>
<style scoped>
.setting-item{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--sightgrey3);font-size:13px;color:var(--text-secondary);gap:10px;flex-wrap:wrap}
.enum-buttons{display:flex;gap:4px;flex-wrap:wrap}
.enum-btn{padding:4px 10px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-muted);border-radius:3px;font-size:11px;cursor:pointer;transition:all .2s;font-weight:600}
.enum-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.enum-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
</style>
