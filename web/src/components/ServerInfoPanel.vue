<template>
  <div class="serverinfo-panel">
    <div class="grid-2">
      <!-- Server stats widget -->
      <div class="card">
        <h3 class="card-title">Szerver információ</h3>
        <div class="stat-row"><span class="stat-label">Szerver név:</span><span class="stat-value">RealRPG</span></div>
        <div class="stat-row"><span class="stat-label">Online játékosok:</span><span class="stat-value" style="color:var(--sightgreen)">{{ onlinePlayers }}/{{ maxPlayers }}</span></div>
        <div class="stat-row"><span class="stat-label">A te Server ID-d:</span><span class="stat-value">{{ myId }}</span></div>
        <div class="stat-row"><span class="stat-label">Ping:</span><span :class="['stat-value', pingColor(myPing)]">{{ myPing }}ms</span></div>
        <div class="stat-row"><span class="stat-label">Uptime:</span><span class="stat-value">{{ formatUptime(uptime) }}</span></div>
      </div>

      <!-- Quick stats -->
      <div class="card">
        <h3 class="card-title">Gyors statisztikák</h3>
        <div class="quick-stats">
          <div class="qstat">
            <span class="qstat-value">{{ formatNumber(totalVehicles) }}</span>
            <span class="qstat-label">Járműveid</span>
          </div>
          <div class="qstat">
            <span class="qstat-value">{{ formatNumber(totalProperties) }}</span>
            <span class="qstat-label">Ingatlanok</span>
          </div>
          <div class="qstat">
            <span class="qstat-value">{{ formatNumber(totalMoney) }}</span>
            <span class="qstat-label">Összvagyon ($)</span>
          </div>
          <div class="qstat">
            <span class="qstat-value blue">{{ formatNumber(premiumPoints) }}</span>
            <span class="qstat-label">Prémium pont</span>
          </div>
        </div>
      </div>

      <!-- Weather (extra feature) -->
      <div class="card">
        <h3 class="card-title">Időjárás & Idő</h3>
        <div class="weather-row">
          <span class="weather-icon">{{ weatherIcon }}</span>
          <div class="weather-info">
            <span class="weather-name">{{ weatherName }}</span>
            <span class="weather-time">Játék idő: {{ gameTime }}</span>
          </div>
        </div>
      </div>

      <!-- Daily tips -->
      <div class="card">
        <h3 class="card-title">Napi tipp</h3>
        <p class="tip-text">{{ dailyTip }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
const props = defineProps({
  data: { type: Object, default: () => ({}) },
  weather: { type: Object, default: () => ({}) },
})

const onlinePlayers = computed(() => props.data.onlinePlayers || 0)
const maxPlayers = computed(() => props.data.maxPlayers || 64)
const myId = computed(() => props.data.serverId || 0)
const myPing = computed(() => props.data.ping || 0)
const uptime = computed(() => props.data.uptime || 0)
const totalVehicles = computed(() => props.data.vehicleCount || 0)
const totalProperties = computed(() => props.data.interiorCount || 0)
const totalMoney = computed(() => (props.data.money || 0) + (props.data.bankMoney || 0))
const premiumPoints = computed(() => props.data.premiumBalance || 0)

const weatherName = computed(() => props.weather.name || 'Napos')
const gameTime = computed(() => props.weather.time || '12:00')
const weatherIcon = computed(() => {
  const icons = { CLEAR: '☀️', CLOUDS: '☁️', RAIN: '🌧️', THUNDER: '⛈️', SNOW: '❄️', FOG: '🌫️', OVERCAST: '🌥️', CLEARING: '🌤️' }
  return icons[props.weather.type] || '☀️'
})

const tips = [
  'Használd a /gps parancsot a legközelebbi garázs megtalálásához!',
  'A streamer mód aktiválásával elrejtheted a szenzitív adataidat.',
  'Premium pontokkal jármű slotokat vásárolhatsz a dashboardon!',
  'A frakciódban a rangod határozza meg a jogosultságaidat.',
  'Mentsd el a kedvenc séta stílusodat a beállításokban!',
  'A járműveid GPS-en megjelölhetők ha világban vannak.',
  'Report-ot írhatsz ha bármilyen szabálysértést tapasztalsz.',
  'A meghívó kódoddal prémium pontokat szerezhetsz!',
]
const dailyTip = tips[Math.floor(Math.random() * tips.length)]

function formatNumber(n) { return (n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') }
function formatUptime(seconds) {
  if (!seconds) return '—'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  return `${h} óra ${m} perc`
}
function pingColor(p) {
  if (p < 60) return ''
  if (p < 120) return 'yellow'
  return 'red'
}
</script>

<style scoped>
.weather-row{display:flex;align-items:center;gap:14px;padding:10px 0}
.weather-icon{font-size:40px}
.weather-info{display:flex;flex-direction:column}
.weather-name{font-size:16px;font-weight:700}
.weather-time{font-size:12px;color:var(--text-muted)}
.quick-stats{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:8px}
.qstat{text-align:center;padding:12px;background:var(--sightgrey1);border-radius:4px}
.qstat-value{display:block;font-size:22px;font-weight:800;color:var(--sightgreen);margin-bottom:2px}
.qstat-value.blue{color:var(--sightblue)}
.qstat-label{font-size:11px;color:var(--text-muted);text-transform:uppercase;letter-spacing:.3px}
.tip-text{font-size:13px;color:var(--text-secondary);line-height:1.6;font-style:italic;padding:8px 0}
</style>
