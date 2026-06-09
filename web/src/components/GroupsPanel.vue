<template>
  <div class="groups-panel">
    <div v-if="!groups.length" class="empty-state card">Nem vagy egy frakció tagja sem!</div>
    <div v-else class="grid-2">
      <div v-for="g in groups" :key="g.id" class="card">
        <h3 class="card-title">{{ g.name }}</h3>
        <div class="stat-row"><span class="stat-label">Rangod:</span><span class="stat-value">{{ g.rank }}</span></div>
        <div class="stat-row"><span class="stat-label">Tagok:</span><span class="stat-value">{{ g.memberCount }}</span></div>
      </div>
    </div>
  </div>
</template>
<script setup>
defineProps({groups:{type:Array,default:()=>[]}})
</script>
