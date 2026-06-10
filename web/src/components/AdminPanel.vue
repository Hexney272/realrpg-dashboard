<template>
  <div class="admin-panel">
    <div class="grid-2">
      <!-- Report -->
      <div class="card">
        <h3 class="card-title">Report rendszer</h3>
        <p class="hint">Ha bármilyen problémába ütköznél, esetleg kérdésed lenne, itt, a Report rendszeren keresztül tudsz segítséget kérni az adminisztrátor csapat felé.</p>
        <input v-model="title" class="input-field" placeholder="Bejelentés rövid címe" style="margin-top:10px" maxlength="32"/>
        <select v-model="cat" class="input-field" style="margin-top:8px">
          <option value="">Válassz kategóriát...</option>
          <option value="bug">Bug</option>
          <option value="player">Játékos bejelentés</option>
          <option value="question">Kérdés</option>
          <option value="other">Egyéb</option>
        </select>
        <textarea v-model="desc" class="input-field" placeholder="Fogalmazd meg a problémád..." rows="5" style="margin-top:8px;resize:vertical" maxlength="750"></textarea>
        <p v-if="error" class="error-msg">{{ error }}</p>
        <p v-if="success" class="success-msg">{{ success }}</p>
        <div class="btn-row">
          <button class="btn btn-green" @click="send">Report létrehozása</button>
        </div>
      </div>

      <!-- Admin list -->
      <div class="card">
        <h3 class="card-title">Adminisztrátorok ({{ onlineAdminCount }} online)</h3>
        <div class="admin-table">
          <div class="table-head">
            <span>Név</span>
            <span>ID</span>
            <span>Rang</span>
          </div>
          <div v-for="a in admins" :key="a.id + a.name" :class="['table-row', { online: a.online, offline: !a.online }]">
            <span class="a-name">
              <span class="status-dot" :class="a.online ? 'dot-online' : 'dot-offline'"></span>
              {{ a.name }}
            </span>
            <span class="a-id">{{ a.online ? a.id : '—' }}</span>
            <span :class="['a-level', levelColor(a.level)]">{{ a.title || levelTitle(a.level) }}</span>
          </div>
          <div v-if="!admins.length" class="empty-state">Nincs regisztrált adminisztrátor.</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({ admins: { type: Array, default: () => [] } })
const title = ref(''); const cat = ref(''); const desc = ref('')
const error = ref(''); const success = ref('')

const onlineAdminCount = computed(() => props.admins.filter(a => a.online).length)

function post(e, d) { fetch(`https://${window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard'}/${e}`, { method: 'POST', body: JSON.stringify(d) }) }

function send() {
  error.value = ''
  success.value = ''
  if (!cat.value) { error.value = 'Válassz kategóriát!'; return }
  if (!title.value || title.value.length < 1) { error.value = 'Add meg a bejelentés címét!'; return }
  if (!desc.value || desc.value.length < 1) { error.value = 'Add meg a bejelentés leírását!'; return }
  post('createReport', { title: title.value, category: cat.value, description: desc.value })
  success.value = 'Report sikeresen elküldve!'
  title.value = ''; cat.value = ''; desc.value = ''
  setTimeout(() => { success.value = '' }, 3000)
}

function levelTitle(l) {
  if (l >= 11) return 'Tulajdonos'
  if (l >= 10) return 'Fejlesztő'
  if (l >= 9) return 'SysEngineer'
  if (l >= 8) return 'Manager'
  if (l >= 7) return 'SzuperAdmin'
  if (l >= 6) return 'Admin'
  if (l >= 3) return 'Moderátor'
  if (l >= 1) return 'Adminsegéd'
  return 'Staff'
}

function levelColor(l) {
  if (l >= 11) return 'lv-red'
  if (l >= 10) return 'lv-blue'
  if (l >= 6) return 'lv-green'
  if (l >= 3) return 'lv-yellow'
  return 'lv-muted'
}
</script>

<style scoped>
.hint { color: var(--text-secondary); font-size: 12px; line-height: 1.6 }
.btn-row { margin-top: 12px }
.error-msg { color: var(--sightred); font-size: 12px; font-weight: 700; margin-top: 8px }
.success-msg { color: var(--sightgreen); font-size: 12px; font-weight: 700; margin-top: 8px }
.admin-table { display: flex; flex-direction: column; gap: 2px; max-height: 50vh; overflow-y: auto }
.table-head { display: grid; grid-template-columns: 1fr 50px 120px; padding: 8px 10px; background: var(--sightgrey3); font-size: 11px; font-weight: 700; border-radius: 3px; color: var(--text-muted); text-transform: uppercase; letter-spacing: .5px }
.table-row { display: grid; grid-template-columns: 1fr 50px 120px; padding: 8px 10px; font-size: 12px; border-bottom: 1px solid var(--sightgrey3); transition: background .15s }
.table-row:hover { background: var(--sightgrey3) }
.table-row.offline .a-name { color: var(--sightlightgrey) }
.a-name { font-weight: 600; display: flex; align-items: center; gap: 6px }
.a-id { color: var(--text-muted); text-align: center }
.a-level { font-weight: 700; text-align: right; font-size: 11px }
.lv-red { color: var(--sightred) }
.lv-blue { color: var(--sightblue) }
.lv-green { color: var(--sightgreen) }
.lv-yellow { color: var(--sightyellow) }
.lv-muted { color: var(--sightlightgrey) }
.status-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0 }
.dot-online { background: var(--sightgreen); box-shadow: 0 0 6px var(--sightgreen) }
.dot-offline { background: var(--sightgrey4) }
</style>
