<template>
  <div id="dashboard-app" v-show="isOpen" @keydown.escape="closeDashboard">
    <div class="dashboard-overlay" @click="closeDashboard"></div>

    <!-- Main Dashboard Grid -->
    <div class="dashboard-wrapper" :class="{ 'has-expanded': expandedCard !== null }">
      <!-- Top bar with player info -->
      <div class="top-bar" v-show="expandedCard === null">
        <div class="top-left">
          <span class="server-name">RealRPG</span>
          <span class="divider">|</span>
          <span class="player-name">{{ playerData.name || 'Betöltés...' }}</span>
        </div>
        <div class="top-right">
          <span class="pp-badge">{{ formatNumber(playerData.premiumBalance || 0) }} PP</span>
          <button class="close-x" @click="closeDashboard">&times;</button>
        </div>
      </div>

      <!-- Grid Layout (6 columns x 4 rows concept) -->
      <transition-group name="grid-fade" tag="div" class="dashboard-grid" v-show="expandedCard === null">
        <div
          v-for="card in gridCards"
          :key="card.id"
          :class="['grid-card', `span-${card.colSpan}x${card.rowSpan}`, card.bgClass || '']"
          :style="cardStyle(card)"
          @click="openCard(card)"
          @mouseenter="hoverCard = card.id"
          @mouseleave="hoverCard = null"
        >
          <!-- Card Background Image -->
          <div v-if="card.bgImage" class="card-bg" :style="{ backgroundImage: `url(${card.bgImage})` }"></div>

          <!-- Card Overlay -->
          <div class="card-overlay" :class="{ hovered: hoverCard === card.id }">
            <!-- Top Labels -->
            <div class="card-top-labels">
              <span class="label-bold">{{ card.topLabel1 }}</span>
              <span class="label-light" v-if="card.topLabel2">{{ card.topLabel2 }}</span>
            </div>

            <!-- Bottom Info (drawn by drawFunction equivalent) -->
            <div class="card-bottom-info" v-if="card.bottomInfo">
              <span class="bottom-label">{{ card.bottomLabel }}</span>
              <span class="bottom-value">{{ card.bottomValue }}</span>
            </div>

            <!-- Corner background decoration -->
            <div v-if="card.cornerBg" class="card-corner-bg"></div>
          </div>

          <!-- Hover shine effect -->
          <div class="card-shine" :class="{ active: hoverCard === card.id }"></div>
        </div>
      </transition-group>

      <!-- Expanded Card (fullscreen panel) -->
      <transition name="expand">
        <div v-if="expandedCard" class="expanded-panel">
          <div class="expanded-header">
            <button class="back-btn" @click="closeExpanded">
              <span class="back-arrow">&larr;</span>
              <span>Vissza</span>
            </button>
            <h2 class="expanded-title">{{ expandedCard.topLabel1 }}{{ expandedCard.topLabel2 ? ' ' + expandedCard.topLabel2 : '' }}</h2>
          </div>
          <div class="expanded-content">
            <CharacterPanel v-if="expandedCard.id === 'character'" :data="playerData" />
            <VehiclesPanel v-if="expandedCard.id === 'vehicles'" :vehicles="vehicles" :limit="vehicleLimit" />
            <InteriorsPanel v-if="expandedCard.id === 'interiors'" :interiors="interiors" :limit="interiorLimit" />
            <AnimalsPanel v-if="expandedCard.id === 'animals'" :animals="animals" />
            <GroupsPanel v-if="expandedCard.id === 'groups'" :groups="groups" />
            <SettingsPanel v-if="expandedCard.id === 'settings'" :settings="settings" :keybinds="keybinds" />
            <PremiumShopPanel v-if="expandedCard.id === 'shop'" :shop="premiumShop" :balance="playerData.premiumBalance || 0" />
            <NewsPanel v-if="expandedCard.id === 'news'" :news="news" />
            <AdminPanel v-if="expandedCard.id === 'admins'" :admins="admins" />
            <InvitePanel v-if="expandedCard.id === 'invite'" :inviteCode="inviteCode" :invitedPlayers="invitedPlayers" :awards="awards" />
          </div>
        </div>
      </transition>
    </div>

    <!-- Notifications -->
    <div class="notifications">
      <transition-group name="notify">
        <div
          v-for="notif in notifications"
          :key="notif.id"
          :class="['notification', notif.type]"
        >
          {{ notif.message }}
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import CharacterPanel from './components/CharacterPanel.vue'
import VehiclesPanel from './components/VehiclesPanel.vue'
import InteriorsPanel from './components/InteriorsPanel.vue'
import AnimalsPanel from './components/AnimalsPanel.vue'
import GroupsPanel from './components/GroupsPanel.vue'
import SettingsPanel from './components/SettingsPanel.vue'
import PremiumShopPanel from './components/PremiumShopPanel.vue'
import NewsPanel from './components/NewsPanel.vue'
import AdminPanel from './components/AdminPanel.vue'
import InvitePanel from './components/InvitePanel.vue'

