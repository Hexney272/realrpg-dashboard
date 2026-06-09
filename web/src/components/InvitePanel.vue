<template>
  <div class="invite-panel">
    <div class="card">
      <h3 class="card-title">Meghivo rendszer</h3>
      <div class="invite-code-box">
        <span class="code-label">A te meghivo kodod:</span>
        <span class="code-value">{{ inviteCode || '...' }}</span>
      </div>
      <p class="desc">Oszd meg a meghivo kododat masokkal! Ha valaki a te kodddal regisztral, jutalmakat kaphatsz.</p>
    </div>

    <div class="card">
      <h3 class="card-title">Meghivott jatekosok ({{ invitedPlayers.length }})</h3>
      <div class="invited-list">
        <div v-for="player in invitedPlayers" :key="player.accountId" class="admin-row">
          <span>{{ player.name || 'N/A' }}</span>
          <span class="stat-value">LVL {{ getLevel(player.playedMinutes) }}</span>
        </div>
        <div v-if="invitedPlayers.length === 0" class="empty-state">Meg nem hivtal meg senkit.</div>
      </div>
    </div>

    <div class="card">
      <h3 class="card-title">Jutalmak</h3>
      <div class="awards-list">
        <div v-for="(award, i) in awards" :key="i" class="award-row">
          <div class="award-info">
            <span class="award-label">{{ award.label }}</span>
            <span class="award-reward">{{ formatReward(award.reward) }}</span>
          </div>
          <button
            v-if="award.done && !award.taken"
            class="btn btn-green"
            @click="claimAward(i + 1)"
          >Athozas</button>
          <span v-else-if="award.taken" class="badge" style="background: var(--accent-green)">Athozva</span>
          <span v-else class="badge" style="background: var(--bg-hover); color: var(--text-muted)">Folyamatban</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  inviteCode: { type: String, default: '' },
  invitedPlayers: { type: Array, default: () => [] },
  awards: { type: Array, default: () => [] }
})

function getLevel(minutes) { return Math.floor((minutes || 0) / 600) + 1 }
function formatReward(reward) {
  if (!reward) return ''
  const num = reward.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
  return reward.type === 'premium' ? num + ' PP' : num + ' $'
}
function claimAward(index) {
  fetch(`https://${getResource()}/claimAward`, { method: 'POST', body: JSON.stringify({ awardIndex: index }) })
}
function getResource() { return window.GetParentResourceName ? window.GetParentResourceName() : 'realrpg-dashboard' }
</script>

<style scoped>
.invite-code-box { display: flex; align-items: center; gap: 10px; padding: 12px; background: var(--bg-darker); border-radius: var(--radius-sm); margin-bottom: 10px; }
.code-label { color: var(--text-secondary); font-size: 13px; }
.code-value { color: var(--accent-green); font-weight: 700; font-size: 20px; letter-spacing: 2px; }
.desc { color: var(--text-secondary); font-size: 12px; }
.invited-list { display: flex; flex-direction: column; gap: 6px; max-height: 200px; overflow-y: auto; }
.admin-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; background: var(--bg-darker); border-radius: var(--radius-sm); }
.awards-list { display: flex; flex-direction: column; gap: 8px; }
.award-row { display: flex; justify-content: space-between; align-items: center; padding: 10px 12px; background: var(--bg-darker); border-radius: var(--radius-sm); }
.award-info { display: flex; flex-direction: column; }
.award-label { font-size: 12px; color: var(--text-secondary); }
.award-reward { font-size: 13px; font-weight: 600; color: var(--accent-blue); }
.empty-state { text-align: center; color: var(--text-muted); padding: 20px; }
</style>
