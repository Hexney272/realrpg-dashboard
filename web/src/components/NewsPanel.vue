<template>
  <div class="news-panel">
    <div class="card">
      <h3 class="card-title">{{ news.title || 'Nincs hir' }}</h3>
      <p class="news-date">{{ news.date || '' }}</p>
      <div class="news-badges" v-if="news.badges">
        <span v-for="(badge, i) in news.badges" :key="i" class="badge" :style="{ background: badge.color }">
          {{ badge.text }}
        </span>
      </div>
      <p class="news-hint">Tovabbi informaciokert csatlakozz a Discord szerverunkre!</p>
    </div>
  </div>
</template>

<script setup>
defineProps({ news: { type: Object, default: () => ({}) } })
</script>

<style scoped>
.news-date { color: var(--text-muted); font-size: 12px; margin-bottom: 10px; }
.news-badges { display: flex; gap: 6px; margin-bottom: 12px; flex-wrap: wrap; }
.news-hint { color: var(--text-secondary); font-size: 13px; margin-top: 15px; }
</style>
