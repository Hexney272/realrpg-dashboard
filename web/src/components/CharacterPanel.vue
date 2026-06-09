<template>
  <div class="character-panel">
    <div class="grid-2">
      <!-- Left: Character Info -->
      <div class="card">
        <h3 class="card-title">Karakter információk</h3>
        <div class="char-name-row">
          <span class="char-name">{{ data.name || 'N/A' }}</span>
        </div>
        <div class="stat-row"><span class="stat-label">Account ID:</span><span class="stat-value">{{ data.accountId || 0 }}</span></div>
        <div class="stat-row"><span class="stat-label">Karakter ID:</span><span class="stat-value">{{ data.characterId || 0 }}</span></div>
        <div class="stat-row"><span class="stat-label">Játszott percek:</span><span class="stat-value">{{ fmt(data.playedMinutes || 0) }} ({{ fmt(Math.floor((data.playedMinutes||0)/60)) }} óra)</span></div>
        <div class="stat-row"><span class="stat-label">Szint:</span><span class="stat-value">LVL {{ data.level || 1 }}</span></div>
        <div class="stat-row"><span class="stat-label">Járművek száma:</span><span class="stat-value">{{ data.vehicleCount || 0 }} db</span></div>
        <div class="stat-row"><span class="stat-label">Interiorok száma:</span><span class="stat-value">{{ data.interiorCount || 0 }} db</span></div>
        <div class="stat-row"><span class="stat-label">Készpénz:</span><span :class="['stat-value',(data.money||0)<0?'red':'']">{{ fmt(data.money || 0) }} $</span></div>
        <div class="stat-row"><span class="stat-label">Banki egyenleg:</span><span :class="['stat-value',(data.bankMoney||0)<0?'red':'']">{{ fmt(data.bankMoney || 0) }} $</span></div>
      </div>

      <!-- Right: Extra details -->
      <div>
        <div class="card">
          <h3 class="card-title">Prémium</h3>
          <div class="pp-big-row">
            <span class="pp-big-value">{{ fmt(data.premiumBalance || 0) }}</span>
            <span class="pp-big-label">PP</span>
          </div>
        </div>

        <div class="card">
          <h3 class="card-title">Stílusok</h3>
          <div class="stat-row"><span class="stat-label">Sétastílus:</span><span class="stat-value">{{ walkingStyleLabel }}</span></div>
          <div class="stat-row"><span class="stat-label">Harcstílus:</span><span class="stat-value">{{ fightStyleLabel }}</span></div>
          <div class="stat-row"><span class="stat-label">Beszéd animáció:</span><span class="stat-value">{{ chatAnimLabel }}</span></div>
        </div>

        <div class="card">
          <h3 class="card-title">Szerver infó</h3>
          <div class="stat-row"><span class="stat-label">Server ID:</span><span class="stat-value">{{ data.serverId || '-' }}</span></div>
          <div class="stat-row"><span class="stat-label">Kapcsolat:</span><span class="stat-value" style="color:var(--sightgreen)">Online</span></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { computed } from 'vue'
const props = defineProps({ data: { type: Object, default: () => ({}) } })

function fmt(n) { return (n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') }

const walkingStyleLabel = computed(() => {
  const idx = props.data.walkingStyle || 1
  return `Stílus #${idx}`
})

const fightStyleLabel = computed(() => {
  const styles = ['Normál','Boksz','MMA','Utcai','Karate']
  return styles[props.data.fightStyle || 0] || 'Normál'
})

const chatAnimLabel = computed(() => {
  const idx = props.data.chatAnim || 1
  if (idx >= 12) return 'Véletlenszerű'
  if (idx >= 13) return 'Kikapcsolva'
  return `Animáció #${idx}`
})
</script>
<style scoped>
.char-name-row{margin-bottom:12px}
.char-name{font-size:20px;font-weight:800;color:var(--sightgreen);text-transform:uppercase}
.pp-big-row{display:flex;align-items:baseline;gap:8px;padding:10px 0}
.pp-big-value{font-size:32px;font-weight:800;color:var(--sightblue)}
.pp-big-label{font-size:16px;font-weight:600;color:var(--sightblue);opacity:.7}
</style>
