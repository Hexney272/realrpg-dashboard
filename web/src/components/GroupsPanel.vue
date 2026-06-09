<template>
  <div class="groups-panel">
    <div v-if="groups.length === 0" class="empty-state card">
      <p>Nem vagy egyetlen frakcio tagja sem.</p>
    </div>
    <div v-else>
      <div v-for="group in groups" :key="group.id" class="card">
        <h3 class="card-title">{{ group.name }}</h3>
        <div class="stat-row"><span class="stat-label">Rangod:</span><span class="stat-value">{{ group.rank }}</span></div>
        <div class="stat-row"><span class="stat-label">Tagok:</span><span class="stat-value">{{ group.memberCount }}</span></div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({ groups: { type: Array, default: () => [] } })
</script>

<style scoped>
.empty-state { text-align: center; color: var(--text-muted); padding: 40px; }
</style>
