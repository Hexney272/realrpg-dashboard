<template>
  <div class="character-panel">
    <div class="grid-2">
      <div class="card">
        <h3 class="card-title">Karakter adatok</h3>
        <div class="stat-row"><span class="stat-label">Név:</span><span class="stat-value">{{ data.name || 'N/A' }}</span></div>
        <div class="stat-row"><span class="stat-label">Account ID:</span><span class="stat-value">{{ data.accountId || 0 }}</span></div>
        <div class="stat-row"><span class="stat-label">Karakter ID:</span><span class="stat-value">{{ data.characterId || 0 }}</span></div>
        <div class="stat-row"><span class="stat-label">Szint:</span><span class="stat-value">LVL {{ data.level || 1 }}</span></div>
        <div class="stat-row"><span class="stat-label">Játszott idő:</span><span class="stat-value">{{ formatMinutes(data.playedMinutes) }}</span></div>
        <div class="stat-row"><span class="stat-label">Járművek:</span><span class="stat-value">{{ data.vehicleCount || 0 }} db</span></div>
        <div class="stat-row"><span class="stat-label">Interiorok:</span><span class="stat-value">{{ data.interiorCount || 0 }} db</span></div>
      </div>
      <div class="card">
        <h3 class="card-title">Pénzügyek</h3>
        <div class="stat-row">
          <span class="stat-label">Készpénz:</span>
          <span :class="['stat-value', (data.money||0) < 0 ? 'red' : '']">{{ formatNumber(data.money || 0) }} $</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Banki egyenleg:</span>
          <span :class="['stat-value', (data.bankMoney||0) < 0 ? 'red' : '']">{{ formatNumber(data.bankMoney || 0) }} $</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Prémium pont:</span>
          <span class="stat-value blue">{{ formatNumber(data.premiumBalance || 0) }} PP</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
defineProps({ data: { type: Object, default: () => ({}) } })
function formatNumber(n) { return (n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') }
function formatMinutes(m) { if(!m) return '0 perc'; const h=Math.floor(m/60); return h>0 ? `${formatNumber(h)} óra ${m%60} perc` : `${m} perc` }
</script>
