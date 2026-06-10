<template>
  <div class="invite-panel">
    <div class="card">
      <h3 class="card-title">Meghívó kódod</h3>
      <div class="code-box"><span class="code">{{ inviteCode || '...' }}</span></div>
      <p class="hint">Oszd meg a kódodat másokkal! Ha valaki ezzel regisztrál, jutalmakat kaphatsz.</p>
    </div>
    <div class="card">
      <h3 class="card-title">Meghívott játékosok ({{ invitedPlayers.length }})</h3>
      <div class="invited-list">
        <div v-for="p in invitedPlayers" :key="p.accountId" class="invited-row">
          <span class="p-name">{{ p.name||'N/A' }}</span>
          <span class="p-level">LVL {{ getLevel(p.playedMinutes) }}</span>
        </div>
        <div v-if="!invitedPlayers.length" class="empty-state">Még nem hívtál meg senkit.</div>
      </div>
    </div>
    <div class="card">
      <h3 class="card-title">Jutalmak</h3>
      <div class="awards-list">
        <div v-for="(a,i) in awards" :key="i" class="award-row">
          <div class="award-left">
            <span class="aw-label">{{ a.label }}</span>
            <span class="aw-reward">{{ fmtReward(a.reward) }}</span>
          </div>
          <button v-if="a.done&&!a.taken" class="btn btn-green" @click="claim(i+1)">Áthozás</button>
          <span v-else-if="a.taken" class="badge badge-done">Áthozva</span>
          <span v-else class="badge badge-pending">Folyamatban</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
defineProps({inviteCode:{type:String,default:''},invitedPlayers:{type:Array,default:()=>[]},awards:{type:Array,default:()=>[]}})
function getLevel(m){return Math.floor((m||0)/600)+1}
function fmtReward(r){if(!r)return'';const n=r.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.');return r.type==='premium'?n+' RC':n+' $'}
function claim(i){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/claimAward`,{method:'POST',body:JSON.stringify({awardIndex:i})})}
</script>
<style scoped>
.code-box{background:var(--sightgrey1);padding:14px;border-radius:4px;text-align:center;margin-bottom:10px;border:1px solid var(--sightgrey3)}
.code{font-size:28px;font-weight:800;letter-spacing:4px;color:var(--sightgreen)}
.hint{color:var(--text-secondary);font-size:12px}
.invited-list{display:flex;flex-direction:column;gap:4px;max-height:180px;overflow-y:auto}
.invited-row{display:flex;justify-content:space-between;padding:8px 10px;background:var(--sightgrey1);border-radius:3px;font-size:12px}
.p-name{font-weight:600}
.p-level{color:var(--sightgreen);font-weight:700}
.awards-list{display:flex;flex-direction:column;gap:6px}
.award-row{display:flex;justify-content:space-between;align-items:center;padding:10px 12px;background:var(--sightgrey1);border-radius:3px}
.award-left{display:flex;flex-direction:column}
.aw-label{font-size:12px;color:var(--text-secondary)}
.aw-reward{font-size:13px;font-weight:700;color:var(--sightblue)}
.badge-done{background:var(--sightgreen);color:#000;padding:3px 8px;border-radius:3px;font-size:10px;font-weight:700}
.badge-pending{background:var(--sightgrey3);color:var(--text-muted);padding:3px 8px;border-radius:3px;font-size:10px;font-weight:700}
</style>
