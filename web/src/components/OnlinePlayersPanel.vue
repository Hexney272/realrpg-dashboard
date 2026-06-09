<template>
  <div class="online-panel">
    <div class="panel-top">
      <span class="online-count">Online: <strong>{{ players.length }}/{{ maxPlayers }}</strong></span>
      <input v-model="search" class="input-field search-input" placeholder="Keresés név/ID alapján..." />
    </div>

    <div class="player-list">
      <div class="list-header">
        <span class="col-id">ID</span>
        <span class="col-name">Név</span>
        <span class="col-job">Munkahely</span>
        <span class="col-ping">Ping</span>
      </div>
      <div v-for="p in filteredPlayers" :key="p.id" class="player-row">
        <span class="col-id">{{ p.id }}</span>
        <span class="col-name">{{ p.name }}</span>
        <span class="col-job">{{ p.job }}</span>
        <span :class="['col-ping', pingColor(p.ping)]">{{ p.ping }}ms</span>
      </div>
      <div v-if="!filteredPlayers.length" class="empty-state">Nincs találat.</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({
  players: { type: Array, default: () => [] },
  maxPlayers: { type: Number, default: 64 }
})

const search = ref('')

const filteredPlayers = computed(() => {
  if (!search.value) return props.players
  const q = search.value.toLowerCase()
  return props.players.filter(p =>
    p.name.toLowerCase().includes(q) ||
    String(p.id).includes(q) ||
    (p.job || '').toLowerCase().includes(q)
  )
})

function pingColor(ping) {
  if (ping < 60) return 'ping-good'
  if (ping < 120) return 'ping-ok'
  return 'ping-bad'
}
</script>

<style scoped>
.panel-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;gap:12px;flex-wrap:wrap}
.online-count{font-size:14px;color:var(--text-secondary);text-transform:uppercase;letter-spacing:.5px}
.online-count strong{color:var(--sightgreen)}
.search-input{max-width:250px}
.player-list{display:flex;flex-direction:column;gap:2px;max-height:55vh;overflow-y:auto}
.list-header,.player-row{display:grid;grid-template-columns:50px 1fr 1fr 70px;padding:8px 12px;font-size:12px;align-items:center}
.list-header{background:var(--sightgrey3);border-radius:3px;font-weight:700;color:var(--text-muted);text-transform:uppercase;font-size:11px;letter-spacing:.5px}
.player-row{background:var(--sightgrey1);border-radius:2px;transition:background .15s}
.player-row:hover{background:var(--sightgrey3)}
.col-id{color:var(--sightblue);font-weight:700}
.col-name{font-weight:600}
.col-job{color:var(--text-secondary);font-size:11px}
.col-ping{font-weight:700;text-align:right}
.ping-good{color:var(--sightgreen)}
.ping-ok{color:var(--sightyellow)}
.ping-bad{color:var(--sightred)}
</style>
