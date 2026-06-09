<template>
  <div class="admin-panel">
    <div class="grid-2">
      <!-- Report Section -->
      <div class="card">
        <h3 class="card-title">Report rendszer</h3>
        <p class="desc">Ha barmiyen problemaba utkoznel, a Report rendszeren keresztul tudsz segtseget kerni.</p>
        <input v-model="reportTitle" class="input-field" placeholder="Bejelentes cime" style="margin-top:10px" />
        <select v-model="reportCategory" class="input-field" style="margin-top:8px">
          <option value="">Valassz kategoriat...</option>
          <option value="bug">Bug</option>
          <option value="player">Jatekos bejelentes</option>
          <option value="question">Kerdes</option>
          <option value="other">Egyeb</option>
        </select>
        <textarea v-model="reportDesc" class="input-field" placeholder="Leiras..." rows="4" style="margin-top:8px; resize: vertical"></textarea>
        <button class="btn btn-green" style="margin-top:10px" @click="sendReport">Report elkuldese</button>
      </div>

      <!-- Admin List -->
      <div class="card">
        <h3 class="card-title">Online adminisztratorok ({{ admins.length }})</h3>
        <div class="admin-list">
          <div v-for="admin in admins" :key="admin.id" class="admin-row">
            <span class="admin-name">{{ admin.name }}</span>
            <span :class="['admin-level', admin.onDuty ? 'on-duty' : 'off-duty']">
              {{ getAdminTitle(admin.level) }}
              <span v-if="admin.onDuty" class="duty-badge">DUTY</span>
            </span>
          </div>
          <div v-if="admins.length === 0" class="empty-state">Nincs online adminisztrator.</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
defineProps({ admins: { type: Array, default: () => [] } })

const reportTitle = ref('')
const reportCategory = ref('')
const reportDesc = ref('')

function getAdminTitle(level) {
  if (level >= 11) return 'Tulajdonos'
  if (level >= 10) return 'Fejleszto'
  if (level >= 9) return 'SysEngineer'
  if (level >= 8) return 'Manager'
  if (level >= 7) return 'SzuperAdmin'
  if (level >= 6) return 'FoAdmin'
  return 'Admin ' + level
}

function sendReport() {
  if (!reportTitle.value || !reportCategory.value || !reportDesc.value) return
  fetch(`https://${getResource()}/createReport`, {
    method: 'POST',
    body: JSON.stringify({ title: reportTitle.value, category: reportCategory.value, description: reportDesc.value })
  })
  reportTitle.value = ''
  reportCategory.value = ''
  reportDesc.value = ''
}
function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
</script>

<style scoped>
.desc { color: var(--text-secondary); font-size: 12px; line-height: 1.5; }
.admin-list { display: flex; flex-direction: column; gap: 6px; max-height: 400px; overflow-y: auto; }
.admin-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; background: var(--bg-darker); border-radius: var(--radius-sm); }
.admin-name { font-size: 13px; font-weight: 500; }
.admin-level { font-size: 12px; }
.admin-level.on-duty { color: var(--accent-green); }
.admin-level.off-duty { color: var(--text-muted); }
.duty-badge { background: var(--accent-green); color: #000; font-size: 10px; padding: 1px 5px; border-radius: 3px; margin-left: 5px; font-weight: 700; }
.empty-state { text-align: center; color: var(--text-muted); padding: 20px; }
</style>
