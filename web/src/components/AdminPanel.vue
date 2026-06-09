<template>
  <div class="admin-panel">
    <div class="grid-2">
      <!-- Report -->
      <div class="card">
        <h3 class="card-title">Report rendszer</h3>
        <p class="hint">Ha bármilyen problémába ütköznél, esetleg kérdésed lenne, itt, a Report rendszeren keresztül tudsz segítséget kérni. Használd a Report létrehozása gombot ahhoz, hogy üzenetet küldj az adminisztrátor csapat felé.</p>
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
          <button class="btn btn-green" @click="send">Elküldés</button>
        </div>
      </div>
      <!-- Admin list -->
      <div class="card">
        <h3 class="card-title">Online adminisztrátorok ({{ admins.length }})</h3>
        <div class="admin-table">
          <div class="table-head"><span>Név</span><span>ID</span><span>Adminszint</span></div>
          <div v-for="a in admins" :key="a.id" :class="['table-row',{duty:a.onDuty}]">
            <span class="a-name">{{ a.name }}</span>
            <span class="a-id">{{ a.id }}</span>
            <span :class="['a-level',levelColor(a.level)]">{{ levelTitle(a.level) }}</span>
          </div>
          <div v-if="!admins.length" class="empty-state">Nincs online adminisztrátor.</div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
defineProps({admins:{type:Array,default:()=>[]}})
const title=ref('');const cat=ref('');const desc=ref('')
const error=ref('');const success=ref('')

function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}

function send(){
  error.value = ''
  success.value = ''
  if(!cat.value){ error.value='Válassz kategóriát!'; return }
  if(!title.value || title.value.length < 1){ error.value='Add meg a bejelentés címét!'; return }
  if(!desc.value || desc.value.length < 1){ error.value='Add meg a bejelentés leírását!'; return }
  post('createReport',{title:title.value,category:cat.value,description:desc.value})
  success.value = 'Report sikeresen elküldve!'
  title.value='';cat.value='';desc.value=''
  setTimeout(()=>{success.value=''},3000)
}

function levelTitle(l){if(l>=11)return'Tulajdonos';if(l>=10)return'Fejlesztő';if(l>=9)return'SysEngineer';if(l>=8)return'Manager';if(l>=7)return'SzuperAdmin';if(l>=6)return'FőAdmin';return'Admin '+l}
function levelColor(l){if(l>=10)return'lv-red';if(l>=8)return'lv-blue';if(l>=6)return'lv-yellow';return'lv-green'}
</script>
<style scoped>
.hint{color:var(--text-secondary);font-size:12px;line-height:1.6}
.btn-row{margin-top:12px}
.error-msg{color:var(--sightred);font-size:12px;font-weight:700;margin-top:8px}
.success-msg{color:var(--sightgreen);font-size:12px;font-weight:700;margin-top:8px}
.admin-table{display:flex;flex-direction:column;gap:2px;max-height:45vh;overflow-y:auto}
.table-head{display:grid;grid-template-columns:1fr 50px 1fr;padding:8px 10px;background:var(--sightgrey3);font-size:12px;font-weight:700;border-radius:3px;color:var(--text-secondary)}
.table-row{display:grid;grid-template-columns:1fr 50px 1fr;padding:8px 10px;font-size:12px;border-bottom:1px solid var(--sightgrey3)}
.table-row.duty .a-name{color:var(--sightgreen)}
.a-name{font-weight:600}
.a-id{color:var(--text-muted);text-align:center}
.a-level{font-weight:600;text-align:right}
.lv-red{color:var(--sightred)}.lv-blue{color:var(--sightblue)}.lv-yellow{color:var(--sightyellow)}.lv-green{color:var(--sightgreen)}
</style>
