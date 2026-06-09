<template>
  <div class="character-panel">
    <div class="grid-2">
      <div class="card">
        <h3 class="card-title">Karakter adatok</h3>
        <div class="stat-row">
          <span class="stat-label">Nev:</span>
          <span class="stat-value">{{ data.name || 'N/A' }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Account ID:</span>
          <span class="stat-value">{{ data.accountId || 0 }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Karakter ID:</span>
          <span class="stat-value">{{ data.characterId || 0 }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Szint:</span>
          <span class="stat-value">LVL {{ data.level || 1 }}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Jatszott ido:</span>
          <span class="stat-value">{{ formatMinutes(data.playedMinutes) }}</span>
        </div>
      </div>

      <div class="card">
        <h3 class="card-title">Penzugyek</h3>
        <div class="stat-row">
          <span class="stat-label">Keszpenz:</span>
          <span :class="['stat-value', (data.money || 0) < 0 ? 'red' : '']">
            {{ formatNumber(data.money || 0) }} $
          </span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Banki egyenleg:</span>
          <span :class="['stat-value', (data.bankMoney || 0) < 0 ? 'red' : '']">
            {{ formatNumber(data.bankMoney || 0) }} $
          </span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Premium pont:</span>
          <span class="stat-value blue">{{ formatNumber(data.premiumBalance || 0) }} PP</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Jarmuvek:</span>
          <span class="stat-value">{{ data.vehicleCount || 0 }} db</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Interiorok:</span>
          <span class="stat-value">{{ data.interiorCount || 0 }} db</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  data: { type: Object, default: () => ({}) }
})

function formatNumber(num) {
  if (!num) return '0'
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

function formatMinutes(minutes) {
  if (!minutes) return '0 perc'
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  if (hours > 0) return `${formatNumber(hours)} ora ${mins} perc`
  return `${mins} perc`
}
</script>
