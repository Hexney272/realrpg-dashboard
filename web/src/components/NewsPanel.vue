<template>
  <div class="news-panel">
    <div class="card news-card">
      <div class="news-badges" v-if="news.badges">
        <span v-for="(b,i) in news.badges" :key="i" class="badge" :style="{background:b.color,color:'#000'}">{{ b.text }}</span>
      </div>
      <h2 class="news-title">{{ news.title || 'Nincs friss hír' }}</h2>
      <span class="news-date">{{ news.date || '' }}</span>
      <p class="news-hint">A hír további olvasásához csatlakozz a Discord szerverünkre!</p>
    </div>
  </div>
</template>
<script setup>
defineProps({news:{type:Object,default:()=>({})}})
</script>
<style scoped>
.news-card{position:relative;overflow:hidden}
.news-badges{display:flex;gap:6px;margin-bottom:10px;flex-wrap:wrap}
.news-title{font-size:24px;font-weight:800;margin-bottom:4px;text-transform:uppercase}
.news-date{font-size:12px;color:var(--text-muted)}
.news-hint{margin-top:16px;font-size:12px;color:var(--text-secondary);font-style:italic}
</style>
