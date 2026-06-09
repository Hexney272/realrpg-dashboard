<template>
  <div class="news-panel">
    <!-- Featured news card -->
    <div class="featured-news card">
      <div class="news-image-bg" :style="{backgroundImage:'url(./img/def.png)'}"></div>
      <div class="news-overlay">
        <div class="news-badges" v-if="news.badges && news.badges.length">
          <span v-for="(b,i) in news.badges" :key="i" class="badge" :style="{background:b.color,color:'#000'}">{{ b.text }}</span>
        </div>
        <h2 class="news-title">{{ news.title || 'Nincs friss hír' }}</h2>
        <span class="news-date">{{ news.date || '' }}</span>
      </div>
    </div>

    <!-- Changelog entries -->
    <div class="card">
      <h3 class="card-title">Korábbi frissítések</h3>
      <div class="changelog-list">
        <div v-for="(entry, i) in changelogEntries" :key="i" class="changelog-entry">
          <div class="changelog-header">
            <div class="changelog-badges">
              <span v-for="(b,j) in entry.badges" :key="j" class="badge" :style="{background:b.color,color:'#000'}">{{ b.text }}</span>
            </div>
            <span class="changelog-date">{{ entry.date }}</span>
          </div>
          <h4 class="changelog-title">{{ entry.title }}</h4>
          <p class="changelog-desc">{{ entry.description }}</p>
        </div>
      </div>
    </div>

    <!-- Discord hint -->
    <div class="card discord-card">
      <div class="discord-row">
        <div class="discord-text">
          <h4>Részletesebb changelog</h4>
          <p>A teljes frissítési jegyzéket a Discord szerverünkön találod meg!</p>
        </div>
        <button class="btn btn-blue" @click="copyDiscord">Discord link másolása</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
const props = defineProps({ news: { type: Object, default: () => ({}) } })

// Static changelog entries (would come from server in production)
const changelogEntries = ref([
  {
    title: 'Aranybankrablás',
    date: '2025.02.15',
    badges: [{ text: 'Update', color: '#4ae06c' }, { text: 'Aranybankrablás', color: '#f5d44a' }],
    description: 'Új bankrablási rendszer került a szerverre. Az aranybankot 6+ fős csapattal lehet kirabolni, egyedi fegyverekkel és járművekkel.'
  },
  {
    title: 'Hotfix #42',
    date: '2025.02.14',
    badges: [{ text: 'Hotfix', color: '#4a9ef5' }],
    description: 'Javítva: járműmotor spawn hiba, frakció chat duplikáció, interior ajtó hang bug.'
  },
  {
    title: 'Téli esemény vége',
    date: '2025.02.10',
    badges: [{ text: 'Event', color: '#a855f7' }],
    description: 'A téli esemény véget ért. A gyűjtött pontokért még 3 napig lehet beváltani jutalmakat a /event menüben.'
  },
  {
    title: 'Új fegyverek + Skin rendszer',
    date: '2025.02.05',
    badges: [{ text: 'Update', color: '#4ae06c' }, { text: 'Fegyverek', color: '#f5944a' }],
    description: 'Hozzáadva: Vipera, M110, AR-15 Holo/Aimpoint variánsok. Minden fegyverhez egyedi skinek vásárolhatók a Premium shopban.'
  },
  {
    title: 'Farm rendszer fejlesztés',
    date: '2025.01.28',
    badges: [{ text: 'Update', color: '#4ae06c' }],
    description: 'Növénytermesztés és állattenyésztés teljes átdolgozás. Új növények: dohány, gyapot, napraforgó. Új állatok: kecske, disznó.'
  },
  {
    title: 'Hotfix #41',
    date: '2025.01.25',
    badges: [{ text: 'Hotfix', color: '#4a9ef5' }],
    description: 'Javítva: NOS palack töltés, tempomat 200+ km/h bug, dashboard Premium egyenleg frissítés.'
  },
  {
    title: 'Meghívó rendszer',
    date: '2025.01.20',
    badges: [{ text: 'Új funkció', color: '#4ae06c' }, { text: 'Meghívó', color: '#f5d44a' }],
    description: 'Invite kóddal most már prémium pontokat és pénzt szerezhetsz a barátaid meghívásáért! 35+ jutalmazási szint.'
  },
])

function copyDiscord() {
  if (navigator.clipboard) {
    navigator.clipboard.writeText('discord.gg/realrpg')
  }
  // Notify
  const resource = window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard'
  fetch(`https://${resource}/closeDashboard`, { method: 'POST', body: '{}' }) // won't actually close, just to notify
}
</script>

<style scoped>
.featured-news{position:relative;min-height:180px;overflow:hidden;padding:0}
.news-image-bg{position:absolute;top:0;left:0;width:100%;height:100%;background-size:cover;background-position:center;opacity:.3}
.news-overlay{position:relative;padding:20px;display:flex;flex-direction:column;justify-content:flex-end;min-height:180px}
.news-badges{display:flex;gap:6px;margin-bottom:10px;flex-wrap:wrap}
.news-title{font-size:26px;font-weight:800;text-transform:uppercase;text-shadow:0 2px 8px rgba(0,0,0,.5)}
.news-date{font-size:12px;color:var(--text-muted);margin-top:4px}

.changelog-list{display:flex;flex-direction:column;gap:12px}
.changelog-entry{padding:12px;background:var(--sightgrey1);border-radius:4px;border-left:3px solid var(--sightgrey4);transition:border-color .2s}
.changelog-entry:hover{border-left-color:var(--sightgreen)}
.changelog-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:6px}
.changelog-badges{display:flex;gap:4px;flex-wrap:wrap}
.changelog-date{font-size:11px;color:var(--text-muted)}
.changelog-title{font-size:14px;font-weight:700;margin-bottom:4px}
.changelog-desc{font-size:12px;color:var(--text-secondary);line-height:1.5}

.discord-card{margin-top:4px}
.discord-row{display:flex;justify-content:space-between;align-items:center;gap:16px}
.discord-text h4{font-size:14px;font-weight:700;margin-bottom:2px}
.discord-text p{font-size:12px;color:var(--text-secondary)}

.badge{display:inline-block;padding:2px 8px;border-radius:3px;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.3px}
</style>
