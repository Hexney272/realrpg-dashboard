<template>
  <div class="ppshop-panel">
    <div class="shop-header">
      <div class="menu-tabs">
        <button v-for="(m,i) in shop" :key="i" :class="['tab-btn',{active:tab===i}]" @click="tab=i">{{ m.name }}</button>
      </div>
      <div class="balance-box">Egyenleg: <strong>{{ fmt(balance) }} PP</strong></div>
    </div>
    <div class="shop-grid" v-if="items.length">
      <div v-for="(item,i) in items" :key="i" class="shop-card">
        <div class="item-icon">{{ item.item==='money'?'$':'🔫' }}</div>
        <div class="item-name">{{ item.item }}</div>
        <div class="item-price-tag"><span class="price-num">{{ fmt(item.price) }}</span> PP</div>
        <button :class="['btn',item.price<=balance?'btn-blue':'btn-disabled btn-red']" :disabled="item.price>balance" @click="buy(i)">
          {{ item.price<=balance?'VÁSÁRLÁS':'Nincs elég PP' }}
        </button>
      </div>
    </div>
    <div v-else class="empty-state">Nincs elem.</div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
const props = defineProps({shop:{type:Array,default:()=>[]},balance:{type:Number,default:0}})
const tab=ref(0)
const items=computed(()=>(props.shop[tab.value]?.items)||[])
function fmt(n){return(n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.')}
function buy(i){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/buyPremiumItem`,{method:'POST',body:JSON.stringify({menuIndex:tab.value+1,itemIndex:i+1,amount:1})})}
</script>
<style scoped>
.shop-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;flex-wrap:wrap;gap:8px}
.menu-tabs{display:flex;gap:4px;flex-wrap:wrap}
.tab-btn{padding:6px 14px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:12px;font-weight:700;cursor:pointer;transition:all .2s;text-transform:uppercase}
.tab-btn:hover{border-color:var(--sightblue);color:var(--sightblue)}
.tab-btn.active{background:var(--sightblue);color:#fff;border-color:var(--sightblue)}
.balance-box{font-size:13px;color:var(--text-secondary)}
.balance-box strong{color:var(--sightblue)}
.shop-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:10px}
.shop-card{background:var(--sightgrey2);border:1px solid var(--sightgrey3);border-radius:4px;padding:14px;text-align:center;display:flex;flex-direction:column;align-items:center;gap:6px;transition:border-color .2s}
.shop-card:hover{border-color:var(--sightblue)}
.item-icon{font-size:28px;margin-bottom:4px}
.item-name{font-size:12px;font-weight:700;text-transform:uppercase;color:var(--text-primary)}
.item-price-tag{background:var(--sightgreen);color:#000;padding:2px 8px;border-radius:2px;font-size:12px;font-weight:700}
.price-num{font-size:13px}
</style>
