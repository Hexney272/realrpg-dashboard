<template>
  <div class="groups-panel">
    <div v-if="!groups.length" class="card empty-card">
      <p class="empty-text">Nem vagy egy frakció/munkahely tagja sem.</p>
      <p class="empty-hint">Ha munkát szeretnél, keresd fel a megfelelő NPC-t a városban!</p>
    </div>

    <div v-else>
      <!-- Group selector (if multiple) -->
      <div v-if="groups.length > 1" class="group-tabs">
        <button v-for="(g,i) in groups" :key="g.id" :class="['tab-btn',{active:selectedGroup===i}]" @click="selectedGroup=i">
          {{ g.name }}
        </button>
      </div>

      <!-- Selected group details -->
      <div v-if="currentGroup" class="group-content">
        <div class="grid-2">
          <!-- Left: Group info -->
          <div class="card">
            <h3 class="card-title">{{ currentGroup.name }}</h3>
            <div class="stat-row"><span class="stat-label">A te rangod:</span><span class="stat-value">{{ currentGroup.rank }}</span></div>
            <div class="stat-row"><span class="stat-label">Rang szint:</span><span class="stat-value">{{ currentGroup.rankGrade }}</span></div>
            <div class="stat-row"><span class="stat-label">Összes tag:</span><span class="stat-value">{{ currentGroup.memberCount }}</span></div>
            <div class="stat-row"><span class="stat-label">Online tagok:</span><span class="stat-value" style="color:var(--sightgreen)">{{ currentGroup.onlineCount }}</span></div>

            <!-- Grades -->
            <div v-if="currentGroup.grades && currentGroup.grades.length" class="grades-section">
              <h4 class="section-title">Rangok</h4>
              <div v-for="g in currentGroup.grades" :key="g.grade" class="grade-row">
                <span class="grade-num">[{{ g.grade }}]</span>
                <span class="grade-label">{{ g.label }}</span>
              </div>
            </div>
          </div>

          <!-- Right: Member list -->
          <div class="card">
            <h3 class="card-title">Tagok ({{ currentGroup.members ? currentGroup.members.length : 0 }})</h3>
            <div class="member-list" v-if="currentGroup.members && currentGroup.members.length">
              <div v-for="(m,i) in currentGroup.members" :key="i" class="member-row">
                <div class="member-left">
                  <span class="member-status" :class="m.online ? 'online' : 'offline'"></span>
                  <span class="member-name">{{ m.name }}</span>
                </div>
                <span class="member-grade">{{ m.gradeLabel }}</span>
              </div>
            </div>
            <div v-else class="empty-state">
              <p>A taglista betöltéséhez nyisd meg a frakció panelt.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
const props = defineProps({ groups: { type: Array, default: () => [] } })

const selectedGroup = ref(0)
const currentGroup = computed(() => props.groups[selectedGroup.value] || null)
</script>

<style scoped>
.empty-card{text-align:center;padding:40px}
.empty-text{font-size:15px;font-weight:600;color:var(--text-secondary);margin-bottom:6px}
.empty-hint{font-size:12px;color:var(--text-muted)}
.group-tabs{display:flex;gap:4px;margin-bottom:14px}
.tab-btn{padding:8px 16px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:12px;font-weight:700;cursor:pointer;transition:all .2s;text-transform:uppercase}
.tab-btn:hover{border-color:var(--sightgreen);color:var(--sightgreen)}
.tab-btn.active{background:var(--sightgreen);color:#000;border-color:var(--sightgreen)}
.grades-section{margin-top:14px;padding-top:10px;border-top:1px solid var(--sightgrey3)}
.section-title{font-size:12px;font-weight:700;color:var(--sightgreen);text-transform:uppercase;margin-bottom:6px}
.grade-row{display:flex;gap:8px;padding:4px 0;font-size:12px}
.grade-num{color:var(--sightblue);font-weight:700;min-width:24px}
.grade-label{color:var(--text-secondary)}
.member-list{display:flex;flex-direction:column;gap:3px;max-height:50vh;overflow-y:auto}
.member-row{display:flex;justify-content:space-between;align-items:center;padding:7px 10px;background:var(--sightgrey1);border-radius:3px;font-size:12px}
.member-left{display:flex;align-items:center;gap:8px}
.member-status{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.member-status.online{background:var(--sightgreen);box-shadow:0 0 6px var(--sightgreen)}
.member-status.offline{background:var(--sightgrey4)}
.member-name{font-weight:600}
.member-grade{color:var(--sightblue);font-weight:600;font-size:11px}
</style>