const isOpen = ref(false)
const expandedCard = ref(null)
const hoverCard = ref(null)
const playerData = ref({})
const vehicles = ref([])
const vehicleLimit = ref(5)
const interiors = ref([])
const interiorLimit = ref(3)
const animals = ref([])
const groups = ref([])
const settings = ref({})
const premiumShop = ref([])
const news = ref({})
const admins = ref([])
const inviteCode = ref('')
const invitedPlayers = ref([])
const awards = ref([])
const keybinds = ref([])
const notifications = ref([])

// Grid cards layout - mimicking the MTA 6x4 grid with images
const gridCards = computed(() => [
  {
    id: 'character',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Üdvözlünk',
    topLabel2: playerData.value.name || '',
    bgClass: 'bg-green-gradient',
    bottomInfo: true,
    bottomLabel: 'Szint:',
    bottomValue: 'LVL ' + (playerData.value.level || 1),
  },
  {
    id: 'shop',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Prémium',
    topLabel2: 'shop',
    bgClass: 'bg-blue-accent',
    bgImage: './img/pp_bcg.png',
    bottomInfo: true,
    bottomLabel: 'Egyenleg:',
    bottomValue: formatNumber(playerData.value.premiumBalance || 0) + ' PP',
  },
  {
    id: 'settings',
    colSpan: 1, rowSpan: 1,
    topLabel1: 'Beállítások',
    topLabel2: '',
    bgClass: 'bg-dark-card',
    bgImage: './img/settings_bcg.png',
  },
  {
    id: 'news',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Hírek',
    topLabel2: '',
    bgClass: 'bg-news',
    bgImage: './img/def.png',
    bottomInfo: true,
    bottomLabel: news.value.title || '',
    bottomValue: news.value.date || '',
  },
  {
    id: 'groups',
    colSpan: 1, rowSpan: 1,
    topLabel1: 'Frakciók',
    topLabel2: '',
    bgClass: 'bg-dark-card',
    bgImage: './img/groups_bcg.png',
  },
  {
    id: 'interiors',
    colSpan: 2, rowSpan: 2,
    topLabel1: 'Interiorok',
    topLabel2: '',
    bgClass: 'bg-interior',
    bgImage: './img/inti/interior_render1.png',
    bottomInfo: true,
    bottomLabel: 'Slotok:',
    bottomValue: interiorLimit.value.toString(),
  },
  {
    id: 'vehicles',
    colSpan: 2, rowSpan: 2,
    topLabel1: 'Járművek:',
    topLabel2: (vehicles.value.length || 0).toString(),
    bgClass: 'bg-vehicle',
    bgImage: './img/fado2.png',
    bottomInfo: true,
    bottomLabel: 'Slotok:',
    bottomValue: vehicleLimit.value.toString(),
  },
  {
    id: 'admins',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Report',
    topLabel2: '/ adminisztrátorok',
    bgClass: 'bg-dark-card',
    bgImage: './img/admins_bcg.png',
    bottomInfo: true,
    bottomLabel: 'Online:',
    bottomValue: (admins.value.length || 0).toString(),
  },
  {
    id: 'animals',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Háziállatok:',
    topLabel2: (animals.value.length || 0).toString(),
    bgClass: 'bg-pets',
    bgImage: './img/pets_bcg.png',
  },
  {
    id: 'invite',
    colSpan: 2, rowSpan: 1,
    topLabel1: 'Meghívó',
    topLabel2: 'rendszer',
    bgClass: 'bg-invite',
    bottomInfo: true,
    bottomLabel: 'Kódod:',
    bottomValue: inviteCode.value || '...',
  },
])

