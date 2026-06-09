<template>
  <div id="dashboard-app" v-show="isOpen" @keydown.escape="closeDashboard">
    <div class="dashboard-overlay" @click="closeDashboard"></div>
    <div class="dashboard-container">
      <!-- Sidebar -->
      <aside class="sidebar">
        <div class="sidebar-header">
          <h1 class="logo">RealRPG</h1>
          <span class="subtitle">Dashboard</span>
        </div>
        <nav class="sidebar-nav">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            :class="['nav-btn', { active: activeTab === tab.id }]"
            @click="activeTab = tab.id"
          >
            <i :class="tab.icon"></i>
            <span>{{ tab.label }}</span>
          </button>
        </nav>
        <div class="sidebar-footer">
          <div class="pp-balance">
            <span class="pp-label">Premium:</span>
            <span class="pp-value">{{ formatNumber(playerData.premiumBalance || 0) }} PP</span>
          </div>
        </div>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <header class="content-header">
          <h2>{{ currentTabLabel }}</h2>
          <button class="close-btn" @click="closeDashboard">&times;</button>
        </header>

        <div class="content-body">
          <!-- Character Info -->
          <CharacterPanel v-if="activeTab === 'character'" :data="playerData" />

          <!-- Vehicles -->
          <VehiclesPanel v-if="activeTab === 'vehicles'" :vehicles="vehicles" :limit="vehicleLimit" />

          <!-- Interiors -->
          <InteriorsPanel v-if="activeTab === 'interiors'" :interiors="interiors" :limit="interiorLimit" />

          <!-- Animals -->
          <AnimalsPanel v-if="activeTab === 'animals'" :animals="animals" />

          <!-- Groups -->
          <GroupsPanel v-if="activeTab === 'groups'" :groups="groups" />

          <!-- Settings -->
          <SettingsPanel v-if="activeTab === 'settings'" :settings="settings" />

          <!-- Premium Shop -->
          <PremiumShopPanel v-if="activeTab === 'shop'" :shop="premiumShop" :balance="playerData.premiumBalance || 0" />

          <!-- News -->
          <NewsPanel v-if="activeTab === 'news'" :news="news" />

          <!-- Admins / Report -->
          <AdminPanel v-if="activeTab === 'admins'" :admins="admins" />

          <!-- Invite System -->
          <InvitePanel v-if="activeTab === 'invite'" :inviteCode="inviteCode" :invitedPlayers="invitedPlayers" :awards="awards" />
        </div>
      </main>
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
const activeTab = ref('character')
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
const notifications = ref([])

const tabs = [
  { id: 'character', label: 'Karakter', icon: 'fas fa-user' },
  { id: 'vehicles', label: 'Jarmuvek', icon: 'fas fa-car' },
  { id: 'interiors', label: 'Interiorok', icon: 'fas fa-home' },
  { id: 'animals', label: 'Haziallatok', icon: 'fas fa-paw' },
  { id: 'groups', label: 'Frakciok', icon: 'fas fa-users' },
  { id: 'shop', label: 'Premium Shop', icon: 'fas fa-store' },
  { id: 'settings', label: 'Beallitasok', icon: 'fas fa-cog' },
  { id: 'news', label: 'Hirek', icon: 'fas fa-newspaper' },
  { id: 'admins', label: 'Adminok / Report', icon: 'fas fa-shield-alt' },
  { id: 'invite', label: 'Meghivo', icon: 'fas fa-envelope' },
]

const currentTabLabel = computed(() => {
  const tab = tabs.find(t => t.id === activeTab.value)
  return tab ? tab.label : ''
})

function formatNumber(num) {
  if (!num) return '0'
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

function closeDashboard() {
  isOpen.value = false
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

// NUI message handler
function handleMessage(event) {
  const data = event.data
  if (!data || !data.action) return

  switch (data.action) {
    case 'open':
      isOpen.value = true
      break
    case 'close':
      isOpen.value = false
      break
    case 'updatePlayerData':
      playerData.value = data.data || {}
      break
    case 'updatePremiumBalance':
      playerData.value.premiumBalance = data.balance
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

// Helper for NUI callbacks
function GetParentResourceName() {
  return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard'
}

// Expose to child components
window.__dashboard = {
  formatNumber,
  addNotification,
  GetParentResourceName: GetParentResourceName
}

onMounted(() => {
  window.addEventListener('message', handleMessage)
})

onUnmounted(() => {
  window.removeEventListener('message', handleMessage)
})
</script>

<style>
@import './assets/main.css';
</style>