function cardStyle(card) {
  return {
    gridColumn: `span ${card.colSpan}`,
    gridRow: `span ${card.rowSpan}`,
  }
}

function openCard(card) {
  // Request data before expanding
  const resource = GetParentResourceName()
  if (card.id === 'vehicles') fetch(`https://${resource}/requestVehicles`, { method: 'POST', body: '{}' })
  if (card.id === 'animals') fetch(`https://${resource}/requestAnimals`, { method: 'POST', body: '{}' })
  if (card.id === 'interiors') fetch(`https://${resource}/requestInteriors`, { method: 'POST', body: '{}' })
  if (card.id === 'groups') fetch(`https://${resource}/requestGroups`, { method: 'POST', body: '{}' })
  if (card.id === 'admins') fetch(`https://${resource}/requestAdminList`, { method: 'POST', body: '{}' })
  if (card.id === 'invite') fetch(`https://${resource}/requestInviteData`, { method: 'POST', body: '{}' })
  if (card.id === 'news') fetch(`https://${resource}/requestNews`, { method: 'POST', body: '{}' })

  expandedCard.value = card
}

function closeExpanded() {
  expandedCard.value = null
}

function formatNumber(num) {
  if (!num) return '0'
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

function closeDashboard() {
  isOpen.value = false
  expandedCard.value = null
  fetch(`https://${GetParentResourceName()}/closeDashboard`, {
    method: 'POST',
    body: JSON.stringify({})
  })
}

function addNotification(type, message) {
  const id = Date.now() + Math.random()
  notifications.value.push({ id, type, message })
  setTimeout(() => {
    notifications.value = notifications.value.filter(n => n.id !== id)
  }, 4000)
}

function handleMessage(event) {
  const data = event.data
  if (!data || !data.action) return

  switch (data.action) {
    case 'open':
      isOpen.value = true
      expandedCard.value = null
      break
    case 'close':
      isOpen.value = false
      expandedCard.value = null
      break
    case 'updatePlayerData':
      playerData.value = data.data || {}
      break
    case 'updatePremiumBalance':
      playerData.value = { ...playerData.value, premiumBalance: data.balance }
      break
    case 'updateVehicles':
      vehicles.value = data.vehicles || []
      vehicleLimit.value = data.limit || 5
      break
    case 'updateInteriors':
      interiors.value = data.interiors || []
      interiorLimit.value = data.limit || 3
      break
    case 'updateAnimals':
      animals.value = data.animals || []
      break
    case 'updateGroups':
      groups.value = data.groups || []
      break
    case 'updateSettings':
      settings.value = data.settings || {}
      break
    case 'updatePremiumShop':
      premiumShop.value = data.shop || []
      break
    case 'updateNews':
      news.value = data.news || {}
      break
    case 'updateAdmins':
      admins.value = data.admins || []
      break
    case 'updateKeybinds':
      keybinds.value = data.keybinds || []
      break
    case 'updateInviteData':
      inviteCode.value = data.inviteCode || ''
      invitedPlayers.value = data.invitedPlayers || []
      awards.value = data.awards || []
      break
    case 'notify':
      addNotification(data.notifyType, data.message)
      break
  }
}

function GetParentResourceName() {
  return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard'
}

window.__dashboard = { formatNumber, addNotification, GetParentResourceName }

onMounted(() => { window.addEventListener('message', handleMessage) })
onUnmounted(() => { window.removeEventListener('message', handleMessage) })
</script>

<style>
@import './assets/main.css';
</style>
